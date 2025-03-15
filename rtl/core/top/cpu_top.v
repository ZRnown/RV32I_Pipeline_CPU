module cpu_top (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] inst_i,
    output wire [31:0] inst_addr_o
);

  // 内部信号声明 - 按流水线阶段分组
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

  // EX to EX/MEM
  wire [ 4:0] ex_exmem_rd_addr;
  wire [31:0] ex_exmem_rd_data;
  wire        ex_exmem_rd_wen;
  wire [31:0] ex_exmem_mem_addr;
  wire [31:0] ex_exmem_mem_data;
  wire        ex_exmem_mem_we;
  wire        ex_exmem_mem_re;

  // EX to Control
  wire [31:0] ex_ctrl_jump_addr;
  wire        ex_ctrl_jump_en;
  wire        ex_ctrl_hold_flag;

  // EX/MEM to MEM
  wire [ 4:0] exmem_mem_rd_addr;
  wire [31:0] exmem_mem_rd_data;
  wire        exmem_mem_rd_wen;
  wire [31:0] exmem_mem_mem_addr;
  wire [31:0] exmem_mem_mem_data;
  wire        exmem_mem_mem_we;
  wire        exmem_mem_mem_re;

  // MEM to MEM/WB
  wire [ 4:0] mem_memwb_rd_addr;
  wire [31:0] mem_memwb_rd_data;
  wire        mem_memwb_rd_wen;

  // MEM/WB to WB
  wire [ 4:0] memwb_wb_rd_addr;
  wire [31:0] memwb_wb_rd_data;
  wire        memwb_wb_rd_wen;

  // WB to Regs
  wire [ 4:0] wb_regs_rd_addr;
  wire [31:0] wb_regs_rd_data;
  wire        wb_regs_rd_wen;

  // Control to PC, IF/ID, ID/EX
  wire [31:0] ctrl_pc_jump_addr;
  wire        ctrl_pc_jump_en;
  wire        ctrl_hold_flag;

  // 模块实例化
  // Program Counter (PC)
  pc_reg u_pc_reg (
      .clk        (clk),
      .rst        (rst),
      .jump_addr_i(ctrl_pc_jump_addr),
      .jump_en_i  (ctrl_pc_jump_en),
      .pc_o       (pc_if_addr)
  );

  // Instruction Fetch (IF)
  iF u_if (
      .pc_addr_i    (pc_if_addr),
      .rom_inst_i   (inst_i),
      .if2rom_addr_o(inst_addr_o),
      .inst_addr_o  (if_ifid_inst_addr),
      .inst_o       (if_ifid_inst)
  );

  // IF/ID Pipeline Register
  if_id u_if_id (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (if_ifid_inst),
      .inst_addr_i(if_ifid_inst_addr),
      .hold_flag_i(ctrl_hold_flag),
      .inst_o     (ifid_id_inst),
      .inst_addr_o(ifid_id_inst_addr)
  );

  // Instruction Decode (ID)
  id u_id (
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
  id_ex u_id_ex (
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
  ex u_ex (
      .inst_i     (idex_ex_inst),
      .inst_addr_i(idex_ex_inst_addr),
      .op1_i      (idex_ex_op1),
      .op2_i      (idex_ex_op2),
      .rd_addr_i  (idex_ex_rd_addr),
      .rd_wen_i   (idex_ex_rd_wen),
      .rd_addr_o  (ex_exmem_rd_addr),
      .rd_data_o  (ex_exmem_rd_data),
      .rd_wen_o   (ex_exmem_rd_wen),
      .mem_addr_o (ex_exmem_mem_addr),
      .mem_data_o (ex_exmem_mem_data),
      .mem_we_o   (ex_exmem_mem_we),
      .mem_re_o   (ex_exmem_mem_re),
      .jump_addr_o(ex_ctrl_jump_addr),
      .jump_en_o  (ex_ctrl_jump_en),
      .hold_flag_o(ex_ctrl_hold_flag)
  );

  // EX/MEM Pipeline Register
  ex_mem u_ex_mem (
      .clk       (clk),
      .rst       (rst),
      .rd_addr_i (ex_exmem_rd_addr),
      .rd_data_i (ex_exmem_rd_data),
      .rd_wen_i  (ex_exmem_rd_wen),
      .mem_addr_i(ex_exmem_mem_addr),
      .mem_data_i(ex_exmem_mem_data),
      .mem_we_i  (ex_exmem_mem_we),
      .mem_re_i  (ex_exmem_mem_re),
      .rd_addr_o (exmem_mem_rd_addr),
      .rd_data_o (exmem_mem_rd_data),
      .rd_wen_o  (exmem_mem_rd_wen),
      .mem_addr_o(exmem_mem_mem_addr),
      .mem_data_o(exmem_mem_mem_data),
      .mem_we_o  (exmem_mem_mem_we),
      .mem_re_o  (exmem_mem_mem_re)
  );

  // Memory (MEM)
  mem u_mem (
      .rd_addr_i (exmem_mem_rd_addr),
      .rd_data_i (exmem_mem_rd_data),
      .rd_wen_i  (exmem_mem_rd_wen),
      .mem_addr_i(exmem_mem_mem_addr),
      .mem_data_i(exmem_mem_mem_data),
      .mem_we_i  (exmem_mem_mem_we),
      .mem_re_i  (exmem_mem_mem_re),
      .mem_addr_o(),                    // 未使用，可连接到RAM但这里留空
      .mem_data_o(),                    // 未使用，可连接到RAM但这里留空
      .mem_we_o  (),                    // 未使用，可连接到RAM但这里留空
      .mem_re_o  (),                    // 未使用，可连接到RAM但这里留空
      .rd_addr_o (mem_memwb_rd_addr),
      .rd_data_o (mem_memwb_rd_data),   // 由RAM提供数据
      .rd_wen_o  (mem_memwb_rd_wen)
  );

  // MEM/WB Pipeline Register
  mem_wb u_mem_wb (
      .clk      (clk),
      .rst      (rst),
      .rd_addr_i(mem_memwb_rd_addr),
      .rd_data_i(mem_memwb_rd_data),
      .rd_wen_i (mem_memwb_rd_wen),
      .rd_addr_o(memwb_wb_rd_addr),
      .rd_data_o(memwb_wb_rd_data),
      .rd_wen_o (memwb_wb_rd_wen)
  );

  // Write Back (WB)
  wb u_wb (
      .rd_addr_i(memwb_wb_rd_addr),
      .rd_data_i(memwb_wb_rd_data),
      .rd_wen_i (memwb_wb_rd_wen),
      .rd_addr_o(wb_regs_rd_addr),
      .rd_data_o(wb_regs_rd_data),
      .rd_wen_o (wb_regs_rd_wen)
  );

  // Control Unit
  control u_control (
      .jump_addr_i   (ex_ctrl_jump_addr),
      .jump_en_i     (ex_ctrl_jump_en),
      .hold_flag_ex_i(ex_ctrl_hold_flag),
      .jump_addr_o   (ctrl_pc_jump_addr),
      .jump_en_o     (ctrl_pc_jump_en),
      .hold_flag_o   (ctrl_hold_flag)
  );

  // RAM (Memory) - 补全实例化
  ram u_ram (
      .clk       (clk),
      .mem_addr_i(exmem_mem_mem_addr),  // 来自EX/MEM的内存地址
      .mem_data_i(exmem_mem_mem_data),  // 来自EX/MEM的写入数据
      .mem_we_i  (exmem_mem_mem_we),    // 来自EX/MEM的写使能
      .mem_re_i  (exmem_mem_mem_re),    // 来自EX/MEM的读使能
      .mem_data_o(mem_memwb_rd_data)    // 输出到MEM/WB的读取数据
  );

  // Register File
  regs u_regs (
      .clk        (clk),
      .rst        (rst),
      .reg1_addr_i(id_regs_rs1_addr),
      .reg2_addr_i(id_regs_rs2_addr),
      .reg1_data_o(regs_id_rs1_data),
      .reg2_data_o(regs_id_rs2_data),
      .reg_waddr_i(wb_regs_rd_addr),
      .reg_wdata_i(wb_regs_rd_data),
      .reg_wen    (wb_regs_rd_wen)
  );

endmodule
