// 访存阶段
module mem (
    // from ex_mem
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire [31:0] mem_addr_i,
    input  wire [31:0] mem_data_i,
    input  wire        mem_we_i,
    input  wire        mem_re_i,
    // to RAM
    output wire [31:0] mem_addr_o,
    output wire [31:0] mem_data_o,
    output wire        mem_we_o,
    output wire        mem_re_o,
    // to mem_wb
    output wire [ 4:0] rd_addr_o,
    output wire [31:0] rd_data_o,
    output wire        rd_wen_o
);
  assign mem_addr_o = mem_addr_i;
  assign mem_data_o = mem_data_i;
  assign mem_we_o   = mem_we_i;
  assign mem_re_o   = mem_re_i;
  assign rd_addr_o  = rd_addr_i;
  assign rd_data_o  = rd_data_i;
  assign rd_wen_o   = rd_wen_i;
endmodule
