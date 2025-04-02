module axi4_lite (
    input wire clk,              // 时钟
    input wire rst,           // 复位（低有效）
    // 写地址通道
    input  wire [31:0] awaddr,    // 写地址
    input  wire awvalid,          // 写地址有效
    output reg  awready,          // 写地址准备好
    // 写数据通道
    input  wire [31:0] wdata,     // 写数据
    input  wire [3:0] wstrb,      // 字节选通
    input  wire wvalid,           // 写数据有效
    output reg  wready,           // 写数据准备好
    // 写响应通道
    output reg  [1:0] bresp,      // 写响应 (00=OKAY)
    output reg  bvalid,           // 写响应有效
    input  wire bready,           // 主设备准备好接收响应
    // 读地址通道
    input  wire [31:0] araddr,    // 读地址
    input  wire arvalid,          // 读地址有效
    output reg  arready,          // 读地址准备好
    // 读数据通道
    output reg  [31:0] rdata,     // 读数据
    output reg  [1:0] rresp,      // 读响应 (00=OKAY)
    output reg  rvalid,           // 读数据有效
    input  wire rready            // 主设备准备好接收数据
);