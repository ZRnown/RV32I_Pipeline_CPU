module cpu_top (
    input wire clk,
    input wire rst,
    input wire [31:0] inst_i,
    output wire [31:0] inst_addr_o
);
  //   pc to if
  wire [31:0] pc_reg_o;
  //   程序计数器例化
  pc_reg pc_reg_inst (
      .clk (clk),
      .rst (rst),
      .pc_o(pc_reg_o)
  );
  //   if to if_id
  wire [31:0] if_inst_addr_o;
  wire [31:0] if_inst_o;
  //   取址例化
  iF if_inst (
      .pc_addr_i(pc_reg_o),
      .rom_inst_i(inst_i),
      .if2rom_addr_o(inst_addr_o),
      .inst_addr_o(if_inst_addr_o),
      .inst_o(if_inst_o)
  );
  //   if_id to id
  wire [31:0] if_id_inst_o;
  wire [31:0] if_id_inst_addr_o;
  //   if_id寄存器例化
  if_id if_id_inst (
      .clk(clk),
      .rst(rst),
      .inst_i(if_inst_o),
      .inst_addr_i(if_inst_addr_o),
      .inst_o(if_id_inst_o),
      .inst_addr_o(if_id_inst_addr_o)
  );
  //   id to regs
  wire [4:0] id_rs1_addr_o;
  wire [4:0] id_rs2_addr_o;
  //   regs to id
  wire [31:0] id_rs1_data_i;
  wire [31:0] id_rs2_data_i;
  //   id to id_ex
  wire [31:0] id_inst_o;
  wire [31:0] id_inst_addr_o;
  wire [31:0] id_op1_o;
  wire [31:0] id_op2_o;
  wire [4:0] id_rd_addr_o;
  wire id_reg_wen;
  //   译址例化
  id id_inst (
      .inst_i     (if_id_inst_o),
      .inst_addr_i(if_id_inst_addr_o),
      .rs1_addr_o (id_rs1_addr_o),
      .rs2_addr_o (id_rs2_addr_o),
      .rs1_data_i (id_rs1_data_i),
      .rs2_data_i (id_rs2_data_i),
      .inst_o     (id_inst_o),
      .inst_addr_o(id_inst_addr_o),
      .op1_o      (id_op1_o),
      .op2_o      (id_op2_o),
      .rd_addr_o  (id_rd_addr_o),
      .reg_wen    (id_reg_wen)
  );
  //   id_ex to ex
  wire [31:0] id_ex_inst_o;
  wire [31:0] id_ex_inst_addr_o;
  wire [31:0] id_ex_op1_o;
  wire [31:0] id_ex_op2_o;
  wire [4:0] id_ex_rd_addr_o;
  wire id_ex_reg_wen_o;
  id_ex id_ex_inst (
      .clk(clk),
      .rst(rst),
      .inst_i(id_inst_o),
      .inst_addr_i(id_inst_addr_o),
      .op1_i(id_op1_o),
      .op2_i(id_op2_o),
      .rd_addr_i(id_rd_addr_o),
      .reg_wen_i(id_reg_wen),
      .inst_o(id_ex_inst_o),
      .inst_addr_o(id_ex_inst_addr_o),
      .op1_o(id_ex_op1_o),
      .op2_o(id_ex_op2_o),
      .rd_addr_o(id_ex_rd_addr_o),
      .reg_wen_o(id_ex_reg_wen_o)
  );
  //   ex to regs
  wire [4:0] ex_rd_addr_o;
  wire [31:0] ex_rd_data_o;
  wire rd_wen_o;
  ex ex_inst (
      .inst_i     (id_ex_inst_o),
      .inst_addr_i(id_ex_inst_addr_o),
      .op1_i      (id_ex_op1_o),
      .op2_i      (id_ex_op2_o),
      .rd_addr_i  (id_ex_rd_addr_o),
      .rd_wen_i   (id_ex_reg_wen_o),
      .rd_addr_o  (ex_rd_addr_o),
      .rd_data_o  (ex_rd_data_o),
      .rd_wen_o   (rd_wen_o)
  );
  //   通用寄存器例化
  regs regs_inst (
      .clk(clk),
      .rst(rst),
      .reg1_addr_i(id_rs1_addr_o),
      .reg2_addr_i(id_rs2_addr_o),
      .reg1_data_o(id_rs1_data_i),
      .reg2_data_o(id_rs2_data_i),
      .reg_waddr_i(ex_rd_addr_o),
      .reg_wdata_i(ex_rd_data_o),
      .reg_wen(rd_wen_o)
  );
endmodule
