module control (
    // from ex
    input wire [31:0] jump_addr_i,
    input wire jump_en_i,
    input wire hold_flag_ex_i,
    // from clint
    input wire hold_flag_clint_i,
    // from rib
    input wire hold_flag_rib_i,
    // to pc_reg if_id id_ex
    output reg [31:0] jump_addr_o,
    output reg jump_en_o,
    output reg hold_flag_o
);
  always @(*) begin
    jump_addr_o = jump_addr_i;
    jump_en_o   = jump_en_i;
    if (jump_en_i || hold_flag_ex_i || hold_flag_clint_i || hold_flag_rib_i) hold_flag_o = 1'b1;
    else hold_flag_o = 1'b0;
  end
endmodule
