module if_id (
    input wire clk,
    input wire rst,
    output wire [31:0] inst_i,
    output wire [31:0] inst_addr_i,
    output reg [31:0] inst_o,
    output wire [31:0] inst_addr_o
);
  dff_set #(32) dff1 (
      clk,
      rst,
      `INST_NOP_OP,
      inst_i,
      inst_o
  );
  dff_set #(32) dff2 (
      clk,
      rst,
      32'b0,
      inst_addr_i,
      inst_addr_o
  );

endmodule
