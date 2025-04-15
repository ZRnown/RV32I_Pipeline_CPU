module tb;
  reg            clk;  // 时钟
  reg            rst;  // 复位
  reg            rx;  // UART 输入
  wire           tx;  // UART 输出
  integer        r;

  // 访问 CPU 内部寄存器（假设寄存器模块为 u_regs）
  wire    [31:0] x3 = tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[3];
  wire    [31:0] x26 = tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[26];
  wire    [31:0] x27 = tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[27];

  // 时钟生成（周期 20ns，50MHz）
  always #10 clk = ~clk;

  // 复位和初始化
  initial begin
    clk = 1'b1;
    rst = 1'b0;
    rx  = 1'b1;  // UART 空闲状态
    #50;
    rst = 1'b0;  // 高有效复位
    #50;
    rst = 1'b1;  // 释放复位
  end

  // 加载指令到 ROM
  initial begin
    $readmemh(
        "E:\\Files\\Electron\\FPGA\\RV32I_Pipeline_CPU\\sim\\testcases\\generated\\inst_data.txt",
        tb.u_cpu_top_soc.u_rom.ROM);
  end

  // // 预存数据到 RAM
  // initial begin
  //   // 在复位期间加载数据
  //   #50;  // 等待复位开始
  //   tb.u_cpu_top_soc.u_ram.memory[32'h1000>>2] = 32'h00ff00ff;  // 0x1000
  //   tb.u_cpu_top_soc.u_ram.memory[32'h1004>>2] = 32'hff00ff00;  // 0x1004
  //   tb.u_cpu_top_soc.u_ram.memory[32'h1008>>2] = 32'h0ff00ff0;  // 0x1008
  //   tb.u_cpu_top_soc.u_ram.memory[32'h100c>>2] = 32'hf00ff00f;  // 0x100c
  //   tb.u_cpu_top_soc.u_ram.memory[32'h1020>>2] = 32'h00ff00ff;  // 0x1020
  // end

  // 测试结果判断
  initial begin
    wait (x26 == 32'b1);  // 等待测试完成标志
    #200;  // 延时观察结果
    if (x27 == 32'b1) begin
      $display("############################");
      $display("########  PASS  !!!#########");
      $display("############################");
    end else begin
      $display("############################");
      $display("########  FAIL  !!!#########");
      $display("############################");
      $display("Fail testnum = %2d", x3);
      for (r = 0; r < 32; r = r + 1) begin
        $display("x%2d register value is %d", r, tb.u_cpu_top_soc.u_cpu_top.u_regs.regs[r]);
      end
    end
    $finish();
  end

  // 实例化顶层模块
  cpu_top_soc u_cpu_top_soc (
      .clk(clk),
      .rst(rst),
      .rx (rx),
      .tx (tx)
  );

endmodule
