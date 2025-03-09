module ifetch (
    // from PC
    input wire [31:0] pc_addr_i,
    // instruction from ROM
    input wire [31:0] rom_inst_i,
    // to ROM
    output wire [31:0] if2rom_addr_o,
    // to 译码模块
    output wire [31:0] inst_addr_o,  // 指令的地址
    output wire [31:0] inst_o  // 指令
);
  assign inst_addr_o = pc_addr_i;
  assign inst_o = rom_inst_i;
  assign if2rom_addr_o = pc_addr_i;
endmodule
