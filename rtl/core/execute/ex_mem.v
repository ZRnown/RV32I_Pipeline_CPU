module ex_mem (
    input  wire        clk,
    input  wire        rst,
    // from ex
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire [31:0] mem_addr_i,  // 访存地址（如 LW/SW 的地址）
    input  wire [31:0] mem_data_i,  // 写入内存的数据（SW 指令）
    input  wire [ 2:0] mem_size_i,
    input  wire        mem_we_i,    // 内存写使能（1: Store, 0: Load 或其他）
    input  wire        mem_re_i,    // 内存读使能（1: Load）
    // to mem
    output wire [ 4:0] rd_addr_o,
    output wire [31:0] rd_data_o,
    output wire        rd_wen_o,
    output wire [31:0] mem_addr_o,  // 访存地址（如 LW/SW 的地址）
    output wire [31:0] mem_data_o,  // 写入内存的数据（SW 指令）
    output wire [ 2:0] mem_size_o,
    output wire        mem_we_o,
    output wire        mem_re_o
);
  dff_set #(5) dff1 (
      clk,
      rst,
      5'b0,
      rd_addr_i,
      rd_addr_o
  );
  dff_set #(32) dff2 (
      clk,
      rst,
      32'b0,
      rd_data_i,
      rd_data_o
  );
  dff_set #(1) dff3 (
      clk,
      rst,
      1'b0,
      rd_wen_i,
      rd_wen_o
  );
  dff_set #(32) dff4 (
      clk,
      rst,
      32'b0,
      mem_addr_i,
      mem_addr_o
  );
  dff_set #(32) dff5 (
      clk,
      rst,
      32'b0,
      mem_data_i,
      mem_data_o
  );
  dff_set #(1) dff6 (
      clk,
      rst,
      1'b0,
      mem_we_i,
      mem_we_o
  );
  dff_set #(1) dff7 (
      clk,
      rst,
      1'b0,
      mem_re_i,
      mem_re_o
  );
  dff_set #(3) dff8 (
      clk,
      rst,
      3'b0,
      mem_size_i,
      mem_size_o
  );
endmodule
