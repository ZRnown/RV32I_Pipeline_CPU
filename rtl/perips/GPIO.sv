module gpio (
    input  wire        clk,     // 系统时钟
    input  wire        rst,     // 复位（低有效）
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output wire [31:0] data_o,
    input  wire        we_i
    // input  wire [ 2:0] io_pin_i,
    // input  wire [31:0] reg_ctrl,
    // input  wire [31:0] reg_data

);
endmodule
