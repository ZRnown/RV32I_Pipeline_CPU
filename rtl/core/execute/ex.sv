// 执行阶段 (Execute Stage)
// 负责执行指令的运算、跳转判断、内存访问控制及 CSR 操作
`include "../common/defines.sv"

module ex (
    // 从 ID/EX 流水线寄存器输入
    input  wire [31:0] inst_i,        // 指令
    input  wire [31:0] inst_addr_i,   // 指令地址 (PC)
    input  wire [31:0] op1_i,         // 操作数 1
    input  wire [31:0] op2_i,         // 操作数 2
    input  wire [ 4:0] rd_addr_i,     // 目标寄存器地址
    input  wire        rd_wen_i,      // 目标寄存器写使能
    input  wire [31:0] mem_data_i,    // 内存写数据 (如 SW 指令)
    input  wire [ 2:0] mem_size_i,    // 内存访问大小 (字节/半字/字)
    input  wire        mem_we_i,      // 内存写使能
    input  wire        mem_re_i,      // 内存读使能
    input  wire [ 4:0] rs1_addr_i,    // 源寄存器 1 地址
    input  wire [ 4:0] rs2_addr_i,    // 源寄存器 2 地址
    input  wire [31:0] csr_rdata_i,   // CSR 读数据
    input  wire [31:0] csr_waddr_i,   // CSR 写地址
    input  wire        csr_wen_i,     // CSR 写使能
    input  wire [31:0] rs1_data_i,    // 源寄存器 1 数据
    input  wire [31:0] rs2_data_i,    // 源寄存器 2 数据
    // 从 MEM 阶段前递输入
    input  wire [31:0] mem_rd_data,   // MEM 阶段目标寄存器数据
    input  wire [ 4:0] mem_rd_addr,   // MEM 阶段目标寄存器地址
    input  wire        mem_reg_wen,   // MEM 阶段寄存器写使能
    input  wire        mem_mem_re_i,  // MEM 阶段内存读使能
    // 从 WB 阶段前递输入
    input  wire [31:0] wb_rd_data,    // WB 阶段目标寄存器数据
    input  wire [ 4:0] wb_rd_addr,    // WB 阶段目标寄存器地址
    input  wire        wb_reg_wen,    // WB 阶段寄存器写使能
    input  wire        wb_mem_re_i,   // WB 阶段内存读使能
    // 从 RAM 输入
    input  wire [31:0] ram_data_i,    // RAM 读数据
    // 从 Clint 输入
    input  wire        int_assert_i,  // 中断发生标志
    input  wire [31:0] int_addr_i,    // 中断跳转地址
    // 输出到 EX/MEM 流水线寄存器
    output reg  [ 4:0] rd_addr_o,     // 目标寄存器地址
    output reg  [31:0] rd_data_o,     // 目标寄存器数据
    output reg         rd_wen_o,      // 目标寄存器写使能
    // 输出到 CSR 寄存器
    output reg  [31:0] csr_wdata_o,   // CSR 写数据
    output reg  [31:0] csr_waddr_o,   // CSR 写地址
    output reg         csr_wen_o,     // CSR 写使能
    // 输出到 RAM
    output reg  [31:0] mem_addr_o,    // 内存访问地址
    output reg  [31:0] mem_data_o,    // 内存写数据
    output reg  [ 2:0] mem_size_o,    // 内存访问大小
    output reg         mem_we_o,      // 内存写使能
    output reg         mem_re_o,      // 内存读使能
    // 输出到控制单元
    output reg  [31:0] jump_addr_o,   // 跳转地址
    output reg         jump_en_o,     // 跳转使能
    output reg         hold_flag_o    // 流水线暂停标志
);
  // 指令字段解析
  wire [6:0] opcode = inst_i[6:0];  // 操作码
  wire [4:0] rd = inst_i[11:7];  // 目标寄存器
  wire [2:0] funct3 = inst_i[14:12];  // 功能码 3
  wire [4:0] rs1 = inst_i[19:15];  // 源寄存器 1
  wire [4:0] rs2 = inst_i[24:20];  // 源寄存器 2
  wire [6:0] funct7 = inst_i[31:25];  // 功能码 7
  wire [11:0] imm = inst_i[31:20];  // 立即数 (I 型)
  wire [4:0] uimm = inst_i[19:15];  // 无符号立即数 (CSR)
  wire [4:0] shamt = inst_i[24:20];  // 移位量
  // 分支指令立即数
  wire [31:0] jump_imm = {
    {19{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0
  };

  // 内部信号
  reg op1_i_equal_op2_i;  // 操作数相等标志
  reg op1_i_less_op2_i_signed;  // 有符号小于标志
  reg op1_i_less_op2_i_unsigned;  // 无符号小于标志
  reg [31:0] op1;  // 前递后的操作数 1
  reg [31:0] op2;  // 前递后的操作数 2
  // 组合逻辑
  always @(*) begin
    // 默认输出
    rd_data_o   = 32'b0;
    rd_addr_o   = 5'b0;
    rd_wen_o    = 1'b0;
    mem_addr_o  = 32'b0;
    mem_data_o  = 32'b0;
    mem_we_o    = 1'b0;
    mem_re_o    = 1'b0;
    mem_size_o  = 3'b0;
    jump_addr_o = 32'b0;
    jump_en_o   = 1'b0;
    hold_flag_o = 1'b0;
    csr_wdata_o = 32'b0;
    csr_waddr_o = csr_waddr_i;
    csr_wen_o   = csr_wen_i;

    // rs1 前递逻辑
    if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs1_addr_i) begin
      op1 = mem_mem_re_i ? ram_data_i : mem_rd_data;  // 从 MEM 阶段前递
    end else if (wb_reg_wen && wb_rd_addr != 5'b0 && wb_rd_addr == rs1_addr_i) begin
      op1 = wb_mem_re_i ? ram_data_i : wb_rd_data;  // 从 WB 阶段前递
    end else begin
      op1 = op1_i;  // 使用 ID 阶段数据
    end

    // rs2 前递逻辑
    if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs2_addr_i) begin
      op2 = mem_mem_re_i ? ram_data_i : mem_rd_data;  // 从 MEM 阶段前递
    end else if (wb_reg_wen && wb_rd_addr != 5'b0 && wb_rd_addr == rs2_addr_i) begin
      op2 = wb_mem_re_i ? ram_data_i : wb_rd_data;  // 从 WB 阶段前递
    end else begin
      op2 = op2_i;  // 使用 ID 阶段数据
    end

    // 比较逻辑
    op1_i_equal_op2_i         = (op1 == op2);
    op1_i_less_op2_i_signed   = ($signed(op1) < $signed(op2));
    op1_i_less_op2_i_unsigned = (op1 < op2);

    // 指令执行逻辑
    case (opcode)
      `INST_TYPE_I: begin  // I 型指令 (如 ADDI, SLTI, ANDI 等)
        case (funct3)
          `INST_ADDI: begin
            rd_data_o = op1 + op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLTI: begin
            rd_data_o = {31'b0, op1_i_less_op2_i_signed};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLTIU: begin
            rd_data_o = {31'b0, op1_i_less_op2_i_unsigned};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_XORI: begin
            rd_data_o = op1 ^ op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_ORI: begin
            rd_data_o = op1 | op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_ANDI: begin
            rd_data_o = op1 & op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLLI: begin
            rd_data_o = op1 << shamt;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SRI: begin
            if (funct7[5]) begin  // SRAI
              rd_data_o = $signed(op1) >>> shamt;
            end else begin  // SRLI
              rd_data_o = op1 >> inst_i[24:20];
            end
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          default: begin
            rd_data_o = 32'b0;
            rd_addr_o = 5'b0;
            rd_wen_o  = 1'b0;
          end
        endcase
      end
      `INST_TYPE_R_M: begin  // R 型指令 (如 ADD, SUB, SLL 等)
        case (funct3)
          `INST_ADD_SUB: begin
            rd_data_o = funct7[5] ? (op1 - op2) : (op1 + op2);  // SUB or ADD
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLL: begin
            rd_data_o = op1 << op2[4:0];
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLT: begin
            rd_data_o = {31'b0, op1_i_less_op2_i_signed};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLTU: begin
            rd_data_o = {31'b0, op1_i_less_op2_i_unsigned};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_XOR: begin
            rd_data_o = op1 ^ op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_OR: begin
            rd_data_o = op1 | op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_AND: begin
            rd_data_o = op1 & op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SR: begin
            if (funct7[5]) begin  // SRA
              rd_data_o = $signed(op1) >>> op2[4:0];
            end else begin  // SRL
              rd_data_o = op1 >> op2[4:0];
            end
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          default: begin
            rd_data_o = 32'b0;
            rd_addr_o = 5'b0;
            rd_wen_o  = 1'b0;
          end
        endcase
      end
      `INST_TYPE_B: begin  // B 型指令 (分支指令)
        case (funct3)
          `INST_BEQ: begin
            jump_addr_o = inst_addr_i + jump_imm;
            jump_en_o   = op1_i_equal_op2_i;
          end
          `INST_BNE: begin
            jump_addr_o = inst_addr_i + jump_imm;
            jump_en_o   = ~op1_i_equal_op2_i;
          end
          `INST_BLT: begin
            jump_addr_o = inst_addr_i + jump_imm;
            jump_en_o   = op1_i_less_op2_i_signed;
          end
          `INST_BGE: begin
            jump_addr_o = inst_addr_i + jump_imm;
            jump_en_o   = ~op1_i_less_op2_i_signed;
          end
          `INST_BLTU: begin
            jump_addr_o = inst_addr_i + jump_imm;
            jump_en_o   = op1_i_less_op2_i_unsigned;
          end
          `INST_BGEU: begin
            jump_addr_o = inst_addr_i + jump_imm;
            jump_en_o   = ~op1_i_less_op2_i_unsigned;
          end
          default: begin
            jump_addr_o = 32'b0;
            jump_en_o   = 1'b0;
          end
        endcase
      end
      `INST_TYPE_S: begin  // S 型指令 (存储指令)
        case (funct3)
          `INST_SB, `INST_SH, `INST_SW: begin
            mem_we_o   = mem_we_i;
            mem_re_o   = mem_re_i;
            mem_addr_o = op1 + op2_i;
            mem_data_o = mem_data_i;
            mem_size_o = mem_size_i;
          end
          default: begin
            mem_we_o   = 1'b0;
            mem_re_o   = 1'b0;
            mem_addr_o = 32'b0;
            mem_data_o = 32'b0;
            mem_size_o = 3'b0;
          end
        endcase
      end
      `INST_TYPE_L: begin  // L 型指令 (加载指令)
        case (funct3)
          `INST_LB, `INST_LH, `INST_LW, `INST_LHU, `INST_LBU: begin
            mem_we_o   = mem_we_i;
            mem_re_o   = mem_re_i;
            mem_addr_o = op1 + op2;
            mem_data_o = 32'b0;
            mem_size_o = mem_size_i;
            rd_addr_o  = rd_addr_i;
            rd_wen_o   = rd_wen_i;
          end
          default: begin
            mem_we_o   = 1'b0;
            mem_re_o   = 1'b0;
            mem_addr_o = 32'b0;
            mem_data_o = 32'b0;
            mem_size_o = 3'b0;
            rd_addr_o  = 5'b0;
            rd_wen_o   = 1'b0;
          end
        endcase
      end
      `INST_CSR: begin  // CSR 指令
        case (funct3)
          `INST_CSRRW: begin
            csr_wdata_o = rs1_data_i;
            rd_data_o   = csr_rdata_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
          end
          `INST_CSRRS: begin
            csr_wdata_o = rs1_data_i | csr_rdata_i;
            rd_data_o   = csr_rdata_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
          end
          `INST_CSRRC: begin
            csr_wdata_o = csr_rdata_i & (~rs1_data_i);
            rd_data_o   = csr_rdata_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
          end
          `INST_CSRRWI: begin
            csr_wdata_o = {27'h0, uimm};
            rd_data_o   = csr_rdata_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
          end
          `INST_CSRRSI: begin
            csr_wdata_o = {27'h0, uimm} | csr_rdata_i;
            rd_data_o   = csr_rdata_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
          end
          `INST_CSRRCI: begin
            csr_wdata_o = (~{27'h0, uimm}) & csr_rdata_i;
            rd_data_o   = csr_rdata_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
          end
          default: begin
            csr_wdata_o = 32'b0;
            rd_data_o   = 32'b0;
            rd_addr_o   = 5'b0;
            rd_wen_o    = 1'b0;
          end
        endcase
      end
      `INST_JAL: begin  // JAL 指令
        rd_data_o   = inst_addr_i + 32'h4;
        rd_addr_o   = rd_addr_i;
        rd_wen_o    = 1'b1;
        jump_addr_o = op1 + inst_addr_i;
        jump_en_o   = 1'b1;
      end
      `INST_JALR: begin  // JALR 指令
        rd_data_o   = inst_addr_i + 32'h4;
        rd_addr_o   = rd_addr_i;
        rd_wen_o    = 1'b1;
        jump_addr_o = op1 + op2;
        jump_en_o   = 1'b1;
      end
      `INST_LUI: begin  // LUI 指令
        rd_data_o = op1;
        rd_addr_o = rd_addr_i;
        rd_wen_o  = 1'b1;
      end
      `INST_AUIPC: begin  // AUIPC 指令
        rd_data_o = op1 + op2;
        rd_addr_o = rd_addr_i;
        rd_wen_o  = 1'b1;
      end
      default: begin
        rd_data_o   = 32'b0;
        rd_addr_o   = 5'b0;
        rd_wen_o    = 1'b0;
        jump_addr_o = 32'b0;
        jump_en_o   = 1'b0;
        hold_flag_o = 1'b0;
      end
    endcase
  end
endmodule
