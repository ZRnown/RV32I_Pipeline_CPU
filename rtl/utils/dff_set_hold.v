// 带异步置位功能的D触发器（带流水线冲刷）--为了打拍子。
module dff_set_hold #(
    parameter DW = 32
) (
    input wire clk,
    input wire rst,
    input wire hold_flag_i,
    input wire [DW-1:0] set_data,
    input wire [DW-1:0] data_i,
    output reg [DW-1:0] data_o
);
  always @(posedge clk) begin
    if (rst == 1'b0 || hold_flag_i) data_o <= set_data;
    else data_o <= data_i;
  end
endmodule
