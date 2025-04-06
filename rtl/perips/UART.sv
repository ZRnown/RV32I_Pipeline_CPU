module uart (
    input wire clk,  // 系统时钟
    input wire rst,  // 复位（低有效）

    // AXI4-Lite 从设备接口
    input  wire [31:0] s_awaddr,   // 写地址
    input  wire [ 2:0] s_awprot,   // 写保护（未使用）
    input  wire        s_awvalid,  // 写地址有效
    output reg         s_awready,  // 写地址准备好
    input  wire [31:0] s_wdata,    // 写数据
    input  wire [ 3:0] s_wstrb,    // 字节选通
    input  wire        s_wvalid,   // 写数据有效
    output reg         s_wready,   // 写数据准备好
    output reg  [ 1:0] s_bresp,    // 写响应 (00=OKAY)
    output reg         s_bvalid,   // 写响应有效
    input  wire        s_bready,   // 主设备准备好接收响应
    input  wire [31:0] s_araddr,   // 读地址
    input  wire [ 2:0] s_arprot,   // 读保护（未使用）
    input  wire        s_arvalid,  // 读地址有效
    output reg         s_arready,  // 读地址准备好
    output reg  [31:0] s_rdata,    // 读数据
    output reg  [ 1:0] s_rresp,    // 读响应 (00=OKAY)
    output reg         s_rvalid,   // 读数据有效
    input  wire        s_rready,   // 主设备准备好接收数据

    // UART 引脚
    input  wire rx,  // 串口接收
    output reg  tx   // 串口发送
);

  // UART 内部信号
  reg [7:0] tx_data;  // 发送数据
  reg       tx_start;  // 发送启动信号
  reg [7:0] rx_data;  // 接收数据
  reg       rx_valid;  // 接收数据有效
  reg       tx_busy;  // 发送忙碌标志

  // UART 寄存器地址映射 (基地址: 0x0000_0000)
  localparam UART_STAT_REG = 2'b00;  // 状态寄存器 (0x00)
  localparam UART_DATA_REG = 2'b01;  // 数据寄存器 (0x04)
  localparam UART_BAUD_REG = 2'b10;  // 波特率寄存器 (0x08)

  // 波特率分频（可配置）
  localparam DEFAULT_BAUD_DIV = 868;  // 100_000_000 / 115200 ≈ 868
  reg [15:0] baud_div;  // 可配置的波特率分频值
  reg [15:0] baud_cnt;
  reg baud_tick;

  // 初始化波特率分频值
  initial begin
    baud_div = DEFAULT_BAUD_DIV;
  end

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      baud_cnt  <= 0;
      baud_tick <= 0;
    end else if (baud_cnt >= baud_div - 1) begin
      baud_cnt  <= 0;
      baud_tick <= 1;
    end else begin
      baud_cnt  <= baud_cnt + 1;
      baud_tick <= 0;
    end
  end

  // 发送状态机
  reg [3:0] tx_state;
  reg [9:0] tx_shift;  // 起始位 + 8位数据 + 停止位
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      tx       <= 1;  // 空闲时高电平
      tx_busy  <= 0;
      tx_state <= 0;
      tx_shift <= 0;
    end else if (baud_tick) begin
      case (tx_state)
        0:
        if (tx_start && !tx_busy) begin
          tx_shift <= {1'b1, tx_data, 1'b0};  // 停止位 + 数据 + 起始位
          tx_busy  <= 1;
          tx_state <= 1;
        end
        1: begin
          tx <= tx_shift[0];
          tx_shift <= {1'b1, tx_shift[9:1]};
          tx_state <= tx_state + 1;
        end
        10: begin
          tx_busy  <= 0;
          tx_state <= 0;
        end
        default: tx_state <= tx_state + 1;
      endcase
    end
  end

  // 接收状态机
  reg [3:0] rx_state;
  reg [9:0] rx_shift;
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      rx_state <= 0;
      rx_shift <= 0;
      rx_data  <= 0;
      rx_valid <= 0;
    end else if (baud_tick) begin
      case (rx_state)
        0:
        if (!rx) begin  // 检测起始位
          rx_state <= 1;
        end
        1: rx_state <= 2;  // 采样起始位中间
        2, 3, 4, 5, 6, 7, 8, 9: begin
          rx_shift <= {rx, rx_shift[9:1]};
          rx_state <= rx_state + 1;
        end
        10: begin
          if (rx) begin  // 停止位
            rx_data  <= rx_shift[8:1];
            rx_valid <= 1;
          end
          rx_state <= 0;
        end
        default: rx_state <= 0;
      endcase
    end else if (!rx_state) begin
      rx_valid <= 0;
    end
  end

  // AXI4-Lite 写通道
  wire [1:0] waddr_offset = s_awaddr[3:2];
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      s_awready <= 0;
      s_wready  <= 0;
      s_bvalid  <= 0;
      s_bresp   <= 2'b00;
      tx_data   <= 0;
      tx_start  <= 0;
    end else begin
      // 写地址握手
      if (s_awvalid && !s_awready) begin
        s_awready <= 1;
      end else begin
        s_awready <= 0;
      end

      // 写数据握手
      if (s_wvalid && !s_wready && s_awvalid) begin
        s_wready <= 1;
        case (waddr_offset)
          UART_STAT_REG: tx_start <= s_wdata[0];  // 控制寄存器：启动发送
          UART_DATA_REG: tx_data <= s_wdata[7:0];  // 数据寄存器：发送数据
          UART_BAUD_REG: baud_div <= s_wdata[15:0];  // 波特率寄存器：设置波特率
          default: ;  // 未定义地址，不做操作
        endcase
      end else begin
        s_wready <= 0;
        tx_start <= 0;  // 启动信号只持续一个周期
      end

      // 写响应
      if (s_wready && s_wvalid) begin
        s_bvalid <= 1;
        s_bresp  <= 2'b00;  // OKAY
      end else if (s_bvalid && s_bready) begin
        s_bvalid <= 0;
      end
    end
  end

  // AXI4-Lite 读通道
  wire [1:0] raddr_offset = s_araddr[3:2];
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      s_arready <= 0;
      s_rvalid  <= 0;
      s_rdata   <= 0;
      s_rresp   <= 2'b00;
    end else begin
      // 读地址握手
      if (s_arvalid && !s_arready) begin
        s_arready <= 1;
      end else begin
        s_arready <= 0;
      end

      // 读数据响应
      if (s_arvalid && s_arready) begin
        s_rvalid <= 1;
        s_rresp  <= 2'b00;  // OKAY
        case (raddr_offset)
          UART_STAT_REG: s_rdata <= {30'b0, tx_busy, rx_valid};  // 状态寄存器
          UART_DATA_REG: s_rdata <= {24'b0, rx_data};  // 数据寄存器
          UART_BAUD_REG: s_rdata <= {16'b0, baud_div};  // 波特率寄存器
          default: s_rdata <= 32'hDEADBEEF;  // 未定义地址
        endcase
      end else if (s_rvalid && s_rready) begin
        s_rvalid <= 0;
      end
    end
  end

endmodule
