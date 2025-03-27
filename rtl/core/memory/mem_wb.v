module mem_wb (
    input  wire        clk,
    input  wire        rst,
    // from mem
    input  wire [ 4:0] rd_addr_i,
    input  wire [31:0] rd_data_i,
    input  wire        rd_wen_i,
    input  wire        mem_re_i,
    input  wire [31:0] ram_data_i,
    // to wb
    output wire [ 4:0] rd_addr_o,
    output wire [31:0] rd_data_o,
    output wire        rd_wen_o,
    output wire        mem_re_o,
    output wire [31:0] ram_data_o
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
  dff_set #(32) dff5 (
      clk,
      rst,
      32'b0,
      ram_data_i,
      ram_data_o
  );
endmodule
