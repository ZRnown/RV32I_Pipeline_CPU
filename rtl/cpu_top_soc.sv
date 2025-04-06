module cpu_top_soc (
    input  wire       clk,  // 系统时钟
    input  wire       rst,  // 复位（高有效）
    input  wire       rx,   // UART 接收引脚
    output wire       tx,   // UART 发送引脚
    output reg  [3:0] led   // 调试 LED 输出
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

  // AXI 主设备信号（连接到 CPU）
  wire [31:0] m_awaddr, m_wdata, m_araddr, m_rdata;
  wire [3:0] m_wstrb;
  wire [2:0] m_awprot, m_arprot;
  wire m_awvalid, m_wvalid, m_bready, m_arvalid, m_rready;
  wire m_awready, m_wready, m_bvalid, m_arready, m_rvalid;
  wire [1:0] m_bresp, m_rresp;

  // AXI 从设备信号（连接到外设）
  wire [3:0][31:0] s_awaddr, s_wdata, s_araddr, s_rdata;
  wire [3:0][3:0] s_wstrb;
  wire [3:0][2:0] s_awprot, s_arprot;
  wire [3:0] s_awvalid, s_wvalid, s_bready, s_arvalid, s_rready;
  wire [3:0] s_awready, s_wready, s_bvalid, s_arready, s_rvalid;
  wire [3:0][1:0] s_bresp, s_rresp;


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
      .data_i     (data_from_ram),   // 从 RAM 或 AXI 输入的读数据
      // AXI 主设备接口（假设已实现）
      .m_awaddr   (m_awaddr),
      .m_awprot   (m_awprot),
      .m_awvalid  (m_awvalid),
      .m_awready  (m_awready),
      .m_wdata    (m_wdata),
      .m_wstrb    (m_wstrb),
      .m_wvalid   (m_wvalid),
      .m_wready   (m_wready),
      .m_bresp    (m_bresp),
      .m_bvalid   (m_bvalid),
      .m_bready   (m_bready),
      .m_araddr   (m_araddr),
      .m_arprot   (m_arprot),
      .m_arvalid  (m_arvalid),
      .m_arready  (m_arready),
      .m_rdata    (m_rdata),
      .m_rresp    (m_rresp),
      .m_rvalid   (m_rvalid),
      .m_rready   (m_rready)
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

  // AXI4-Lite 总线实例
  axi4_lite #(
      .NUM_SLAVES(4)
  ) u_axi4_lite (
      .clk      (clk),
      .rst      (rst),
      .m_awaddr (m_awaddr),
      .m_awprot (m_awprot),
      .m_awvalid(m_awvalid),
      .m_awready(m_awready),
      .m_wdata  (m_wdata),
      .m_wstrb  (m_wstrb),
      .m_wvalid (m_wvalid),
      .m_wready (m_wready),
      .m_bresp  (m_bresp),
      .m_bvalid (m_bvalid),
      .m_bready (m_bready),
      .m_araddr (m_araddr),
      .m_arprot (m_arprot),
      .m_arvalid(m_arvalid),
      .m_arready(m_arready),
      .m_rdata  (m_rdata),
      .m_rresp  (m_rresp),
      .m_rvalid (m_rvalid),
      .m_rready (m_rready),
      .s_awaddr (s_awaddr),
      .s_awprot (s_awprot),
      .s_awvalid(s_awvalid),
      .s_awready(s_awready),
      .s_wdata  (s_wdata),
      .s_wstrb  (s_wstrb),
      .s_wvalid (s_wvalid),
      .s_wready (s_wready),
      .s_bresp  (s_bresp),
      .s_bvalid (s_bvalid),
      .s_bready (s_bready),
      .s_araddr (s_araddr),
      .s_arprot (s_arprot),
      .s_arvalid(s_arvalid),
      .s_arready(s_arready),
      .s_rdata  (s_rdata),
      .s_rresp  (s_rresp),
      .s_rvalid (s_rvalid),
      .s_rready (s_rready)
  );

  // UART 实例
  uart u_uart (
      .clk      (clk),
      .rst      (rst),
      .s_awaddr (s_awaddr[0]),
      .s_awprot (s_awprot[0]),
      .s_awvalid(s_awvalid[0]),
      .s_awready(s_awready[0]),
      .s_wdata  (s_wdata[0]),
      .s_wstrb  (s_wstrb[0]),
      .s_wvalid (s_wvalid[0]),
      .s_wready (s_wready[0]),
      .s_bresp  (s_bresp[0]),
      .s_bvalid (s_bvalid[0]),
      .s_bready (s_bready[0]),
      .s_araddr (s_araddr[0]),
      .s_arprot (s_arprot[0]),
      .s_arvalid(s_arvalid[0]),
      .s_arready(s_arready[0]),
      .s_rdata  (s_rdata[0]),
      .s_rresp  (s_rresp[0]),
      .s_rvalid (s_rvalid[0]),
      .s_rready (s_rready[0]),
      .rx       (rx),
      .tx       (tx)
  );

  // 未使用的从设备接口（置空）
  assign s_awready[3:1] = 3'b0;
  assign s_wready[3:1]  = 3'b0;
  assign s_bvalid[3:1]  = 3'b0;
  assign s_bresp[1]     = 2'b00;  // 修复第 169 行
  assign s_bresp[2]     = 2'b00;
  assign s_bresp[3]     = 2'b00;
  assign s_arready[3:1] = 3'b0;
  assign s_rvalid[3:1]  = 3'b0;
  assign s_rdata[1]     = 32'b0;  // 修复第 172 行
  assign s_rdata[2]     = 32'b0;
  assign s_rdata[3]     = 32'b0;
  assign s_rresp[1]     = 2'b00;  // 修复第 173 行
  assign s_rresp[2]     = 2'b00;
  assign s_rresp[3]     = 2'b00;

  // 调试 LED（显示 UART 写数据）
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      led <= 4'b0;
    end else if (s_wvalid[0] && s_wready[0] && s_awaddr[0][3:2] == 2'b01) begin
      led <= s_wdata[0][3:0];  // 显示 UART 发送数据低4位
    end
  end

endmodule
