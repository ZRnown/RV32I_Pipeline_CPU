module cpu_top (
    input  wire        clk,          // 系统时钟
    input  wire        rst,          // 复位（高有效）
    // ROM 接口
    input  wire [31:0] inst_i,       // 从 ROM 输入的指令
    output wire [31:0] inst_addr_o,  // 输出到 ROM 的指令地址
    // RAM 接口
    output wire [31:0] data_addr_o,  // 数据地址输出到外部 RAM 或 AXI
    output wire [31:0] data_o,       // 数据输出到外部 RAM 或 AXI（写数据）
    output wire        data_we_o,    // 数据写使能
    output wire        data_re_o,    // 数据读使能
    output wire [ 2:0] data_size_o,  // 数据大小（字节、半字、字）
    input  wire [31:0] data_i,       // 从外部 RAM 或 AXI 输入的数据
    input  wire [ 7:0] int_i,
    input  wire        hold_flag_i
);
  // PC to IF
  wire [31:0] pc_if_pc_addr;
  wire        rib_ctrl_hold_flag = hold_flag_i;

  // IF to IF/ID
  wire [31:0] if_ifid_inst;
  wire [31:0] if_ifid_pc_addr;

  // IF/ID to ID
  wire [31:0] ifid_id_inst;
  wire [31:0] ifid_id_pc_addr;

  // ID to Regs
  wire [ 4:0] id_regs_rs1_addr;
  wire [ 4:0] id_regs_rs2_addr;

  // Regs to ID
  wire [31:0] regs_id_rs1_data;
  wire [31:0] regs_id_rs2_data;

  // ID to ID/EX
  wire [31:0] id_idex_inst;
  wire [31:0] id_idex_pc_addr;
  wire [31:0] id_idex_op1;
  wire [31:0] id_idex_op2;
  wire [ 4:0] id_idex_rd_addr;
  wire        id_idex_reg_wen;
  wire [ 2:0] id_idex_mem_size;
  wire [31:0] id_idex_mem_wdata;
  wire        id_idex_mem_we;
  wire        id_idex_mem_re;
  wire [31:0] id_idex_csr_raddr;
  wire [31:0] id_idex_csr_waddr;
  wire        id_idex_csr_wen;
  wire [31:0] id_idex_rs1_data;
  wire [31:0] id_idex_rs2_data;

  // ID/EX to EX
  wire [31:0] idex_ex_inst;
  wire [31:0] idex_ex_pc_addr;
  wire [31:0] idex_ex_op1;
  wire [31:0] idex_ex_op2;
  wire [ 4:0] idex_ex_rd_addr;
  wire        idex_ex_reg_wen;
  wire [ 2:0] idex_ex_mem_size;
  wire [31:0] idex_ex_mem_wdata;
  wire        idex_ex_mem_we;
  wire        idex_ex_mem_re;
  wire [ 4:0] idex_ex_rs1_addr;
  wire [ 4:0] idex_ex_rs2_addr;
  wire [31:0] idex_ex_csr_raddr;
  wire [31:0] idex_ex_csr_waddr;
  wire        idex_ex_csr_wen;
  wire [31:0] idex_ex_rs1_data;
  wire [31:0] idex_ex_rs2_data;

  // EX to EX/MEM
  wire [ 4:0] ex_exmem_rd_addr;
  wire [31:0] ex_exmem_rd_data;
  wire        ex_exmem_reg_wen;
  wire [31:0] ex_exmem_mem_addr;
  wire [31:0] ex_exmem_mem_wdata;
  wire        ex_exmem_mem_we;
  wire        ex_exmem_mem_re;
  wire [ 2:0] ex_exmem_mem_size;

  // EX to Control
  wire [31:0] ex_ctrl_jump_addr;
  wire        ex_ctrl_jump_en;
  wire        ex_ctrl_hold_flag;

  // EX to CSR
  wire [31:0] ex_csr_wdata;
  wire [31:0] ex_csr_waddr;
  wire        ex_csr_wen;

  // CSR to ID
  wire [31:0] id_csr_raddr;
  wire [31:0] csr_id_rdata;

  // EX/MEM to MEM
  wire [ 4:0] exmem_mem_rd_addr;
  wire [31:0] exmem_mem_rd_data;
  wire        exmem_mem_reg_wen;
  wire        exmem_mem_mem_re;

  // MEM to MEM/WB
  wire [ 4:0] mem_memwb_rd_addr;
  wire [31:0] mem_memwb_rd_data;
  wire        mem_memwb_reg_wen;
  wire [31:0] mem_memwb_ram_rdata;
  wire        mem_memwb_mem_re;

  // MEM/WB to WB
  wire [ 4:0] memwb_wb_rd_addr;
  wire [31:0] memwb_wb_rd_data;
  wire        memwb_wb_reg_wen;
  wire [31:0] memwb_wb_ram_rdata;
  wire        memwb_wb_mem_re;

  // WB to Regs
  wire [ 4:0] wb_regs_rd_addr;
  wire [31:0] wb_regs_rd_data;
  wire        wb_regs_reg_wen;

  // Control to PC, IF/ID, ID/EX
  wire [31:0] ctrl_pc_jump_addr;
  wire        ctrl_pc_jump_en;
  wire        ctrl_hold_flag;

  // Clint to Control and EX
  wire        clint_ctrl_hold_flag;
  wire [31:0] clint_ex_int_addr;
  wire        clint_ex_int_assert;

  // Clint to CSR
  wire        clint_csr_we;
  wire [31:0] clint_csr_waddr;
  wire [31:0] clint_csr_raddr;
  wire [31:0] clint_csr_wdata;

  // CSR to Clint
  wire [31:0] csr_clint_data;
  wire [31:0] csr_clint_mtvec;
  wire [31:0] csr_clint_mepc;
  wire [31:0] csr_clint_mstatus;
  wire        csr_clint_global_int_en;

  // EX 阶段直接连接到外部 RAM 接口
  assign data_addr_o = ex_exmem_mem_addr;
  assign data_o      = ex_exmem_mem_wdata;
  assign data_we_o   = ex_exmem_mem_we;
  assign data_re_o   = ex_exmem_mem_re;
  assign data_size_o = ex_exmem_mem_size;
  assign inst_addr_o = pc_if_pc_addr;

  // 模块实例化
  pc_reg u_pc_reg (
      .clk        (clk),
      .rst        (rst),
      .jump_addr_i(ctrl_pc_jump_addr),
      .jump_en_i  (ctrl_pc_jump_en),
      .pc_o       (pc_if_pc_addr)
  );

  iF u_if (
      .pc_addr_i    (pc_if_pc_addr),
      .rom_inst_i   (inst_i),
      .if2rom_addr_o(inst_addr_o),
      .inst_addr_o  (if_ifid_pc_addr),
      .inst_o       (if_ifid_inst)
  );

  if_id u_if_id (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (if_ifid_inst),
      .inst_addr_i(if_ifid_pc_addr),
      .hold_flag_i(ctrl_hold_flag),
      .inst_o     (ifid_id_inst),
      .inst_addr_o(ifid_id_pc_addr)
  );

  id u_id (
      .inst_i       (ifid_id_inst),
      .inst_addr_i  (ifid_id_pc_addr),
      .rs1_addr_o   (id_regs_rs1_addr),
      .rs2_addr_o   (id_regs_rs2_addr),
      .rs1_data_i   (regs_id_rs1_data),
      .rs2_data_i   (regs_id_rs2_data),
      .inst_o       (id_idex_inst),
      .inst_addr_o  (id_idex_pc_addr),
      .op1_o        (id_idex_op1),
      .op2_o        (id_idex_op2),
      .rd_addr_o    (id_idex_rd_addr),
      .reg_wen      (id_idex_reg_wen),
      .mem_size_o   (id_idex_mem_size),
      .mem_data_o   (id_idex_mem_wdata),
      .mem_we_o     (id_idex_mem_we),
      .mem_re_o     (id_idex_mem_re),
      .ex_rd_addr_i (ex_exmem_rd_addr),
      .ex_result_i  (ex_exmem_rd_data),
      .ex_reg_wen_i (ex_exmem_reg_wen),
      .mem_rd_addr_i(mem_memwb_rd_addr),
      .mem_result_i (mem_memwb_rd_data),
      .mem_reg_wen_i(mem_memwb_reg_wen),
      .csr_rdata_o  (id_idex_csr_raddr),
      .csr_waddr_o  (id_idex_csr_waddr),
      .csr_wen      (id_idex_csr_wen),
      .rs1_data_o   (id_idex_rs1_data),
      .rs2_data_o   (id_idex_rs2_data),
      .csr_rdata_i  (csr_id_rdata),
      .csr_raddr_o  (id_csr_raddr)
  );

  id_ex u_id_ex (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (id_idex_inst),
      .inst_addr_i(id_idex_pc_addr),
      .op1_i      (id_idex_op1),
      .op2_i      (id_idex_op2),
      .rd_addr_i  (id_idex_rd_addr),
      .reg_wen_i  (id_idex_reg_wen),
      .mem_size_i (id_idex_mem_size),
      .mem_data_i (id_idex_mem_wdata),
      .mem_we_i   (id_idex_mem_we),
      .mem_re_i   (id_idex_mem_re),
      .hold_flag_i(ctrl_hold_flag),
      .csr_rdata_i(id_idex_csr_raddr),
      .csr_waddr_i(id_idex_csr_waddr),
      .csr_wen_i  (id_idex_csr_wen),
      .rs1_data_i (id_idex_rs1_data),
      .rs2_data_i (id_idex_rs2_data),
      .csr_rdata_o(idex_ex_csr_raddr),
      .csr_waddr_o(idex_ex_csr_waddr),
      .csr_wen_o  (idex_ex_csr_wen),
      .inst_o     (idex_ex_inst),
      .inst_addr_o(idex_ex_pc_addr),
      .op1_o      (idex_ex_op1),
      .op2_o      (idex_ex_op2),
      .rd_addr_o  (idex_ex_rd_addr),
      .reg_wen_o  (idex_ex_reg_wen),
      .mem_size_o (idex_ex_mem_size),
      .mem_data_o (idex_ex_mem_wdata),
      .mem_we_o   (idex_ex_mem_we),
      .mem_re_o   (idex_ex_mem_re),
      .rs1_addr_i (id_regs_rs1_addr),
      .rs1_addr_o (idex_ex_rs1_addr),
      .rs2_addr_i (id_regs_rs2_addr),
      .rs2_addr_o (idex_ex_rs2_addr),
      .rs1_data_o (idex_ex_rs1_data),
      .rs2_data_o (idex_ex_rs2_data)
  );

  ex u_ex (
      .inst_i      (idex_ex_inst),
      .inst_addr_i (idex_ex_pc_addr),
      .op1_i       (idex_ex_op1),
      .op2_i       (idex_ex_op2),
      .rd_addr_i   (idex_ex_rd_addr),
      .rd_wen_i    (idex_ex_reg_wen),
      .mem_data_i  (idex_ex_mem_wdata),
      .mem_size_i  (idex_ex_mem_size),
      .mem_we_i    (idex_ex_mem_we),
      .mem_re_i    (idex_ex_mem_re),
      .rs1_addr_i  (idex_ex_rs1_addr),
      .rs2_addr_i  (idex_ex_rs2_addr),
      .rs1_data_i  (idex_ex_rs1_data),
      .rs2_data_i  (idex_ex_rs2_data),
      .rd_addr_o   (ex_exmem_rd_addr),
      .rd_data_o   (ex_exmem_rd_data),
      .rd_wen_o    (ex_exmem_reg_wen),
      .mem_addr_o  (ex_exmem_mem_addr),
      .mem_data_o  (ex_exmem_mem_wdata),
      .mem_size_o  (ex_exmem_mem_size),
      .mem_we_o    (ex_exmem_mem_we),
      .mem_re_o    (ex_exmem_mem_re),
      .jump_addr_o (ex_ctrl_jump_addr),
      .jump_en_o   (ex_ctrl_jump_en),
      .hold_flag_o (ex_ctrl_hold_flag),
      .mem_rd_data (mem_memwb_rd_data),
      .mem_rd_addr (mem_memwb_rd_addr),
      .mem_reg_wen (mem_memwb_reg_wen),
      .mem_mem_re_i(mem_memwb_mem_re),
      .wb_rd_data  (memwb_wb_rd_data),
      .wb_rd_addr  (memwb_wb_rd_addr),
      .wb_reg_wen  (memwb_wb_reg_wen),
      .wb_mem_re_i (memwb_wb_mem_re),
      .ram_data_i  (mem_memwb_ram_rdata),
      .csr_rdata_i (idex_ex_csr_raddr),
      .csr_waddr_i (idex_ex_csr_waddr),
      .csr_wen_i   (idex_ex_csr_wen),
      .csr_wdata_o (ex_csr_wdata),
      .csr_waddr_o (ex_csr_waddr),
      .csr_wen_o   (ex_csr_wen),
      .int_assert_i(clint_ex_int_assert),
      .int_addr_i  (clint_ex_int_addr)
  );

  ex_mem u_ex_mem (
      .clk      (clk),
      .rst      (rst),
      .rd_addr_i(ex_exmem_rd_addr),
      .rd_data_i(ex_exmem_rd_data),
      .rd_wen_i (ex_exmem_reg_wen),
      .mem_re_i (ex_exmem_mem_re),
      .rd_addr_o(exmem_mem_rd_addr),
      .rd_data_o(exmem_mem_rd_data),
      .rd_wen_o (exmem_mem_reg_wen),
      .mem_re_o (exmem_mem_mem_re)
  );

  mem u_mem (
      .rd_addr_i (exmem_mem_rd_addr),
      .rd_data_i (exmem_mem_rd_data),
      .rd_wen_i  (exmem_mem_reg_wen),
      .ram_data_i(data_i),
      .mem_re_i  (exmem_mem_mem_re),
      .rd_addr_o (mem_memwb_rd_addr),
      .rd_data_o (mem_memwb_rd_data),
      .rd_wen_o  (mem_memwb_reg_wen),
      .ram_data_o(mem_memwb_ram_rdata),
      .mem_re_o  (mem_memwb_mem_re)
  );

  mem_wb u_mem_wb (
      .clk       (clk),
      .rst       (rst),
      .rd_addr_i (mem_memwb_rd_addr),
      .rd_data_i (mem_memwb_rd_data),
      .rd_wen_i  (mem_memwb_reg_wen),
      .ram_data_i(mem_memwb_ram_rdata),
      .mem_re_i  (mem_memwb_mem_re),
      .rd_addr_o (memwb_wb_rd_addr),
      .rd_data_o (memwb_wb_rd_data),
      .rd_wen_o  (memwb_wb_reg_wen),
      .ram_data_o(memwb_wb_ram_rdata),
      .mem_re_o  (memwb_wb_mem_re)
  );

  wb u_wb (
      .rd_addr_i (memwb_wb_rd_addr),
      .rd_data_i (memwb_wb_rd_data),
      .rd_wen_i  (memwb_wb_reg_wen),
      .ram_data_i(memwb_wb_ram_rdata),
      .mem_re_i  (memwb_wb_mem_re),
      .rd_addr_o (wb_regs_rd_addr),
      .rd_data_o (wb_regs_rd_data),
      .rd_wen_o  (wb_regs_reg_wen)
  );

  control u_control (
      .jump_addr_i      (ex_ctrl_jump_addr),
      .jump_en_i        (ex_ctrl_jump_en),
      .hold_flag_ex_i   (ex_ctrl_hold_flag),
      .hold_flag_clint_i(clint_ctrl_hold_flag),
      .hold_flag_rib_i  (rib_ctrl_hold_flag),
      .jump_addr_o      (ctrl_pc_jump_addr),
      .jump_en_o        (ctrl_pc_jump_en),
      .hold_flag_o      (ctrl_hold_flag)
  );

  regs u_regs (
      .clk        (clk),
      .rst        (rst),
      .reg1_addr_i(id_regs_rs1_addr),
      .reg2_addr_i(id_regs_rs2_addr),
      .reg1_data_o(regs_id_rs1_data),
      .reg2_data_o(regs_id_rs2_data),
      .reg_addr_i (wb_regs_rd_addr),
      .reg_data_i (wb_regs_rd_data),
      .reg_wen    (wb_regs_reg_wen)
  );

  clint u_clint (
      .clk            (clk),
      .rst            (rst),
      .int_flag_i     (),                         // 未连接
      .inst_i         (if_ifid_inst),
      .inst_addr_i    (if_ifid_pc_addr),
      .jump_flag_i    (ex_ctrl_jump_en),
      .jump_addr_i    (ex_ctrl_jump_addr),
      .hold_flag_i    (ctrl_hold_flag),
      .data_i         (csr_clint_data),
      .csr_mtvec      (csr_clint_mtvec),
      .csr_mepc       (csr_clint_mepc),
      .csr_mstatus    (csr_clint_mstatus),
      .global_int_en_i(csr_clint_global_int_en),
      .hold_flag_o    (clint_ctrl_hold_flag),
      .we_o           (clint_csr_we),
      .waddr_o        (clint_csr_waddr),
      .raddr_o        (clint_csr_raddr),
      .data_o         (clint_csr_wdata),
      .int_addr_o     (clint_ex_int_addr),
      .int_assert_o   (clint_ex_int_assert)
  );

  csr_reg u_csr_reg (
      .clk              (clk),
      .rst              (rst),
      .we_i             (ex_csr_wen),
      .raddr_i          (id_csr_raddr),
      .waddr_i          (ex_csr_waddr),
      .data_i           (ex_csr_wdata),
      .clint_we_i       (clint_csr_we),
      .clint_raddr_i    (clint_csr_raddr),
      .clint_waddr_i    (clint_csr_waddr),
      .clint_data_i     (clint_csr_wdata),
      .global_int_en_o  (csr_clint_global_int_en),
      .clint_data_o     (csr_clint_data),
      .clint_csr_mtvec  (csr_clint_mtvec),
      .clint_csr_mepc   (csr_clint_mepc),
      .clint_csr_mstatus(csr_clint_mstatus),
      .data_o           (csr_id_rdata)
  );

endmodule
