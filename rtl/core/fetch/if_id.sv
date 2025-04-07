// 介于if和id之间的寄存器
`include "../common/defines.sv"

module if_id (
    input wire clk,
    input wire rst,
    // from if
    input wire [31:0] inst_i,
    input wire [31:0] inst_addr_i,
    // from control
    input wire hold_flag_i,
    // to id
    output wire [31:0] inst_o,
    output wire [31:0] inst_addr_o
);
  dff_set_hold #(32) dff1 (
      clk,
      rst,
      hold_flag_i,
      `INST_NOP,
      inst_i,
      inst_o
  );
  dff_set_hold #(32) dff2 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      inst_addr_i,
      inst_addr_o
  );

endmodule
