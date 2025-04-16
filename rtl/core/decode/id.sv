`include "../common/defines.sv"

module id (
    // Inputs from if_id
    input  wire [31:0] inst_i,         // 指令
    input  wire [31:0] inst_addr_i,    // 指令地址
    // Outputs to registers
    output reg  [ 4:0] rs1_addr_o,     // 源寄存器1地址
    output reg  [ 4:0] rs2_addr_o,     // 源寄存器2地址
    // Inputs from registers
    input  wire [31:0] rs1_data_i,     // 源寄存器1数据
    input  wire [31:0] rs2_data_i,     // 源寄存器2数据
    // Outputs to CSR register
    output reg  [31:0] csr_raddr_o,    // CSR读地址
    // Inputs from CSR register
    input  wire [31:0] csr_rdata_i,    // CSR读数据
    // Inputs from EX and MEM (data forwarding)
    input  wire [ 4:0] ex_rd_addr_i,   // EX阶段目标寄存器地址
    input  wire [31:0] ex_result_i,    // EX阶段计算结果
    input  wire        ex_reg_wen_i,   // EX阶段寄存器写使能
    input  wire [ 4:0] mem_rd_addr_i,  // MEM阶段目标寄存器地址
    input  wire [31:0] mem_result_i,   // MEM阶段计算结果
    input  wire        mem_reg_wen_i,  // MEM阶段寄存器写使能
    // Outputs to id_ex
    output reg  [31:0] inst_o,         // 指令
    output reg  [31:0] inst_addr_o,    // 指令地址
    output reg  [31:0] op1_o,          // 操作数1
    output reg  [31:0] op2_o,          // 操作数2
    output reg  [ 4:0] rd_addr_o,      // 目标寄存器地址
    output reg         reg_wen,        // 寄存器写使能
    output reg  [ 2:0] mem_size_o,     // 内存访问大小
    output reg  [31:0] mem_data_o,     // 内存写数据
    output reg         mem_we_o,       // 内存写使能
    output reg         mem_re_o,       // 内存读使能
    output reg  [31:0] csr_waddr_o,    // CSR写地址
    output reg  [31:0] csr_rdata_o,    // CSR读数据
    output reg         csr_wen,        // CSR写使能
    output reg  [31:0] rs1_data_o,     // 源寄存器1数据
    output reg  [31:0] rs2_data_o      // 源寄存器2数据
);

  // Instruction field parsing
  wire [ 6:0] opcode = inst_i[6:0];  // 操作码
  wire [11:0] imm = inst_i[31:20];  // I-type立即数
  wire [11:0] s_imm = {inst_i[31:25], inst_i[11:7]};  // S-type立即数
  wire [ 4:0] rs1 = inst_i[19:15];  // 源寄存器1
  wire [ 4:0] rs2 = inst_i[24:20];  // 源寄存器2
  wire [ 4:0] rd = inst_i[11:7];  // 目标寄存器
  wire [ 2:0] funct3 = inst_i[14:12];  // 功能码3
  wire [ 6:0] funct7 = inst_i[31:25];  // 功能码7
  wire [ 4:0] shamt = inst_i[24:20];  // 移位量

  // Internal signals for forwarding
  reg  [31:0] rs1_data;  // 前递后的源寄存器1数据
  reg  [31:0] rs2_data;  // 前递后的源寄存器2数据

  // Combinational logic
  always @(*) begin
    // Default values
    rs1_data    = rs1_data_i;
    rs2_data    = rs2_data_i;
    rs1_data_o  = rs1_data_i;
    rs2_data_o  = rs2_data_i;
    csr_rdata_o = csr_rdata_i;
    inst_o      = inst_i;
    inst_addr_o = inst_addr_i;
    mem_we_o    = 1'b0;
    mem_re_o    = 1'b0;
    mem_size_o  = 3'b0;
    rs1_addr_o  = 5'b0;
    rs2_addr_o  = 5'b0;
    op1_o       = 32'b0;
    op2_o       = 32'b0;
    rd_addr_o   = 5'b0;
    reg_wen     = 1'b0;
    mem_data_o  = 32'b0;
    csr_raddr_o = 32'b0;
    csr_waddr_o = 32'b0;
    csr_wen     = 1'b0;

    // Data forwarding logic
    // From MEM stage
    if (mem_reg_wen_i && mem_rd_addr_i != 5'b0 && mem_rd_addr_i == rs1) begin
      rs1_data = mem_result_i;
    end
    if (mem_reg_wen_i && mem_rd_addr_i != 5'b0 && mem_rd_addr_i == rs2) begin
      rs2_data = mem_result_i;
    end
    // From EX stage (higher priority)
    if (ex_reg_wen_i && ex_rd_addr_i != 5'b0 && ex_rd_addr_i == rs1) begin
      rs1_data = ex_result_i;
    end
    if (ex_reg_wen_i && ex_rd_addr_i != 5'b0 && ex_rd_addr_i == rs2) begin
      rs2_data = ex_result_i;
    end

    // Instruction decode
    case (opcode)
      `INST_TYPE_I: begin
        case (funct3)
          `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI: begin
            rs1_addr_o = rs1;
            rs2_addr_o = 5'b0;
            op1_o      = rs1_data_i;
            op2_o      = {{20{imm[11]}}, imm};
            rd_addr_o  = rd;
            reg_wen    = 1'b1;
          end
          `INST_SLLI, `INST_SRI: begin
            rs1_addr_o = rs1;
            rs2_addr_o = 5'b0;
            op1_o      = rs1_data_i;
            op2_o      = {27'b0, shamt};
            rd_addr_o  = rd;
            reg_wen    = 1'b1;
          end
          default: begin
            rs1_addr_o = 5'b0;
            rs2_addr_o = 5'b0;
            op1_o      = 32'b0;
            op2_o      = 32'b0;
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
          end
        endcase
      end
      `INST_TYPE_R_M: begin
        case (funct3)
          `INST_ADD_SUB, `INST_SLL, `INST_SLT, `INST_SLTU, `INST_XOR, `INST_SR, `INST_OR, `INST_AND: begin
            rs1_addr_o = rs1;
            rs2_addr_o = rs2;
            op1_o      = rs1_data_i;
            op2_o      = rs2_data_i;
            rd_addr_o  = rd;
            reg_wen    = 1'b1;
          end
          default: begin
            rs1_addr_o = 5'b0;
            rs2_addr_o = 5'b0;
            op1_o      = 32'b0;
            op2_o      = 32'b0;
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
          end
        endcase
      end
      `INST_TYPE_B: begin
        case (funct3)
          `INST_BEQ, `INST_BNE, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU: begin
            rs1_addr_o = rs1;
            rs2_addr_o = rs2;
            op1_o      = rs1_data_i;
            op2_o      = rs2_data_i;
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
          end
          default: begin
            rs1_addr_o = 5'b0;
            rs2_addr_o = 5'b0;
            op1_o      = 32'b0;
            op2_o      = 32'b0;
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
          end
        endcase
      end
      `INST_TYPE_S: begin
        case (funct3)
          `INST_SW, `INST_SH, `INST_SB: begin
            rs1_addr_o = rs1;
            rs2_addr_o = rs2;
            op1_o      = rs1_data;
            op2_o      = {{20{s_imm[11]}}, s_imm};
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
            mem_we_o   = 1'b1;
            mem_re_o   = 1'b0;
            mem_size_o = funct3;
            case (funct3)
              `INST_SW: mem_data_o = rs2_data;
              `INST_SH: mem_data_o = {16'b0, rs2_data[15:0]};
              `INST_SB: mem_data_o = {24'b0, rs2_data[7:0]};
              default:  mem_data_o = 32'b0;
            endcase
          end
          default: begin
            rs1_addr_o = 5'b0;
            rs2_addr_o = 5'b0;
            op1_o      = 32'b0;
            op2_o      = 32'b0;
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
            mem_we_o   = 1'b0;
            mem_re_o   = 1'b0;
            mem_size_o = 3'b0;
            mem_data_o = 32'b0;
          end
        endcase
      end
      `INST_TYPE_L: begin
        case (funct3)
          `INST_LW, `INST_LH, `INST_LB, `INST_LHU, `INST_LBU: begin
            rs1_addr_o = rs1;
            rs2_addr_o = 5'b0;
            op1_o      = rs1_data_i;
            op2_o      = {{20{imm[11]}}, imm};
            rd_addr_o  = rd;
            reg_wen    = 1'b1;
            mem_re_o   = 1'b1;
            mem_we_o   = 1'b0;
            mem_size_o = funct3;
          end
          default: begin
            rs1_addr_o = 5'b0;
            rs2_addr_o = 5'b0;
            op1_o      = 32'b0;
            op2_o      = 32'b0;
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
            mem_we_o   = 1'b0;
            mem_re_o   = 1'b0;
            mem_size_o = 3'b0;
          end
        endcase
      end
      `INST_JAL: begin
        rs1_addr_o = 5'b0;
        rs2_addr_o = 5'b0;
        op1_o      = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
        op2_o      = 32'b0;
        rd_addr_o  = rd;
        reg_wen    = 1'b1;
      end
      `INST_JALR: begin
        rs1_addr_o = rs1;
        rs2_addr_o = 5'b0;
        op1_o      = rs1_data_i;
        op2_o      = {{20{imm[11]}}, imm};
        rd_addr_o  = rd;
        reg_wen    = 1'b1;
      end
      `INST_LUI: begin
        rs1_addr_o = 5'b0;
        rs2_addr_o = 5'b0;
        op1_o      = {inst_i[31:12], 12'b0};
        op2_o      = 32'b0;
        rd_addr_o  = rd;
        reg_wen    = 1'b1;
      end
      `INST_AUIPC: begin
        rs1_addr_o = 5'b0;
        rs2_addr_o = 5'b0;
        op1_o      = {inst_i[31:12], 12'b0};
        op2_o      = inst_addr_i;
        rd_addr_o  = rd;
        reg_wen    = 1'b1;
      end
      `INST_CSR: begin
        csr_raddr_o = {20'h0, inst_i[31:20]};
        csr_waddr_o = {20'h0, inst_i[31:20]};
        rd_addr_o   = rd;
        reg_wen     = 1'b1;
        case (funct3)
          `INST_CSRRW, `INST_CSRRS, `INST_CSRRC: begin
            rs1_addr_o = rs1;
            rs2_addr_o = 5'b0;
            csr_wen    = 1'b1;
          end
          `INST_CSRRWI, `INST_CSRRSI, `INST_CSRRCI: begin
            rs1_addr_o = 5'b0;
            rs2_addr_o = 5'b0;
            csr_wen    = 1'b1;
          end
          default: begin
            rs1_addr_o = 5'b0;
            rs2_addr_o = 5'b0;
            rd_addr_o  = 5'b0;
            reg_wen    = 1'b0;
            csr_wen    = 1'b0;
          end
        endcase
      end
      default: begin
        rs1_addr_o  = 5'b0;
        rs2_addr_o  = 5'b0;
        op1_o       = 32'b0;
        op2_o       = 32'b0;
        rd_addr_o   = 5'b0;
        reg_wen     = 1'b0;
        mem_data_o  = 32'b0;
        mem_size_o  = 3'b0;
        mem_we_o    = 1'b0;
        mem_re_o    = 1'b0;
        csr_raddr_o = 32'b0;
        csr_waddr_o = 32'b0;
        csr_wen     = 1'b0;
      end
    endcase
  end

endmodule
