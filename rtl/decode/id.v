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
  wire [ 6:0] opcode;
  wire [ 4:0] rd;
  wire [ 2:0] funct3;
  wire [ 4:0] rs1;
  wire [11:0] imm;
  assign opcode = inst_i[6:0];
  assign rd     = inst_i[11:7];
  assign funct3 = inst_i[14:12];
  assign rs1    = inst_i[19:15];
  assign imm    = inst_i[31:20];

  always @(*) begin
    case (opcode)
        `INST_TYPE_I: begin
            case (funct3)
                `INST_ADDI: begin
                    rs1_addr_o = rs1; // 寄存器1
                    rs2_addr_o = 5'b0;
                    rd_addr_o = rd; // 目标寄存器
                    op1_o = rs1_data_i;
                    op2_o = {{20{imm[11]}},imm};
                    reg_wen = 1'b1;
                end
                `INST_SLTI:
                `INST_SLTIU:
                `INST_XORI:
                `INST_ORI:
                `INST_ANDI:
                `INST_SLLI:
                `INST_SRI:
                default: 
            endcase
        end
        `INST_TYPE_L: 
        `INST_TYPE_S:
        default: begin
            
        end
    endcase
  end

endmodule
