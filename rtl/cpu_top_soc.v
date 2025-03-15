module cpu_top_soc (
    input wire clk,
    input wire rst
);
  // cpu_top to imem
  wire [31:0] cpu_top_inst_addr_o;
  //  imem to cpu_top
  wire [31:0] cpu_top_inst_o;
  cpu_top u_cpu_top (
      .clk(clk),
      .rst(rst),
      .inst_i(cpu_top_inst_o),
      .inst_addr_o(cpu_top_inst_addr_o)
  );

  rom u_rom (
      .inst_addr_i(cpu_top_inst_addr_o),
      .inst_o(cpu_top_inst_o)
  );

endmodule
