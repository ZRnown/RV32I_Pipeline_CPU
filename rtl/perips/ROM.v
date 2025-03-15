// 相当于内存，从此出取指令
module rom (
    input wire [31:0] inst_addr_i,  //来自PC的地址
    output reg [31:0] inst_o  // 输出指令
);
  reg [31:0] ROM[0:4095];
  always @(*) begin
    inst_o = ROM[inst_addr_i>>2];
  end
endmodule
