// 回写阶段
module wb (
    // from mem_wb
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire        mem_re_i,
    // from mem_wb
    input  wire [31:0] ram_data_i,  // RAM 返回的读取数据
    // to regs
    output wire [ 4:0] rd_addr_o,
    output wire [31:0] rd_data_o,
    output wire        rd_wen_o
);
  assign rd_addr_o = rd_addr_i;
  assign rd_data_o = (mem_re_i) ? ram_data_i : rd_data_i;
  assign rd_wen_o  = rd_wen_i;
endmodule
