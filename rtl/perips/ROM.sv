// 相当于内存，从此出取指令
module rom (
    input rst,
    input clk,
    input wire we_i,
    input wire [31:0] addr_i,
    input wire [31:0] data_i,
    output reg [31:0] data_o
);
  reg [31:0] ROM[0:4095];
  always @(*) begin
    if (rst == 1'b0) data_o = 32'b0;
    else data_o = ROM[addr_i>>2];
  end

  always @(posedge clk) begin
    if (we_i == 1'b1) begin
      ROM[addr_i>>2] <= data_i;
    end
  end
endmodule
