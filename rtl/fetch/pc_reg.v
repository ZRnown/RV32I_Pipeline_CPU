module pc_reg (
    input wire clk,
    input wire rst,
    output reg [31:0] pc_o
);
  always @(posedge clk) begin
    if (rst == 1'b0) pc_o <= 32'b0;  // rst为低电平认为复位。
    else pc_o <= pc_o + 3'd4;
  end
endmodule
