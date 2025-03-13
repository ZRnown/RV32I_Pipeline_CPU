module cpu_top (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] inst_i,
    output wire [31:0] inst_addr_o
);
  // PC to IF
  wire [31:0] pc_if_addr;

  // IF to IF/ID
  wire [31:0] if_ifid_inst;
  wire [31:0] if_ifid_inst_addr;

  // IF/ID to ID
  wire [31:0] ifid_id_inst;
  wire [31:0] ifid_id_inst_addr;

  // ID to Regs
  wire [ 4:0] id_regs_rs1_addr;
  wire [ 4:0] id_regs_rs2_addr;

  // Regs to ID
  wire [31:0] regs_id_rs1_data;
  wire [31:0] regs_id_rs2_data;

  // ID to ID/EX
  wire [31:0] id_idex_inst;
  wire [31:0] id_idex_inst_addr;
  wire [31:0] id_idex_op1;
  wire [31:0] id_idex_op2;
  wire [ 4:0] id_idex_rd_addr;
  wire        id_idex_rd_wen;

  // ID/EX to EX
  wire [31:0] idex_ex_inst;
  wire [31:0] idex_ex_inst_addr;
  wire [31:0] idex_ex_op1;
  wire [31:0] idex_ex_op2;
  wire [ 4:0] idex_ex_rd_addr;
  wire        idex_ex_rd_wen;

  // EX to Regs
  wire [ 4:0] ex_regs_rd_addr;
  wire [31:0] ex_regs_rd_data;
  wire        ex_regs_rd_wen;

  // EX to Control
  wire [31:0] ex_ctrl_jump_addr;
  wire        ex_ctrl_jump_en;
  wire        ex_ctrl_hold_flag;

  // Control to PC, IF/ID, ID/EX
  wire [31:0] ctrl_pc_jump_addr;
  wire        ctrl_pc_jump_en;
  wire        ctrl_hold_flag;

  // Program Counter (PC)
  pc_reg pc_reg_inst (
      .clk        (clk),
      .rst        (rst),
      .jump_addr_i(ctrl_pc_jump_addr),
      .jump_en_i  (ctrl_pc_jump_en),
      .pc_o       (pc_if_addr)
  );

  // Instruction Fetch (IF)
  iF if_inst (
      .pc_addr_i    (pc_if_addr),
      .rom_inst_i   (inst_i),
      .if2rom_addr_o(inst_addr_o),
      .inst_addr_o  (if_ifid_inst_addr),
      .inst_o       (if_ifid_inst)
  );

  // IF/ID Pipeline Register
  if_id if_id_inst (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (if_ifid_inst),
      .inst_addr_i(if_ifid_inst_addr),
      .hold_flag_i(ctrl_hold_flag),
      .inst_o     (ifid_id_inst),
      .inst_addr_o(ifid_id_inst_addr)
  );

  // Instruction Decode (ID)
  id id_inst (
      .inst_i     (ifid_id_inst),
      .inst_addr_i(ifid_id_inst_addr),
      .rs1_addr_o (id_regs_rs1_addr),
      .rs2_addr_o (id_regs_rs2_addr),
      .rs1_data_i (regs_id_rs1_data),
      .rs2_data_i (regs_id_rs2_data),
      .inst_o     (id_idex_inst),
      .inst_addr_o(id_idex_inst_addr),
      .op1_o      (id_idex_op1),
      .op2_o      (id_idex_op2),
      .rd_addr_o  (id_idex_rd_addr),
      .reg_wen    (id_idex_rd_wen)
  );

  // ID/EX Pipeline Register
  id_ex id_ex_inst (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (id_idex_inst),
      .inst_addr_i(id_idex_inst_addr),
      .op1_i      (id_idex_op1),
      .op2_i      (id_idex_op2),
      .rd_addr_i  (id_idex_rd_addr),
      .reg_wen_i  (id_idex_rd_wen),
      .hold_flag_i(ctrl_hold_flag),
      .inst_o     (idex_ex_inst),
      .inst_addr_o(idex_ex_inst_addr),
      .op1_o      (idex_ex_op1),
      .op2_o      (idex_ex_op2),
      .rd_addr_o  (idex_ex_rd_addr),
      .reg_wen_o  (idex_ex_rd_wen)
  );

  // Execute (EX)
  ex ex_inst (
      .inst_i     (idex_ex_inst),
      .inst_addr_i(idex_ex_inst_addr),
      .op1_i      (idex_ex_op1),
      .op2_i      (idex_ex_op2),
      .rd_addr_i  (idex_ex_rd_addr),
      .rd_wen_i   (idex_ex_rd_wen),
      .rd_addr_o  (ex_regs_rd_addr),
      .rd_data_o  (ex_regs_rd_data),
      .rd_wen_o   (ex_regs_rd_wen),
      .jump_addr_o(ex_ctrl_jump_addr),
      .jump_en_o  (ex_ctrl_jump_en),
      .hold_flag_o(ex_ctrl_hold_flag)
  );

  // Control Unit
  control control_inst (
      .jump_addr_i   (ex_ctrl_jump_addr),
      .jump_en_i     (ex_ctrl_jump_en),
      .hold_flag_ex_i(ex_ctrl_hold_flag),
      .jump_addr_o   (ctrl_pc_jump_addr),
      .jump_en_o     (ctrl_pc_jump_en),
      .hold_flag_o   (ctrl_hold_flag)
  );

  // Register File
  regs regs_inst (
      .clk        (clk),
      .rst        (rst),
      .reg1_addr_i(id_regs_rs1_addr),
      .reg2_addr_i(id_regs_rs2_addr),
      .reg1_data_o(regs_id_rs1_data),
      .reg2_data_o(regs_id_rs2_data),
      .reg_waddr_i(ex_regs_rd_addr),
      .reg_wdata_i(ex_regs_rd_data),
      .reg_wen    (ex_regs_rd_wen)
  );

endmodule
