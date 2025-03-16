module tb;
  reg clk;
  reg rst;

  wire x3 = tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[3];
  wire x26 = tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[26];
  wire x27 = tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[27];
  integer r;
  always #10 clk = ~clk;
  initial begin
    clk <= 1'b1;
    rst <= 1'b0;
    #30;
    rst <= 1'b1;
  end
  initial begin
    $readmemh(
        "E:\\Files\\Electron\\FPGA\\RV32I_Pipeline_CPU\\sim\\testcases\\inst_test\\rv32ui-p-beq.txt",
        tb.u_cpu_top_soc.u_rom.ROM);
  end
  initial begin
    // while (1) begin
    //   @(posedge clk)
    //     $display(
    //         "x27 register value is %d", tb.cpu_top_soc_inst.cpu_top_inst.regs_inst.regs[27]
    //     );
    //   $display("x28 register value is %d", tb.cpu_top_soc_inst.cpu_top_inst.regs_inst.regs[28]);
    //   $display("x29 register value is %d", tb.cpu_top_soc_inst.cpu_top_inst.regs_inst.regs[29]);
    //   $display("------------------------");
    // end
    wait (x26 == 32'b1);
    #200;
    if (x27 == 32'b1) begin
      $display("############################");
      $display("########  pass  !!!#########");
      $display("############################");
    end else begin
      $display("############################");
      $display("########  fail  !!!#########");
      $display("############################");
      $display("fail testnum = %2d", x3);
      for (r = 0; r < 31; r = r + 1) begin
        $display("x%2d register value is %d", r, tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[r]);
      end
    end
  end
  cpu_top_soc u_cpu_top_soc (
      .clk(clk),
      .rst(rst)
  );
endmodule
