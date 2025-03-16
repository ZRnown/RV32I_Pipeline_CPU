// 访存阶段
module mem (
    // from ex_mem
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire [31:0] mem_addr_i,
    input  wire [31:0] mem_data_i,
    input  wire [ 2:0] mem_size_i,
    input  wire        mem_we_i,
    input  wire        mem_re_i,
    // from RAM
    input  wire [31:0] ram_data_i,  // RAM 返回的读取数据
    // to RAM
    output wire [31:0] mem_addr_o,
    output wire [31:0] mem_data_o,
    output wire [ 2:0] mem_size_o,
    output wire        mem_we_o,
    output wire        mem_re_o,
    // to mem_wb
    output wire [ 4:0] rd_addr_o,
    output wire [31:0] rd_data_o,
    output wire        rd_wen_o
);

  // 直连信号到 RAM
  assign mem_addr_o = mem_addr_i;
  assign mem_data_o = mem_data_i;
  assign mem_size_o = mem_size_i;
  assign mem_we_o   = mem_we_i;
  assign mem_re_o   = mem_re_i;

  // 直连寄存器写回信号
  assign rd_addr_o  = rd_addr_i;
  assign rd_wen_o   = rd_wen_i;

  //------------------------ 读数据处理 ------------------------
  // 如果是 Load 操作，用 RAM 的读取数据覆盖 rd_data
  assign rd_data_o  = (mem_re_i) ? ram_data_i : rd_data_i;

endmodule
