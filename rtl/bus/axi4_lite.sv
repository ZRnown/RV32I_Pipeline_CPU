module axi4_lite #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter NUM_SLAVES = 4
) (
    input wire clk,
    input wire rst,

    // 主设备接口
    input wire [ADDR_WIDTH-1:0] m_awaddr,
    input wire [2:0] m_awprot,
    input wire m_awvalid,
    output wire m_awready,
    input wire [DATA_WIDTH-1:0] m_wdata,
    input wire [DATA_WIDTH/8-1:0] m_wstrb,
    input wire m_wvalid,
    output wire m_wready,
    output wire [1:0] m_bresp,
    output wire m_bvalid,
    input wire m_bready,
    input wire [ADDR_WIDTH-1:0] m_araddr,
    input wire [2:0] m_arprot,
    input wire m_arvalid,
    output wire m_arready,
    output wire [DATA_WIDTH-1:0] m_rdata,
    output wire [1:0] m_rresp,
    output wire m_rvalid,
    input wire m_rready,

    // 从设备接口
    output wire [NUM_SLAVES-1:0][ADDR_WIDTH-1:0] s_awaddr,
    output wire [NUM_SLAVES-1:0][2:0] s_awprot,
    output wire [NUM_SLAVES-1:0] s_awvalid,
    input wire [NUM_SLAVES-1:0] s_awready,
    output wire [NUM_SLAVES-1:0][DATA_WIDTH-1:0] s_wdata,
    output wire [NUM_SLAVES-1:0][DATA_WIDTH/8-1:0] s_wstrb,
    output wire [NUM_SLAVES-1:0] s_wvalid,
    input wire [NUM_SLAVES-1:0] s_wready,
    input wire [NUM_SLAVES-1:0][1:0] s_bresp,
    input wire [NUM_SLAVES-1:0] s_bvalid,
    output wire [NUM_SLAVES-1:0] s_bready,
    output wire [NUM_SLAVES-1:0][ADDR_WIDTH-1:0] s_araddr,
    output wire [NUM_SLAVES-1:0][2:0] s_arprot,
    output wire [NUM_SLAVES-1:0] s_arvalid,
    input wire [NUM_SLAVES-1:0] s_arready,
    input wire [NUM_SLAVES-1:0][DATA_WIDTH-1:0] s_rdata,
    input wire [NUM_SLAVES-1:0][1:0] s_rresp,
    input wire [NUM_SLAVES-1:0] s_rvalid,
    output wire [NUM_SLAVES-1:0] s_rready
);

  // 地址映射定义
  localparam UART_BASE_ADDR = 32'h0000_0000;  // UART 基地址
  localparam GPIO_BASE_ADDR = 32'h1000_0000;  // GPIO 基地址
  localparam TIMER_BASE_ADDR = 32'h2000_0000;  // Timer 基地址
  localparam MEM_BASE_ADDR = 32'h3000_0000;  // Memory 基地址

  // 地址解码
  reg [NUM_SLAVES-1:0] slave_select;
  always @(*) begin
    slave_select = {NUM_SLAVES{1'b0}};  // 默认无选中

    // 使用写地址和读地址进行解码
    if (m_awvalid) begin
      // 写地址解码
      case (m_awaddr[31:28])
        4'h0: slave_select[0] = 1'b1;  // UART (0x0000_0000 - 0x0FFF_FFFF)
        4'h1: slave_select[1] = 1'b1;  // GPIO (0x1000_0000 - 0x1FFF_FFFF)
        4'h2: slave_select[2] = 1'b1;  // Timer (0x2000_0000 - 0x2FFF_FFFF)
        4'h3: slave_select[3] = 1'b1;  // Memory (0x3000_0000 - 0x3FFF_FFFF)
        default: slave_select = {NUM_SLAVES{1'b0}};  // 未匹配时无选中
      endcase
    end else if (m_arvalid) begin
      // 读地址解码
      case (m_araddr[31:28])
        4'h0: slave_select[0] = 1'b1;  // UART
        4'h1: slave_select[1] = 1'b1;  // GPIO
        4'h2: slave_select[2] = 1'b1;  // Timer
        4'h3: slave_select[3] = 1'b1;  // Memory
        default: slave_select = {NUM_SLAVES{1'b0}};  // 未匹配时无选中
      endcase
    end
  end

  // 写通道寄存器
  reg [NUM_SLAVES-1:0] awvalid_r, wvalid_r, bready_r;
  reg [NUM_SLAVES-1:0] awready_r, wready_r, bvalid_r;
  integer i;

  // 写地址通道
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      awvalid_r <= {NUM_SLAVES{1'b0}};
      awready_r <= {NUM_SLAVES{1'b0}};
    end else begin
      for (i = 0; i < NUM_SLAVES; i = i + 1) begin
        awvalid_r[i] <= slave_select[i] ? m_awvalid : 1'b0;
        awready_r[i] <= slave_select[i] ? s_awready[i] : 1'b0;
      end
    end
  end

  // 写数据通道（修复部分）
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      wvalid_r <= {NUM_SLAVES{1'b0}};
      wready_r <= {NUM_SLAVES{1'b0}};
    end else begin
      for (i = 0; i < NUM_SLAVES; i = i + 1) begin
        wvalid_r[i] <= slave_select[i] ? m_wvalid : 1'b0;
        wready_r[i] <= slave_select[i] ? s_wready[i] : 1'b0;  // 修复后的第 91 行
      end
    end
  end

  // 写响应通道
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      bvalid_r <= {NUM_SLAVES{1'b0}};
      bready_r <= {NUM_SLAVES{1'b0}};
    end else begin
      for (i = 0; i < NUM_SLAVES; i = i + 1) begin
        bvalid_r[i] <= slave_select[i] ? s_bvalid[i] : 1'b0;
        bready_r[i] <= slave_select[i] ? m_bready : 1'b0;
      end
    end
  end

  // 读通道寄存器
  reg [NUM_SLAVES-1:0] arvalid_r, rready_r;
  reg [NUM_SLAVES-1:0] arready_r, rvalid_r;

  // 读地址通道
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      arvalid_r <= {NUM_SLAVES{1'b0}};
      arready_r <= {NUM_SLAVES{1'b0}};
    end else begin
      for (i = 0; i < NUM_SLAVES; i = i + 1) begin
        arvalid_r[i] <= slave_select[i] ? m_arvalid : 1'b0;
        arready_r[i] <= slave_select[i] ? s_arready[i] : 1'b0;
      end
    end
  end

  // 读数据通道
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      rvalid_r <= {NUM_SLAVES{1'b0}};
      rready_r <= {NUM_SLAVES{1'b0}};
    end else begin
      for (i = 0; i < NUM_SLAVES; i = i + 1) begin
        rvalid_r[i] <= slave_select[i] ? s_rvalid[i] : 1'b0;
        rready_r[i] <= slave_select[i] ? m_rready : 1'b0;
      end
    end
  end

  // 主设备输出
  assign m_awready = |awready_r;
  assign m_wready = |wready_r;
  assign m_bvalid = |bvalid_r;
  assign m_bresp   = slave_select[0] ? s_bresp[0] :
                       slave_select[1] ? s_bresp[1] :
                       slave_select[2] ? s_bresp[2] :
                       slave_select[3] ? s_bresp[3] : 2'b01;  // SLVERR
  assign m_arready = |arready_r;
  assign m_rvalid = |rvalid_r;
  assign m_rdata   = slave_select[0] ? s_rdata[0] :
                       slave_select[1] ? s_rdata[1] :
                       slave_select[2] ? s_rdata[2] :
                       slave_select[3] ? s_rdata[3] : {DATA_WIDTH{1'b0}};
  assign m_rresp   = slave_select[0] ? s_rresp[0] :
                       slave_select[1] ? s_rresp[1] :
                       slave_select[2] ? s_rresp[2] :
                       slave_select[3] ? s_rresp[3] : 2'b01;  // SLVERR

  // 从设备输出
  genvar j;
  generate
    for (j = 0; j < NUM_SLAVES; j = j + 1) begin : slave_connections
      assign s_awaddr[j]  = slave_select[j] ? m_awaddr : {ADDR_WIDTH{1'b0}};
      assign s_awprot[j]  = slave_select[j] ? m_awprot : 3'b000;
      assign s_awvalid[j] = awvalid_r[j];
      assign s_wdata[j]   = slave_select[j] ? m_wdata : {DATA_WIDTH{1'b0}};
      assign s_wstrb[j]   = slave_select[j] ? m_wstrb : {(DATA_WIDTH / 8) {1'b0}};
      assign s_wvalid[j]  = wvalid_r[j];
      assign s_bready[j]  = bready_r[j];
      assign s_araddr[j]  = slave_select[j] ? m_araddr : {ADDR_WIDTH{1'b0}};
      assign s_arprot[j]  = slave_select[j] ? m_arprot : 3'b000;
      assign s_arvalid[j] = arvalid_r[j];
      assign s_rready[j]  = rready_r[j];
    end
  endgenerate

endmodule
