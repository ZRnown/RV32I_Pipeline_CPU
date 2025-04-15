module uart (
    input  wire        clk,     // 系统时钟
    input  wire        rst,     // 复位（低有效）
    // UART 引脚
    input  wire        rx,      // 串口接收
    output reg         tx,      // 串口发送
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output wire [31:0] data_o,
    input  wire        we_i
);


endmodule
