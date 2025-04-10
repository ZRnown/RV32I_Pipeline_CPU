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
    // AXI4-Lite 主设备接口
    output wire [31:0] m_awaddr,     // 写地址
    output wire [ 2:0] m_awprot,     // 写保护（默认 3'b000）
    output wire        m_awvalid,    // 写地址有效
    input  wire        m_awready,    // 写地址准备好
    output wire [31:0] m_wdata,      // 写数据
    output wire [ 3:0] m_wstrb,      // 字节选通
    output wire        m_wvalid,     // 写数据有效
    input  wire        m_wready,     // 写数据准备好
    input  wire [ 1:0] m_bresp,      // 写响应
    input  wire        m_bvalid,     // 写响应有效
    output wire        m_bready,     // 主设备准备好接收响应
    output wire [31:0] m_araddr,     // 读地址
    output wire [ 2:0] m_arprot,     // 读保护（默认 3'b000）
    output wire        m_arvalid,    // 读地址有效
    input  wire        m_arready,    // 读地址准备好
    input  wire [31:0] m_rdata,      // 读数据
    input  wire [ 1:0] m_rresp,      // 读响应
    input  wire        m_rvalid,     // 读数据有效
    output wire        m_rready      // 主设备准备好接收数据
);

  // 内部信号声明 - 按流水线阶段分组
  // PC to IF
  wire [31:0] pc_if_pc_addr;  // PC 输出到 IF 的程序计数器地址

  // IF to IF/ID
  wire [31:0] if_ifid_inst;  // IF 到 IF/ID 的指令
  wire [31:0] if_ifid_pc_addr;  // IF 到 IF/ID 的 PC 地址

  // IF/ID to ID
  wire [31:0] ifid_id_inst;  // IF/ID 到 ID 的指令
  wire [31:0] ifid_id_pc_addr;  // IF/ID 到 ID 的 PC 地址

  // ID to Regs
  wire [ 4:0] id_regs_rs1_addr;  // ID 到寄存器堆的源寄存器 1 地址
  wire [ 4:0] id_regs_rs2_addr;  // ID 到寄存器堆的源寄存器 2 地址

  // Regs to ID
  wire [31:0] regs_id_rs1_data;  // 寄存器堆到 ID 的源寄存器 1 数据
  wire [31:0] regs_id_rs2_data;  // 寄存器堆到 ID 的源寄存器 2 数据

  // ID to ID/EX
  wire [31:0] id_idex_inst;  // ID 到 ID/EX 的指令
  wire [31:0] id_idex_pc_addr;  // ID 到 ID/EX 的 PC 地址
  wire [31:0] id_idex_op1;  // ID 到 ID/EX 的操作数 1
  wire [31:0] id_idex_op2;  // ID 到 ID/EX 的操作数 2
  wire [ 4:0] id_idex_rd_addr;  // ID 到 ID/EX 的目标寄存器地址
  wire        id_idex_reg_wen;  // ID 到 ID/EX 的寄存器写使能
  wire [ 2:0] id_idex_mem_size;  // ID 到 ID/EX 的内存访问大小
  wire [31:0] id_idex_mem_wdata;  // ID 到 ID/EX 的内存写数据
  wire        id_idex_mem_we;  // ID 到 ID/EX 的内存写使能
  wire        id_idex_mem_re;  // ID 到 ID/EX 的内存读使能
  wire [31:0] id_idex_csr_raddr;  // ID 到 ID/EX 的 CSR 读地址
  wire [31:0] id_idex_csr_waddr;  // ID 到 ID/EX 的 CSR 写地址
  wire        id_idex_csr_wen;  // ID 到 ID/EX 的 CSR 写使能
  wire [31:0] id_idex_rs1_data;  // ID 到 ID/EX 的源寄存器 1 数据
  wire [31:0] id_idex_rs2_data;  // ID 到 ID/EX 的源寄存器 2 数据

  // ID/EX to EX
  wire [31:0] idex_ex_inst;  // ID/EX 到 EX 的指令
  wire [31:0] idex_ex_pc_addr;  // ID/EX 到 EX 的 PC 地址
  wire [31:0] idex_ex_op1;  // ID/EX 到 EX 的操作数 1
  wire [31:0] idex_ex_op2;  // ID/EX 到 EX 的操作数 2
  wire [ 4:0] idex_ex_rd_addr;  // ID/EX 到 EX 的目标寄存器地址
  wire        idex_ex_reg_wen;  // ID/EX 到 EX 的寄存器写使能
  wire [ 2:0] idex_ex_mem_size;  // ID/EX 到 EX 的内存访问大小
  wire [31:0] idex_ex_mem_wdata;  // ID/EX 到 EX 的内存写数据
  wire        idex_ex_mem_we;  // ID/EX 到 EX 的内存写使能
  wire        idex_ex_mem_re;  // ID/EX 到 EX 的内存读使能
  wire [ 4:0] idex_ex_rs1_addr;  // ID/EX 到 EX 的源寄存器 1 地址
  wire [ 4:0] idex_ex_rs2_addr;  // ID/EX 到 EX 的源寄存器 2 地址
  wire [31:0] idex_ex_csr_raddr;  // ID/EX 到 EX 的 CSR 读地址
  wire [31:0] idex_ex_csr_waddr;  // ID/EX 到 EX 的 CSR 写地址
  wire        idex_ex_csr_wen;  // ID/EX 到 EX 的 CSR 写使能
  wire [31:0] idex_ex_rs1_data;  // ID/EX 到 EX 的源寄存器 1 数据
  wire [31:0] idex_ex_rs2_data;  // ID/EX 到 EX 的源寄存器 2 数据

  // EX to EX/MEM
  wire [ 4:0] ex_exmem_rd_addr;  // EX 到 EX/MEM 的目标寄存器地址
  wire [31:0] ex_exmem_rd_data;  // EX 到 EX/MEM 的目标寄存器数据
  wire        ex_exmem_reg_wen;  // EX 到 EX/MEM 的寄存器写使能
  wire [31:0] ex_exmem_mem_addr;  // EX 到 EX/MEM 的内存地址
  wire [31:0] ex_exmem_mem_wdata;  // EX 到 EX/MEM 的内存写数据
  wire        ex_exmem_mem_we;  // EX 到 EX/MEM 的内存写使能
  wire        ex_exmem_mem_re;  // EX 到 EX/MEM 的内存读使能
  wire [ 2:0] ex_exmem_mem_size;  // EX 到 EX/MEM 的内存访问大小

  // EX to Control
  wire [31:0] ex_ctrl_jump_addr;  // EX 到 Control 的跳转地址
  wire        ex_ctrl_jump_en;  // EX 到 Control 的跳转使能
  wire        ex_ctrl_hold_flag;  // EX 到 Control 的流水线暂停标志

  // EX to CSR
  wire [31:0] ex_csr_wdata;  // EX 到 CSR 的写数据
  wire [31:0] ex_csr_waddr;  // EX 到 CSR 的写地址
  wire        ex_csr_wen;  // EX 到 CSR 的写使能

  // CSR to ID
  wire [31:0] id_csr_raddr;  // ID 到 CSR 的读地址
  wire [31:0] csr_id_rdata;  // CSR 到 ID 的读数据

  // EX/MEM to MEM
  wire [ 4:0] exmem_mem_rd_addr;  // EX/MEM 到 MEM 的目标寄存器地址
  wire [31:0] exmem_mem_rd_data;  // EX/MEM 到 MEM 的目标寄存器数据
  wire        exmem_mem_reg_wen;  // EX/MEM 到 MEM 的寄存器写使能
  wire [31:0] exmem_mem_ram_rdata;  // EX/MEM 到 MEM 的 RAM 读数据
  wire        exmem_mem_mem_re;  // EX/MEM 到 MEM 的内存读使能

  // MEM to MEM/WB
  wire [ 4:0] mem_memwb_rd_addr;  // MEM 到 MEM/WB 的目标寄存器地址
  wire [31:0] mem_memwb_rd_data;  // MEM 到 MEM/WB 的目标寄存器数据
  wire        mem_memwb_reg_wen;  // MEM 到 MEM/WB 的寄存器写使能
  wire [31:0] mem_memwb_ram_rdata;  // MEM 到 MEM/WB 的 RAM 读数据
  wire        mem_memwb_mem_re;  // MEM 到 MEM/WB 的内存读使能

  // MEM/WB to WB
  wire [ 4:0] memwb_wb_rd_addr;  // MEM/WB 到 WB 的目标寄存器地址
  wire [31:0] memwb_wb_rd_data;  // MEM/WB 到 WB 的目标寄存器数据
  wire        memwb_wb_reg_wen;  // MEM/WB 到 WB 的寄存器写使能
  wire [31:0] memwb_wb_ram_rdata;  // MEM/WB 到 WB 的 RAM 读数据
  wire        memwb_wb_mem_re;  // MEM/WB 到 WB 的内存读使能

  // WB to Regs
  wire [ 4:0] wb_regs_rd_addr;  // WB 到寄存器堆的目标寄存器地址
  wire [31:0] wb_regs_rd_data;  // WB 到寄存器堆的目标寄存器数据
  wire        wb_regs_reg_wen;  // WB 到寄存器堆的寄存器写使能

  // Control to PC, IF/ID, ID/EX
  wire [31:0] ctrl_pc_jump_addr;  // Control 到 PC 的跳转地址
  wire        ctrl_pc_jump_en;  // Control 到 PC 的跳转使能
  wire        ctrl_hold_flag;  // Control 到各阶段的流水线暂停标志

  // EX 阶段直接连接到外部 RAM 接口
  assign data_addr_o = ex_exmem_mem_addr;
  assign data_o      = ex_exmem_mem_wdata;
  assign data_we_o   = ex_exmem_mem_we;
  assign data_re_o   = ex_exmem_mem_re;
  assign data_size_o = ex_exmem_mem_size;

  // 模块实例化
  // Program Counter (PC)
  pc_reg u_pc_reg (
      .clk        (clk),
      .rst        (rst),
      .jump_addr_i(ctrl_pc_jump_addr),
      .jump_en_i  (ctrl_pc_jump_en),
      .pc_o       (pc_if_pc_addr)
  );

  // Instruction Fetch (IF)
  iF u_if (
      .pc_addr_i    (pc_if_pc_addr),
      .rom_inst_i   (inst_i),
      .if2rom_addr_o(inst_addr_o),
      .inst_addr_o  (if_ifid_pc_addr),
      .inst_o       (if_ifid_inst)
  );

  // IF/ID Pipeline Register
  if_id u_if_id (
      .clk        (clk),
      .rst        (rst),
      .inst_i     (if_ifid_inst),
      .inst_addr_i(if_ifid_pc_addr),
      .hold_flag_i(ctrl_hold_flag),
      .inst_o     (ifid_id_inst),
      .inst_addr_o(ifid_id_pc_addr)
  );

  // Instruction Decode (ID)
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

  // ID/EX Pipeline Register
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

  // Execute (EX)
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
      .csr_wen_o   (ex_csr_wen)
  );

  // EX/MEM Pipeline Register
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

  // Memory (MEM)
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

  // MEM/WB Pipeline Register
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

  // Write Back (WB)
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

  // Control Unit
  control u_control (
      .jump_addr_i   (ex_ctrl_jump_addr),
      .jump_en_i     (ex_ctrl_jump_en),
      .hold_flag_ex_i(ex_ctrl_hold_flag),
      .jump_addr_o   (ctrl_pc_jump_addr),
      .jump_en_o     (ctrl_pc_jump_en),
      .hold_flag_o   (ctrl_hold_flag)
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
      .reg_wen    (wb_regs_reg_wen)
  );

  // CSR Register
  csr_reg u_csr_reg (
      .clk              (clk),
      .rst              (rst),
      .we_i             (ex_csr_wen),
      .raddr_i          (id_csr_raddr),
      .waddr_i          (ex_csr_waddr),
      .data_i           (ex_csr_wdata),
      .clint_we_i       (),              // 未连接，留空以支持后续扩展
      .clint_raddr_i    (),              // 未连接
      .clint_waddr_i    (),              // 未连接
      .clint_data_i     (),              // 未连接
      .global_int_en_o  (),              // 未连接
      .clint_data_o     (),              // 未连接
      .clint_csr_mtvec  (),              // 未连接
      .clint_csr_mepc   (),              // 未连接
      .clint_csr_mstatus(),              // 未连接
      .data_o           (csr_id_rdata)
  );

endmodule
