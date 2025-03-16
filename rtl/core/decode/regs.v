// 32个通用寄存器
module regs (
    input wire clk,
    input wire rst,
    // from id
    input wire [4:0] reg1_addr_i,
    input wire [4:0] reg2_addr_i,
    // to id
    output reg [31:0] reg1_data_o,
    output reg [31:0] reg2_data_o,
    // from wb
    input wire [4:0] reg_waddr_i,
    input wire [31:0] reg_wdata_i,
    input reg_wen
);
  reg [31:0] regs[0:31];
  integer i;
  // 读寄存器1 
  always @(*) begin
    if (rst == 1'b0) reg1_data_o = 32'b0;
    else if (reg1_addr_i == 5'b0) reg1_data_o = 32'b0;
    else if (reg_wen && reg1_addr_i == reg_waddr_i) reg1_data_o = reg_wdata_i;
    else reg1_data_o = regs[reg1_addr_i];
  end
  // 读寄存器2
  always @(*) begin
    if (rst == 1'b0) reg2_data_o = 32'b0;
    else if (reg2_addr_i == 5'b0) reg2_data_o = 32'b0;
    else if (reg_wen && reg2_addr_i == reg_waddr_i) reg2_data_o = reg_wdata_i;
    else reg2_data_o = regs[reg2_addr_i];
  end
  // 写寄存器
  always @(posedge clk or negedge rst) begin
    if (rst == 1'b0) for (i = 0; i < 32; i = i + 1) regs[i] <= 32'b0;
    else if (reg_wen && reg_waddr_i != 5'b0) regs[reg_waddr_i] <= reg_wdata_i;
  end
endmodule
