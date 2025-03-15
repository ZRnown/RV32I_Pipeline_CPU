module tb;
  reg clk;
  reg rst;
  always #10 clk = ~clk;
  initial begin
    clk <= 1'b1;
    rst <= 1'b0;
    #30;
    rst <= 1'b1;
  end
  initial begin
    $readmemb("E:\\Files\\Electron\\FPGA\\RV32I_Pipeline_CPU\\sim\\testcases\\inst_data_ADD.txt",
              tb.u_cpu_top_soc.u_rom.ROM);
  end
  initial begin
    while (1) begin
      @(posedge clk)
        $display(
            "x27 register value is %d", tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[27]
        );
      $display("x28 register value is %d", tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[28]);
      $display("x29 register value is %d", tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[29]);
      $display("------------------------", tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[29]);
    end
  end
  cpu_top_soc u_cpu_top_soc (
      .clk(clk),
      .rst(rst)
  );
endmodule
