module uart_tb;
  // 时钟和复位信号
  reg clk;
  reg rst;

  // UART 引脚
  reg rx;
  wire tx;

  // AXI4-Lite 信号
  reg [31:0] s_awaddr;
  reg [2:0] s_awprot;
  reg s_awvalid;
  wire s_awready;
  reg [31:0] s_wdata;
  reg [3:0] s_wstrb;
  reg s_wvalid;
  wire s_wready;
  wire [1:0] s_bresp;
  wire s_bvalid;
  reg s_bready;
  reg [31:0] s_araddr;
  reg [2:0] s_arprot;
  reg s_arvalid;
  wire s_arready;
  wire [31:0] s_rdata;
  wire [1:0] s_rresp;
  wire s_rvalid;
  reg s_rready;

  // UART 寄存器地址
  localparam UART_STAT_REG = 32'h0000_0000;  // 状态寄存器
  localparam UART_DATA_REG = 32'h0000_0004;  // 数据寄存器
  localparam UART_BAUD_REG = 32'h0000_0008;  // 波特率寄存器

  // 波特率相关参数（用于测试）
  localparam CLK_FREQ = 100_000_000;  // 100MHz
  localparam BAUD_RATE = 115200;
  localparam BIT_TIME = CLK_FREQ / BAUD_RATE;  // 一个比特的时钟周期数

  // 实例化UART模块
  uart dut (
      .clk(clk),
      .rst(rst),
      .s_awaddr(s_awaddr),
      .s_awprot(s_awprot),
      .s_awvalid(s_awvalid),
      .s_awready(s_awready),
      .s_wdata(s_wdata),
      .s_wstrb(s_wstrb),
      .s_wvalid(s_wvalid),
      .s_wready(s_wready),
      .s_bresp(s_bresp),
      .s_bvalid(s_bvalid),
      .s_bready(s_bready),
      .s_araddr(s_araddr),
      .s_arprot(s_arprot),
      .s_arvalid(s_arvalid),
      .s_arready(s_arready),
      .s_rdata(s_rdata),
      .s_rresp(s_rresp),
      .s_rvalid(s_rvalid),
      .s_rready(s_rready),
      .rx(rx),
      .tx(tx)
  );

  // 时钟生成
  always #5 clk = ~clk;  // 100MHz时钟

  // 任务：AXI4-Lite写操作
  task axi_write;
    input [31:0] addr;
    input [31:0] data;
    begin
      // 写地址通道
      s_awaddr  = addr;
      s_awprot  = 3'b000;
      s_awvalid = 1'b1;
      s_wdata   = data;
      s_wstrb   = 4'b1111;
      s_wvalid  = 1'b1;
      s_bready  = 1'b1;

      // 等待地址和数据握手完成
      wait (s_awready && s_wready);
      @(posedge clk);
      s_awvalid = 1'b0;
      s_wvalid  = 1'b0;

      // 等待写响应
      wait (s_bvalid);
      @(posedge clk);
      s_bready = 1'b0;

      // 延迟一个周期
      @(posedge clk);
    end
  endtask

  // 任务：AXI4-Lite读操作
  task axi_read;
    input [31:0] addr;
    output [31:0] data;
    begin
      // 读地址通道
      s_araddr  = addr;
      s_arprot  = 3'b000;
      s_arvalid = 1'b1;
      s_rready  = 1'b1;

      // 等待地址握手完成
      wait (s_arready);
      @(posedge clk);
      s_arvalid = 1'b0;

      // 等待读数据
      wait (s_rvalid);
      data = s_rdata;
      @(posedge clk);
      s_rready = 1'b0;

      // 延迟一个周期
      @(posedge clk);
    end
  endtask

  // 任务：模拟UART接收（向DUT的RX引脚发送数据）
  task uart_send;
    input [7:0] data;
    integer i;
    begin
      // 起始位（低电平）
      rx = 1'b0;
      repeat (BIT_TIME) @(posedge clk);

      // 数据位（LSB优先）
      for (i = 0; i < 8; i = i + 1) begin
        rx = data[i];
        repeat (BIT_TIME) @(posedge clk);
      end

      // 停止位（高电平）
      rx = 1'b1;
      repeat (BIT_TIME) @(posedge clk);

      // 额外延迟
      repeat (BIT_TIME / 2) @(posedge clk);
    end
  endtask

  // 任务：监测UART发送（从DUT的TX引脚接收数据）
  task uart_receive;
    output [7:0] data;
    integer i;
    begin
      // 等待起始位（低电平）
      wait (tx == 1'b0);
      repeat (BIT_TIME / 2) @(posedge clk);  // 移动到起始位中间
      repeat (BIT_TIME) @(posedge clk);  // 跳过起始位剩余部分

      // 数据位（LSB优先）
      for (i = 0; i < 8; i = i + 1) begin
        repeat (BIT_TIME) @(posedge clk);
        data[i] = tx;
      end

      // 等待停止位（高电平）
      repeat (BIT_TIME) @(posedge clk);

      // 验证停止位
      if (tx != 1'b1) begin
        $display("错误：停止位不是高电平！");
      end
    end
  endtask

  // 测试过程
  initial begin
    // 初始化信号
    clk = 0;
    rst = 0;
    rx = 1;
    s_awvalid = 0;
    s_wvalid = 0;
    s_bready = 0;
    s_arvalid = 0;
    s_rready = 0;

    // 复位
    #20 rst = 1;
    #20;

    // 测试1：配置波特率
    $display("测试1：配置波特率");
    axi_write(UART_BAUD_REG, BIT_TIME);

    // 测试2：发送数据
    $display("测试2：通过AXI发送数据");
    axi_write(UART_DATA_REG, 8'h55);  // 写入数据
    axi_write(UART_STAT_REG, 1);  // 触发发送

    // 等待发送完成
    #(BIT_TIME * 12);

    // 测试3：接收数据
    $display("测试3：接收UART数据");
    uart_send(8'hAA);  // 发送数据到UART

    // 等待接收完成
    #(BIT_TIME * 12);

    // 读取接收到的数据
    begin
      reg [31:0] read_data;
      axi_read(UART_STAT_REG, read_data);
      $display("UART状态: %h", read_data);

      if (read_data[0]) begin
        axi_read(UART_DATA_REG, read_data);
        $display("接收到的数据: %h", read_data[7:0]);

        if (read_data[7:0] == 8'hAA) begin
          $display("测试通过：接收到的数据正确");
        end else begin
          $display("测试失败：接收到的数据错误");
        end
      end else begin
        $display("测试失败：未接收到数据");
      end
    end

    // 测试4：回环测试
    $display("测试4：UART回环测试");
    begin
      reg [7:0] test_data = 8'h5A;
      reg [7:0] received_data;

      // 发送数据
      axi_write(UART_DATA_REG, test_data);
      axi_write(UART_STAT_REG, 1);

      // 接收数据
      uart_receive(received_data);

      // 验证
      if (received_data == test_data) begin
        $display("回环测试通过：发送 %h，接收 %h", test_data, received_data);
      end else begin
        $display("回环测试失败：发送 %h，接收 %h", test_data, received_data);
      end
    end

    // 完成测试
    #100;
    $display("所有测试完成");
    $finish;
  end

  // 波形输出
  initial begin
    $dumpfile("uart_test.vcd");
    $dumpvars(0, uart_tb);
  end

endmodule
