// 回写阶段
module wb (
    // from mem_wb
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire        mem_re_i,
    input  wire [31:0] csr_wdata_i,
    input  wire [31:0] csr_waddr_i,
    input  wire        csr_wen_i,
    // from mem_wb
    input  wire [31:0] ram_data_i,   // RAM 返回的读取数据
    // to regs
    output wire [ 4:0] rd_addr_o,
    output wire [31:0] rd_data_o,
    output wire        rd_wen_o,
    // to csr_reg
    output wire [31:0] csr_wdata_o,
    output wire [31:0] csr_waddr_o,
    output wire        csr_wen_o
);
  assign rd_addr_o = rd_addr_i;
  assign rd_data_o = (mem_re_i) ? ram_data_i : rd_data_i;
  assign rd_wen_o = rd_wen_i;
  assign csr_wdata_o = csr_wdata_i;
  assign csr_waddr_o = csr_waddr_i;
  assign csr_wen_o = csr_wen_i;
endmodule
