module cpu_top_soc (
    input  wire clk,  // 系统时钟
    input  wire rst,  // 复位（高有效）
    input  wire rx,   // UART 接收引脚
    output wire tx    // UART 发送引脚
);
  // CPU 到 ROM 的信号（指令获取，独立总线）
  wire [31:0] cpu_to_rom_addr;  // CPU 输出到 ROM 的指令地址
  wire [31:0] rom_to_cpu_inst;  // ROM 输出到 CPU 的指令
  wire [31:0] rom_data_out;  // ROM 数据输出（复用）

  // CPU 到总线的信号（数据访问）
  wire [31:0] cpu_to_bus_addr;  // CPU 输出到总线的数据地址
  wire [31:0] cpu_to_bus_data;  // CPU 输出到总线的写数据
  wire [31:0] bus_to_cpu_data;  // 总线返回到 CPU 的读数据
  wire        cpu_to_bus_we;  // 数据写使能
  wire        cpu_to_bus_re;  // 数据读使能
  wire [ 2:0] cpu_to_bus_size;  // 数据大小（字节、半字、字）
  wire        cpu_to_bus_req;  // CPU 数据请求信号

  // 总线到从设备的信号
  wire [31:0] slave0_addr;  // RAM 地址
  wire [31:0] slave0_data_o;  // RAM 写数据
  wire [31:0] slave0_data_i;  // RAM 读数据
  wire        slave0_we;  // RAM 写使能
  wire        slave0_re;  // RAM 读使能
  wire [ 2:0] slave0_size;  // RAM 数据大小

  wire [31:0] slave1_addr;  // ROM 地址
  wire [31:0] slave1_data_o;  // ROM 写数据
  wire [31:0] slave1_data_i;  // ROM 读数据
  wire        slave1_we;  // ROM 写使能

  wire [31:0] slave2_addr;  // Timer 地址
  wire [31:0] slave2_data_o;  // Timer 写数据
  wire [31:0] slave2_data_i;  // Timer 读数据
  wire        slave2_we;  // Timer 写使能

  wire [31:0] slave3_addr;  // UART 地址
  wire [31:0] slave3_data_o;  // UART 写数据
  wire [31:0] slave3_data_i;  // UART 读数据
  wire        slave3_we;  // UART 写使能

  wire [31:0] slave4_addr;  // GPIO 地址
  wire [31:0] slave4_data_o;  // GPIO 写数据
  wire [31:0] slave4_data_i;  // GPIO 读数据
  wire        slave4_we;  // GPIO 写使能

  wire [31:0] slave5_addr;  // SPI 地址
  wire [31:0] slave5_data_o;  // SPI 写数据
  wire [31:0] slave5_data_i;  // SPI 读数据
  wire        slave5_we;  // SPI 写使能

  // 总线保持信号
  wire        bus_hold_flag;

  // 中断信号
  wire        timer_int;
  wire [ 7:0] int_flags;
  assign int_flags = {7'b0, timer_int};

  // CPU 实例化
  cpu_top u_cpu_top (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (rom_to_cpu_inst),
      .inst_addr_o(cpu_to_rom_addr),
      .data_addr_o(cpu_to_bus_addr),
      .data_o     (cpu_to_bus_data),
      .data_we_o  (cpu_to_bus_we),
      .data_re_o  (cpu_to_bus_re),
      .data_size_o(cpu_to_bus_size),
      .data_i     (slave0_data_i),
      .int_i      (int_flags),
      .hold_flag_i(bus_hold_flag)
  );

  // RAM 实例化（数据存储，连接 slave_0）
  ram u_ram (
      .clk       (clk),
      .mem_we_i  (slave0_we),
      .mem_addr_i(slave0_addr),
      .mem_data_i(slave0_data_o),
      .mem_data_o(slave0_data_i),
      .mem_re_i  (slave0_re),
      .mem_size_i(slave0_size)
  );

  // ROM 实例化（指令存储，支持独立指令总线和 RIB 访问）
  rom u_rom (
      .clk   (clk),
      .rst   (rst),
      .we_i  (slave1_we),
      .addr_i(slave1_we ? slave1_addr : cpu_to_rom_addr),  // 优先 RIB 写
      .data_i(slave1_data_o),
      .data_o(rom_data_out)
  );
  assign rom_to_cpu_inst = rom_data_out;
  assign slave1_data_i   = rom_data_out;

  // Timer 实例化
  timer u_timer (
      .clk   (clk),
      .rst   (rst),
      .we_i  (slave2_we),
      .addr_i(slave2_addr),
      .data_i(slave2_data_o),
      .data_o(slave2_data_i),
      .int_o (timer_int)
  );

  // UART 实例化
  uart u_uart (
      .clk   (clk),
      .rst   (rst),
      .we_i  (slave3_we),
      .addr_i(slave3_addr),
      .data_i(slave3_data_o),
      .data_o(slave3_data_i),
      .rx    (rx),
      .tx    (tx)
  );

  // GPIO 实例化
  gpio u_gpio (
      .clk   (clk),
      .rst   (rst),
      .we_i  (slave4_we),
      .addr_i(slave4_addr),
      .data_i(slave4_data_o),
      .data_o(slave4_data_i)
  );

  // SPI 实例化
  spi u_spi (
      .clk   (clk),
      .rst   (rst),
      .we_i  (slave5_we),
      .addr_i(slave5_addr),
      .data_i(slave5_data_o),
      .data_o(slave5_data_i)
  );

  // RIB 总线实例化（移除 m1 接口）
  rib u_rib (
      .clk        (clk),
      .rst        (rst),
      // Master 0: CPU 数据访问 (RAM, ROM, Timer, UART, GPIO, SPI)
      .m0_addr_i  (cpu_to_bus_addr),
      .m0_data_i  (cpu_to_bus_data),
      .m0_data_o  (bus_to_cpu_data),
      .m0_req_i   (cpu_to_bus_req),
      .m0_we_i    (cpu_to_bus_we),
      .m0_re_i    (cpu_to_bus_re),
      .m0_size_i  (cpu_to_bus_size),
      // Master 1: 未使用（指令获取已分离）
      .m1_addr_i  (32'h0),
      .m1_data_i  (32'h0),
      .m1_data_o  (),
      .m1_req_i   (1'b0),
      .m1_we_i    (1'b0),
      // Master 2: 未使用
      .m2_addr_i  (32'h0),
      .m2_data_i  (32'h0),
      .m2_data_o  (),
      .m2_req_i   (1'b0),
      .m2_we_i    (1'b0),
      // Master 3: 未使用
      .m3_addr_i  (32'h0),
      .m3_data_i  (32'h0),
      .m3_data_o  (),
      .m3_req_i   (1'b0),
      .m3_we_i    (1'b0),
      // Slave 0: RAM
      .s0_addr_o  (slave0_addr),
      .s0_data_o  (slave0_data_o),
      .s0_data_i  (slave0_data_i),
      .s0_we_o    (slave0_we),
      .s0_re_o    (slave0_re),
      .s0_size_o  (slave0_size),
      // Slave 1: ROM
      .s1_addr_o  (slave1_addr),
      .s1_data_o  (slave1_data_o),
      .s1_data_i  (slave1_data_i),
      .s1_we_o    (slave1_we),
      // Slave 2: Timer
      .s2_addr_o  (slave2_addr),
      .s2_data_o  (slave2_data_o),
      .s2_data_i  (slave2_data_i),
      .s2_we_o    (slave2_we),
      // Slave 3: UART
      .s3_addr_o  (slave3_addr),
      .s3_data_o  (slave3_data_o),
      .s3_data_i  (slave3_data_i),
      .s3_we_o    (slave3_we),
      // Slave 4: GPIO
      .s4_addr_o  (slave4_addr),
      .s4_data_o  (slave4_data_o),
      .s4_data_i  (slave4_data_i),
      .s4_we_o    (slave4_we),
      // Slave 5: SPI
      .s5_addr_o  (slave5_addr),
      .s5_data_o  (slave5_data_o),
      .s5_data_i  (slave5_data_i),
      .s5_we_o    (slave5_we),
      // 总线保持信号
      .hold_flag_o(bus_hold_flag)
  );

  // CPU 请求信号生成
  assign cpu_to_bus_req = cpu_to_bus_we | cpu_to_bus_re;

endmodule
