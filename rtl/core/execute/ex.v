// 执行阶段
`include "../common/defines.v"
module ex (
    // from id_ex
    input  wire [31:0] inst_i,
    input  wire [31:0] inst_addr_i,
    input  wire [31:0] op1_i,
    input  wire [31:0] op2_i,
    input  wire [ 4:0] rd_addr_i,
    input  wire        rd_wen_i,
    input  wire [31:0] mem_data_i,
    input  wire [ 2:0] mem_size_i,
    input  wire        mem_we_i,
    input  wire        mem_re_i,
    input  wire [ 4:0] rs1_addr_i,
    input  wire [ 4:0] rs2_addr_i,
    // from mem (数据前递)
    input  wire [31:0] mem_rd_data,   // MEM 阶段的数据
    input  wire [ 4:0] mem_rd_addr,   // MEM 阶段的目标寄存器地址
    input  wire        mem_reg_wen,   // MEM 阶段的写使能
    input  wire        mem_mem_re_i,
    // from wb (数据前递)
    input  wire [31:0] wb_rd_data,    // WB 阶段的内存加载数据
    input  wire [ 4:0] wb_rd_addr,    // WB 阶段的目标寄存器地址
    input  wire        wb_reg_wen,    // WB 阶段的写使能
    input  wire        wb_mem_re_i,
    // from RAM
    input  wire [31:0] ram_data_i,
    // to ex_mem
    output reg  [ 4:0] rd_addr_o,
    output reg  [31:0] rd_data_o,
    output reg         rd_wen_o,
    // to RAM
    output reg  [31:0] mem_addr_o,    // 访存地址（如 LW/SW 的地址）
    output reg  [31:0] mem_data_o,    // 写入内存的数据（SW 指令）
    output reg  [ 2:0] mem_size_o,
    output reg         mem_we_o,
    output reg         mem_re_o,
    // to control
    output reg  [31:0] jump_addr_o,
    output reg         jump_en_o,
    output reg         hold_flag_o
);
  // 指令字段解析
  wire [6:0] opcode = inst_i[6:0];
  wire [4:0] rd = inst_i[11:7];
  wire [2:0] funct3 = inst_i[14:12];
  wire [4:0] rs1 = inst_i[19:15];
  wire [4:0] rs2 = inst_i[24:20];
  wire [6:0] funct7 = inst_i[31:25];
  wire [11:0] imm = inst_i[31:20];
  wire [4:0] shamt = inst_i[24:20];
  // branch imm
  wire [31:0] jump_imm = {
    {19{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0
  };
  reg [31:0] op1;
  reg [31:0] op2;
  reg op1_i_equal_op2_i;
  reg op1_i_less_op2_i_signed;
  reg op1_i_less_op2_i_unsigned;
  reg [31:0] SRA_mask;
  always @(*) begin
    // rs1 前递逻辑
    if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs1_addr_i) begin
      if (mem_mem_re_i) op1 = ram_data_i;
      else op1 = mem_rd_data;  // 从 MEM 阶段前递
    end else if (wb_reg_wen && wb_rd_addr != 5'b0 && wb_rd_addr == rs1_addr_i) begin
      if (wb_mem_re_i) op1 = ram_data_i;
      else op1 = wb_rd_data;  // 从 WB 阶段前递（针对 lw）
    end else op1 = op1_i;  // 使用 ID 阶段传递的寄存器数据
    // rs2 前递逻辑
    if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs2_addr_i) begin
      if (mem_mem_re_i) op2 = ram_data_i;
      else op2 = mem_rd_data;  // 从 MEM 阶段前递
    end else if (wb_reg_wen && wb_rd_addr != 5'b0 && wb_rd_addr == rs2_addr_i) begin
      if (wb_mem_re_i) op2 = ram_data_i;
      else op2 = wb_rd_data;  // 从 WB 阶段前递（针对 lw）
    end else op2 = op2_i;  // 使用 ID 阶段传递的寄存器数据
    op1_i_equal_op2_i = (op1 == op2) ? 1'b1 : 1'b0;
    op1_i_less_op2_i_signed = ($signed(op1) < $signed(op2)) ? 1'b1 : 1'b0;
    op1_i_less_op2_i_unsigned = (op1 < op2) ? 1'b1 : 1'b0;
    // tpye I
    SRA_mask = (32'hffff_ffff) >>> op2[4:0];
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
    case (opcode)
      `INST_TYPE_I: begin
        jump_addr_o = 32'b0;
        jump_en_o   = 1'b0;
        hold_flag_o = 1'b0;
        case (funct3)
          `INST_ADDI: begin
            rd_data_o = op1 + op2;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLTI: begin
            rd_data_o = {30'b0, op1_i_less_op2_i_signed};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLTIU: begin
            rd_data_o = {30'b0, op1_i_less_op2_i_unsigned};
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
            if (funct7[5] == 1'b1) begin
              rd_data_o = ((op1 >> shamt) & SRA_mask) | ({32{op1[31]}} & (~SRA_mask));
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
            end else begin
              rd_data_o = op1 >> op2[4:0];
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
            end
          end
          default: begin
            rd_data_o = 32'b0;
            rd_addr_o = 5'b0;
            rd_wen_o  = 1'b0;
          end
        endcase
      end
      `INST_TYPE_R_M: begin
        jump_addr_o = 32'b0;
        jump_en_o   = 1'b0;
        hold_flag_o = 1'b0;
        case (funct3)
          `INST_ADD_SUB: begin
            if (funct7[5] == 1'b0) begin
              rd_data_o = op1 + op2;
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
            end else begin
              rd_data_o = op1 - op2;
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
            end
          end
          `INST_SLL: begin
            rd_data_o = op1 << op2[4:0];
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLT: begin
            rd_data_o = {30'b0, op1_i_less_op2_i_signed};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
          `INST_SLTU: begin
            rd_data_o = {30'b0, op1_i_less_op2_i_unsigned};
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
            if (funct7[5] == 1'b1) begin
              rd_data_o = ((op1 >> op2[4:0]) & SRA_mask) | ({32{op1_i[31]}} & (~SRA_mask));
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
            end else begin
              rd_data_o = op1 >> op2[4:0];
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
            end
          end
          default: begin
            rd_addr_o = 5'b0;
            rd_data_o = 32'b0;
            rd_wen_o  = 1'b0;
          end
        endcase
      end
      `INST_TYPE_B: begin
        rd_data_o = 32'b0;
        rd_addr_o = 5'b0;
        rd_wen_o  = 1'b0;
        case (funct3)
          `INST_BEQ: begin
            jump_addr_o = (inst_addr_i + jump_imm) & {32{(op1_i_equal_op2_i)}};
            jump_en_o   = op1_i_equal_op2_i;
            hold_flag_o = 1'b0;
          end
          `INST_BNE: begin
            jump_addr_o = (inst_addr_i + jump_imm) & {32{(~op1_i_equal_op2_i)}};
            jump_en_o   = ~op1_i_equal_op2_i;
            hold_flag_o = 1'b0;
          end
          `INST_BLT: begin
            jump_addr_o = (inst_addr_i + jump_imm) & {32{(op1_i_less_op2_i_signed)}};
            jump_en_o   = op1_i_less_op2_i_signed;
            hold_flag_o = 1'b0;
          end
          `INST_BGE: begin
            jump_addr_o = (inst_addr_i + jump_imm) & {32{(~op1_i_less_op2_i_signed)}};
            jump_en_o   = ~op1_i_less_op2_i_signed;
            hold_flag_o = 1'b0;
          end
          `INST_BLTU: begin
            jump_addr_o = (inst_addr_i + jump_imm) & {32{(op1_i_less_op2_i_unsigned)}};
            jump_en_o   = op1_i_less_op2_i_unsigned;
            hold_flag_o = 1'b0;
          end
          `INST_BGEU: begin
            jump_addr_o = (inst_addr_i + jump_imm) & {32{(~op1_i_less_op2_i_unsigned)}};
            jump_en_o   = ~op1_i_less_op2_i_unsigned;
            hold_flag_o = 1'b0;
          end
          default: begin
            jump_addr_o = 32'b0;
            jump_en_o   = 1'b0;
            hold_flag_o = 1'b0;
          end
        endcase
      end
      `INST_TYPE_S: begin
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
      `INST_TYPE_L: begin
        case (funct3)
          `INST_LB, `INST_LH, `INST_LW, `INST_LHU, `INST_LBU: begin
            mem_we_o   = mem_we_i;
            mem_re_o   = mem_re_i;
            mem_addr_o = op1 + op2;
            mem_data_o = 32'b0;
            mem_size_o = mem_size_i;
            rd_addr_o  = rd_addr_i;
            rd_wen_o   = rd_wen_i;
            rd_data_o  = 32'b0;
          end
          default: begin
            mem_we_o   = 1'b0;
            mem_re_o   = 1'b0;
            mem_addr_o = 32'b0;
            mem_data_o = 32'b0;
            mem_size_o = 3'b0;
            rd_addr_o  = 5'b0;
            rd_wen_o   = 1'b0;
            rd_data_o  = 32'b0;
          end
        endcase
      end
      `INST_JAL: begin
        rd_data_o = inst_addr_i + 32'h4;
        rd_addr_o = rd_addr_i;
        rd_wen_o = 1'b1;
        jump_addr_o = op1 + inst_addr_i;
        jump_en_o = 1'b1;
        hold_flag_o = 1'b0;
      end
      `INST_JALR: begin
        rd_data_o = inst_addr_i + 32'h4;
        rd_addr_o = rd_addr_i;
        rd_wen_o = 1'b1;
        jump_addr_o = op1 + op2;
        jump_en_o = 1'b1;
        hold_flag_o = 1'b0;
      end
      `INST_LUI: begin
        rd_data_o = op1;
        rd_addr_o = rd_addr_i;
        rd_wen_o = 1'b1;
        jump_addr_o = 32'b0;
        jump_en_o = 1'b0;
        hold_flag_o = 1'b0;
      end
      `INST_AUIPC: begin
        rd_data_o = op1 + op2;
        rd_addr_o = rd_addr_i;
        rd_wen_o = 1'b1;
        jump_addr_o = 32'b0;
        jump_en_o = 1'b0;
        hold_flag_o = 1'b0;
      end
      default: begin
        rd_data_o = 32'b0;
        rd_addr_o = 5'b0;
        rd_wen_o = 1'b0;
        jump_addr_o = 32'b0;
        jump_en_o = 1'b0;
        hold_flag_o = 1'b0;
      end
    endcase
  end
endmodule
