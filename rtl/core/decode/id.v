// id => instruction decode 译码模块
`include "../common/defines.v"
module id (
    // from if_id
    input wire [31:0] inst_i,
    input wire [31:0] inst_addr_i,
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
    output reg reg_wen
);

  wire [ 6:0] opcode = inst_i[6:0];
  wire [11:0] imm = inst_i[31:20];
  wire [ 4:0] rs1 = inst_i[19:15];
  wire [ 4:0] rs2 = inst_i[24:20];
  wire [ 4:0] rd = inst_i[11:7];
  wire [ 2:0] funct3 = inst_i[14:12];
  wire [ 6:0] funct7 = inst_i[31:25];

  always @(*) begin
    inst_o = inst_i;
    inst_addr_o = inst_addr_i;
    case (opcode)
      `INST_TYPE_I: begin
        case (funct3)
          `INST_ADDI: begin
            rs1_addr_o = rs1;  // 寄存器1
            rs2_addr_o = 5'b0;
            op1_o = rs1_data_i;
            op2_o = {{20{imm[11]}}, imm};
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
          `INST_ADD_SUB: begin
            rs1_addr_o = rs1;  // 寄存器1
            rs2_addr_o = rs2;  // 寄存器2
            op1_o = rs1_data_i;
            op2_o = rs2_data_i;
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
      `INST_JAL: begin
        rs1_addr_o = 5'b0;
        rs2_addr_o = 5'b0;
        op1_o      = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
        op2_o      = 32'b0;
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
endmodule
