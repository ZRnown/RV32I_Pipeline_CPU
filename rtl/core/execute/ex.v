`include "../common/defines.v"
module ex (
    // from id_ex
    input wire [31:0] inst_i,
    input wire [31:0] inst_addr_i,
    input wire [31:0] op1_i,
    input wire [31:0] op2_i,
    input wire [4:0] rd_addr_i,
    input wire rd_wen_i,
    // to regs
    output reg [4:0] rd_addr_o,
    output reg [31:0] rd_data_o,
    output reg rd_wen_o,
    // to control
    output reg [31:0] jump_addr_o,
    output reg jump_en_o,
    output reg hold_flag_o
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
  wire op1_i_equal_op2_i = (op1_i == op2_i) ? 1'b1 : 1'b0;
  wire op1_i_less_op2_i_signed = ($signed(op1_i) < $signed(op2_i)) ? 1'b1 : 1'b0;
  wire op1_i_less_op2_i_unsigned = (op1_i < op2_i) ? 1'b1 : 1'b0;
  // tpye I
  wire [31:0] SRA_mask = (32'hffff_ffff) >> op2_i[4:0];
  
  always @(*) begin
    case (opcode)
      `INST_TYPE_I: begin
        jump_addr_o = 32'b0;
        jump_en_o   = 1'b0;
        hold_flag_o = 1'b0;
        case (funct3)
          `INST_ADDI: begin
            rd_data_o = op1_i + op2_i;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
		  `INST_SLTI: begin
            rd_data_o = {30'b0, op1_i_equal_op2_i};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
		  `INST_SLTIU: begin
            rd_data_o = {30'b0, op1_i_less_op2_i_unsigned};
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
		  `INST_XORI: begin
            rd_data_o = op1_i ^ op2_i;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
		  `INST_ORI: begin
            rd_data_o = op1_i | op2_i;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
		  `INST_ANDI: begin
            rd_data_o = op1_i & op2_i;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
		  `INST_SLLI: begin
            rd_data_o = op1_i << shamt;
            rd_addr_o = rd_addr_i;
            rd_wen_o  = 1'b1;
          end
		  `INST_SRI:begin
		    if (funct7[5] == 1'b1) begin
			  rd_data_o = ((op1_i >> shamt) & SRA_mask) | ({32{op1_i[31]}} & (~SRA_mask));
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
			end
			else begin
			  rd_data_o = op1_i >> op2_i[4:0];
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
		   end
		  end
          default:begin
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
              rd_data_o = op1_i + op2_i;
			  rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
            end
			else begin
              rd_data_o = op1_i - op2_i;
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
			end
          end
		  `INST_SLL: begin
              rd_data_o = op1_i << op2_i[4:0];
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
              rd_data_o = op1_i ^ op2_i;
			  rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
		  end
		  `INST_OR: begin
              rd_data_o = op1_i | op2_i;
			  rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
		  end
		  `INST_AND: begin
              rd_data_o = op1_i & op2_i;
			  rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
		  end
		  `INST_SR: begin
              if (funct7[5] == 1'b1) begin
			  rd_data_o = ((op1_i >> op2_i[4:0]) & SRA_mask) | ({32{op1_i[31]}} & (~SRA_mask));
              rd_addr_o = rd_addr_i;
              rd_wen_o  = 1'b1;
			end
			else begin
			  rd_data_o = op1_i >> op2_i[4:0];
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
          default: begin
            jump_addr_o = 32'b0;
            jump_en_o   = 1'b0;
            hold_flag_o = 1'b0;
          end
        endcase
      end
      `INST_JAL: begin
        rd_addr_o = rd_addr_i;
        rd_data_o = inst_addr_i + 32'h4;
        jump_addr_o = op1_i + inst_addr_i;
        rd_wen_o = 1'b1;
        jump_en_o = 1'b1;
        hold_flag_o = 1'b0;
      end
      `INST_LUI: begin
        rd_addr_o = rd_addr_i;
        rd_data_o = op1_i;
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
