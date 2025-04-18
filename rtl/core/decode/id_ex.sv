`include "../common/defines.sv"
module id_ex (
    input  wire        clk,
    input  wire        rst,
    // from id
    input  wire [31:0] inst_i,
    input  wire [31:0] inst_addr_i,
    input  wire [31:0] op1_i,
    input  wire [31:0] op2_i,
    input  wire [ 4:0] rd_addr_i,
    input  wire        reg_wen_i,
    input  wire [31:0] mem_data_i,
    input  wire [ 2:0] mem_size_i,
    input  wire        mem_we_i,
    input  wire        mem_re_i,
    input  wire [ 4:0] rs1_addr_i,
    input  wire [ 4:0] rs2_addr_i,
    input  wire [31:0] csr_rdata_i,
    input  wire [31:0] csr_waddr_i,
    input  wire        csr_wen_i,
    input  wire [31:0] rs1_data_i,
    input  wire [31:0] rs2_data_i,
    // from control
    input  wire        hold_flag_i,
    // to ex
    output wire [31:0] inst_o,
    output wire [31:0] inst_addr_o,
    output wire [31:0] op1_o,
    output wire [31:0] op2_o,
    output wire [ 4:0] rd_addr_o,
    output wire        reg_wen_o,
    output wire [31:0] mem_data_o,
    output wire [ 2:0] mem_size_o,
    output wire        mem_we_o,
    output wire        mem_re_o,
    output wire [ 4:0] rs1_addr_o,
    output wire [ 4:0] rs2_addr_o,
    output wire [31:0] csr_rdata_o,
    output wire [31:0] csr_waddr_o,
    output wire        csr_wen_o,
    output wire [31:0] rs1_data_o,
    output wire [31:0] rs2_data_o
);
  dff_set_hold #(5) dff1 (
      clk,
      rst,
      hold_flag_i,
      5'b0,
      rs1_addr_i,
      rs1_addr_o
  );
  dff_set_hold #(5) dff2 (
      clk,
      rst,
      hold_flag_i,
      5'b0,
      rs2_addr_i,
      rs2_addr_o
  );
  dff_set_hold #(32) dff3 (
      clk,
      rst,
      hold_flag_i,
      `INST_NOP,
      inst_i,
      inst_o
  );
  dff_set_hold #(32) dff4 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      inst_addr_i,
      inst_addr_o
  );
  dff_set_hold #(32) dff5 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      op1_i,
      op1_o
  );
  dff_set_hold #(32) dff6 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      op2_i,
      op2_o
  );
  dff_set_hold #(5) dff7 (
      clk,
      rst,
      hold_flag_i,
      5'b0,
      rd_addr_i,
      rd_addr_o
  );
  dff_set_hold #(1) dff8 (
      clk,
      rst,
      hold_flag_i,
      1'b0,
      reg_wen_i,
      reg_wen_o
  );
  dff_set_hold #(1) dff9 (
      clk,
      rst,
      hold_flag_i,
      1'b0,
      mem_we_i,
      mem_we_o
  );
  dff_set_hold #(1) dff10 (
      clk,
      rst,
      hold_flag_i,
      1'b0,
      mem_re_i,
      mem_re_o
  );
  dff_set_hold #(32) dff11 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      mem_data_i,
      mem_data_o
  );
  dff_set_hold #(3) dff12 (
      clk,
      rst,
      hold_flag_i,
      3'b0,
      mem_size_i,
      mem_size_o
  );
  dff_set_hold #(32) dff13 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      csr_rdata_i,
      csr_rdata_o
  );
  dff_set_hold #(32) dff14 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      csr_waddr_i,
      csr_waddr_o
  );
  dff_set_hold #(1) dff15 (
      clk,
      rst,
      hold_flag_i,
      1'b0,
      csr_wen_i,
      csr_wen_o
  );
  dff_set_hold #(32) dff16 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      rs1_data_i,
      rs1_data_o
  );
  dff_set_hold #(32) dff17 (
      clk,
      rst,
      hold_flag_i,
      32'b0,
      rs2_data_i,
      rs2_data_o
  );
endmodule
