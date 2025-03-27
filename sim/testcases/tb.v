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
    #50;
    rst <= 1'b1;
  end
  initial begin
    $readmemh(
        "E:\\Files\\Electron\\FPGA\\RV32I_Pipeline_CPU\\sim\\testcases\\inst_test\\rv32ui-p-sw.txt",
        tb.u_cpu_top_soc.u_rom.ROM);
  end
  // initial begin
  //   // Initialize data memory to match rv32ui-p-lhu
  //   tb.u_cpu_top_soc.u_ram.memory[32'h400] = 32'hff00_00ff;  // 0x1000: 0x00ff, 0x1002: 0xff00
  //   tb.u_cpu_top_soc.u_ram.memory[32'h401] = 32'hf00f_0ff0;  // 0x1004: 0x0ff0, 0x1006: 0xf00f
  // end
  initial begin
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
    $finish();
  end
  cpu_top_soc u_cpu_top_soc (
      .clk(clk),
      .rst(rst)
  );
endmodule
