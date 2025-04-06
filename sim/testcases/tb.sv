module tb;
  reg                                                              clk;  // 时钟
  reg                                                              rst;  // 复位
  reg                                                              rx;  // UART 输入
  wire                                                             tx;  // UART 输出
  wire    [ 3:0]                                                   led;  // LED 输出
  integer                                                          r;

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
    $readmemh("E:\\Files\\Electron\\FPGA\\RV32I_Pipeline_CPU\\sim\\testcases\\user_test\\test.hex",
              tb.u_cpu_top_soc.u_rom.ROM);
  end
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

  // 监测 UART 输出
  reg [9:0] uart_shift;  // 10位：起始位 + 8位数据 + 停止位
  reg [3:0] bit_count;
  initial begin
    uart_shift = 10'b0;
    bit_count  = 0;
  end
  always @(posedge clk) begin
    if (tx !== 1'b1) begin
      if (bit_count == 0 && tx == 1'b0) begin  // 检测起始位
        bit_count <= bit_count + 1;
      end else if (bit_count > 0 && bit_count < 10) begin
        uart_shift[bit_count-1] <= tx;
        bit_count <= bit_count + 1;
      end else if (bit_count == 10) begin
        $display("UART TX Data: %c (ASCII %d) at time %t", uart_shift[8:1], uart_shift[8:1], $time);
        bit_count <= 0;
      end
    end
  end

  // 实例化顶层模块
  cpu_top_soc u_cpu_top_soc (
      .clk(clk),
      .rst(rst),
      .rx (rx),
      .tx (tx),
      .led(led)
  );

endmodule
