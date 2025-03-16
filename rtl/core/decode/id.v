// id => instruction decode 译码阶段
`include "../common/defines.v"
module id (
    // from if_id
    input wire [31:0] inst_i,
    input wire [31:0] inst_addr_i,
    // from ex (数据相关性)
    input wire [31:0] ex_rd_data,  // EX 阶段的 ALU 计算结果
    input wire [4:0] ex_rd_addr,  // EX 阶段的目标寄存器地址
    input wire ex_reg_wen,  // EX 阶段的写使能
    // from mem (数据相关性)
    input wire [31:0] mem_rd_data,  // MEM 阶段的数据（例如加载指令的结果）
    input wire [4:0] mem_rd_addr,  // MEM 阶段的目标寄存器地址
    input wire mem_reg_wen,  // MEM 阶段的写使能
    // to regs
    output reg [4:0] rs1_addr_o,
    output reg [4:0] rs2_addr_o,
    // from regs
    input wire [31:0] rs1_data_i,
    input wire [31:0] rs2_data_i,
    // to id_ex 
    output reg [31:0] inst_o,
    output reg [31:0] inst_addr_o,
    output reg [31:0] op1_o,
    output reg [31:0] op2_o,
    output reg [4:0] rd_addr_o,
    output reg reg_wen,
    output reg  [ 2:0] mem_size_o,  // 新增：操作宽度 (000=byte, 001=half, 010=word, 100=byte_u, 101=half_u)
    output reg mem_we_o,  // 写内存使能
    output reg mem_re_o  // 读内存使能
);
  // 指令解析
  wire [ 6:0] opcode = inst_i[6:0];
  wire [11:0] imm = inst_i[31:20];
  wire [11:0] s_imm = {inst_i[31:25], inst_i[11:7]};  // S-type 立即数
  wire [ 4:0] rs1 = inst_i[19:15];
  wire [ 4:0] rs2 = inst_i[24:20];
  wire [ 4:0] rd = inst_i[11:7];
  wire [ 2:0] funct3 = inst_i[14:12];
  wire [ 6:0] funct7 = inst_i[31:25];
  wire [ 4:0] shamt = inst_i[24:20];
  // 前递逻辑(解决数据相关性)
  reg [31:0] rs1_data, rs2_data;
  always @(*) begin
    // rs1 前递
    if (ex_reg_wen && ex_rd_addr != 5'b0 && ex_rd_addr == rs1)
      rs1_data = ex_rd_data;  // 从 EX 模块前递
    else if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs1)
      rs1_data = mem_rd_data;  // 从 MEM 模块前递
    else rs1_data = rs1_data_i;  // 从 regs 读取（包含 WB 旁路）
    // rs2 前递
    if (ex_reg_wen && ex_rd_addr != 5'b0 && ex_rd_addr == rs2)
      rs2_data = ex_rd_data;  // 从 EX 模块前递
    else if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs2)
      rs2_data = mem_rd_data;  // 从 MEM 模块前递
    else rs2_data = rs2_data_i;  // 从 regs 读取（包含 WB 旁路）
    inst_o = inst_i;
    inst_addr_o = inst_addr_i;
    mem_we_o = 1'b0;
    mem_re_o = 1'b0;
    mem_size_o = 3'b0;  // 默认字节操作
    case (opcode)
      `INST_TYPE_I: begin
        case (funct3)
          `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI: begin
            rs1_addr_o = rs1;  // 寄存器1
            rs2_addr_o = 5'b0;
            op1_o = rs1_data;
            op2_o = {{20{imm[11]}}, imm};
            rd_addr_o = rd;  // 目标寄存器
            reg_wen = 1'b1;
          end
          `INST_SLLI, `INST_SRI: begin
            rs1_addr_o = rs1;  // 寄存器1
            rs2_addr_o = 5'b0;
            op1_o = rs1_data;
            op2_o = {27'b0, shamt};
            rd_addr_o = rd;  // 目标寄存器
            reg_wen = 1'b1;
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
          `INST_ADD_SUB,`INST_SLL,`INST_SLT,`INST_SLTU,`INST_XOR,`INST_SR,`INST_OR,`INST_AND: begin
            rs1_addr_o = rs1;  // 寄存器1
            rs2_addr_o = rs2;  // 寄存器2
            op1_o = rs1_data;
            op2_o = rs2_data;
            rd_addr_o = rd;  // 目标寄存器
            reg_wen = 1'b1;
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
          `INST_BNE, `INST_BEQ: begin
            rs1_addr_o = rs1;  // 寄存器1
            rs2_addr_o = rs2;  // 寄存器2
            op1_o      = rs1_data;
            op2_o      = rs2_data;
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
            if (funct3 == `INST_SW) mem_size_o = `INST_SW;
            else if (funct3 == `INST_SH) mem_size_o = `INST_SH;
            else mem_size_o = `INST_SB;
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
      `INST_TYPE_L: begin
        case (funct3)
          `INST_LW, `INST_LH, `INST_LB, `INST_LHU, `INST_LBU: begin
            rs1_addr_o = rs1;
            rs2_addr_o = 5'b0;
            op1_o      = rs1_data;
            op2_o      = {{20{imm[11]}}, imm};
            rd_addr_o  = rd;
            mem_re_o   = 1'b1;
            mem_we_o   = 1'b0;
            reg_wen    = 1'b1;
            if (funct3 == `INST_LW) mem_size_o = `INST_LW;
            else if (funct3 == `INST_LH) mem_size_o = `INST_LH;
            else if (funct3 == `INST_LB) mem_size_o = `INST_LB;
            else if (funct3 == `INST_LHU) mem_size_o = `INST_LHU;
            else mem_size_o = `INST_LBU;
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
            mem_size_o = 3'b000;
          end
        endcase
      end
      `INST_JAL: begin
        rs1_addr_o = 5'b0;
        rs2_addr_o = 5'b0;
        op1_o      = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
        op2_o      = 32'b0;
        rd_addr_o  = rd;
        reg_wen    = 1'b0;
      end
      `INST_LUI: begin
        rs1_addr_o = 5'b0;
        rs2_addr_o = 5'b0;
        op1_o      = {inst_i[31:12], 12'b0};
        op2_o      = 32'b0;
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
endmodule
