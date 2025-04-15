module cpu_top_soc (
    input  wire clk,  // 系统时钟
    input  wire rst,  // 复位（高有效）
    input  wire rx,   // UART 接收引脚
    output wire tx    // UART 发送引脚
);

  // CPU 与 ROM 的信号
  wire [31:0] cpu_top_addr_o;  // CPU 输出到 ROM 的指令地址
  wire [31:0] cpu_top_inst_i;  // ROM 输出到 CPU 的指令

  // CPU 与 RAM 或 AXI 的信号
  wire [31:0] data_addr;  // CPU 输出到 RAM 或 AXI 的数据地址
  wire [31:0] data_to_ram;  // CPU 输出到 RAM 或 AXI 的写数据
  wire [31:0] data_from_ram;  // RAM 或 AXI 输出到 CPU 的读数据
  wire        data_we;  // 数据写使能
  wire        data_re;  // 数据读使能
  wire [ 2:0] data_size;  // 数据大小（字节、半字、字）

  // CPU 实例化
  cpu_top u_cpu_top (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (cpu_top_inst_i),  // 从 ROM 输入的指令
      .inst_addr_o(cpu_top_addr_o),  // 输出到 ROM 的指令地址
      .data_addr_o(data_addr),       // 输出到 RAM 或 AXI 的数据地址
      .data_o     (data_to_ram),     // 输出到 RAM 或 AXI 的写数据
      .data_we_o  (data_we),         // 数据写使能
      .data_re_o  (data_re),         // 数据读使能
      .data_size_o(data_size),       // 数据大小控制
      .data_i     (data_from_ram)    // 从 RAM 或 AXI 输入的读数据
  );
  // ROM 实例化（指令存储）
  rom u_rom (
      .inst_addr_i(cpu_top_addr_o),  // 来自 CPU 的指令地址
      .inst_o     (cpu_top_inst_i)   // 输出到 CPU 的指令
  );

  // RAM 实例化（数据存储）
  ram u_ram (
      .clk       (clk),
      .mem_addr_i(data_addr),     // 来自 CPU 的数据地址
      .mem_data_i(data_to_ram),   // 来自 CPU 的写数据
      .mem_we_i  (data_we),       // 写使能
      .mem_re_i  (data_re),       // 读使能
      .mem_size_i(data_size),     // 数据大小
      .mem_data_o(data_from_ram)  // 输出到 CPU 的读数据
  );


  // UART 实例
  uart u_uart (
      .clk(clk),
      .rst(rst),
      .rx (rx),
      .tx (tx)
  );


endmodule
