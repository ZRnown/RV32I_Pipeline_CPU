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
              tb.cpu_top_soc_inst.imem_inst.ROM);
  end
  initial begin
    while (1) begin
      @(posedge clk)
        $display(
            "x27 register value is %d", tb.cpu_top_soc_inst.cpu_top_inst.regs_inst.regs[27]
        );
      $display("x28 register value is %d", tb.cpu_top_soc_inst.cpu_top_inst.regs_inst.regs[28]);
      $display("x29 register value is %d", tb.cpu_top_soc_inst.cpu_top_inst.regs_inst.regs[29]);
      $display("------------------------");
    end
  end
  cpu_top_soc cpu_top_soc_inst (
      .clk(clk),
      .rst(rst)
  );
endmodule
