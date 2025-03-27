module ex_mem (
    input  wire        clk,
    input  wire        rst,
    // from ex
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire        mem_re_i,   // 内存读使能（1: Load）
    // to mem
    output wire [ 4:0] rd_addr_o,
    output wire [31:0] rd_data_o,
    output wire        rd_wen_o,
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
  dff_set #(1) dff4 (
      clk,
      rst,
      1'b0,
      mem_re_i,
      mem_re_o
  );

endmodule
