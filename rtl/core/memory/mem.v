// 访存阶段
module mem (
    // from ex_mem
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire        mem_re_i,
    // from RAM
    input  wire [31:0] ram_data_i,
    // to mem_wb
    output reg  [ 4:0] rd_addr_o,
    output reg  [31:0] rd_data_o,
    output reg         rd_wen_o,
    output reg  [31:0] ram_data_o,
    output reg         mem_re_o
);
  always @(*) begin
    rd_addr_o  = rd_addr_i;
    rd_wen_o   = rd_wen_i;
    rd_data_o  = rd_data_i;
    ram_data_o = ram_data_i;
    mem_re_o   = mem_re_i;
  end
endmodule
