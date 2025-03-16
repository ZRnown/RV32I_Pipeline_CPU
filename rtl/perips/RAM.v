module ram (
    input  wire        clk,
    input  wire [31:0] mem_addr_i,  // 字节地址
    input  wire [31:0] mem_data_i,  // 写入数据
    input  wire        mem_we_i,    // 写使能
    input  wire        mem_re_i,    // 读使能
    input  wire [ 2:0] mem_size_i,  // 操作类型：LB=0, LH=1, LW=2, LBU=3, LHU=4
    output reg  [31:0] mem_data_o   // 读取数据（符号/零扩展后的 32 位）
);

  // 内存按 32 位字存储，每个字包含 4 字节（小端模式）
  reg [31:0] memory[0:4095];  // 4096 个 32 位字（16KB）

  // 计算字地址和字节偏移
  wire [31:0] word_addr = mem_addr_i[31:2];  // 高 30 位为字地址
  wire [1:0] byte_offset = mem_addr_i[1:0];  // 低 2 位为字节偏移

  //------------------------ 写操作逻辑 ------------------------
  reg [3:0] wea;  // 字节写使能（4 位，对应 32 位字的 4 字节）
  always @(*) begin
    case (mem_size_i)
      3'b000: begin  // SB：写 1 字节
        case (byte_offset)
          2'b00: wea = 4'b0001;
          2'b01: wea = 4'b0010;
          2'b10: wea = 4'b0100;
          2'b11: wea = 4'b1000;
        endcase
      end
      3'b001: begin  // SH：写 2 字节（小端对齐）
        case (byte_offset[1])
          1'b0: wea = 4'b0011;  // 低 2 字节
          1'b1: wea = 4'b1100;  // 高 2 字节
        endcase
      end
      3'b010:  wea = 4'b1111;  // SW：写 4 字节
      default: wea = 4'b0000;  // 默认不写
    endcase
  end

  // 同步写入（按字节使能更新）
  always @(posedge clk) begin
    if (mem_we_i) begin
      if (wea[0]) memory[word_addr][7:0] <= mem_data_i[7:0];
      if (wea[1]) memory[word_addr][15:8] <= mem_data_i[15:8];
      if (wea[2]) memory[word_addr][23:16] <= mem_data_i[23:16];
      if (wea[3]) memory[word_addr][31:24] <= mem_data_i[31:24];
    end
  end

  //------------------------ 读操作逻辑 ------------------------
  // 同步读取（符号/零扩展）
  always @(posedge clk) begin
    if (mem_re_i) begin
      case (mem_size_i)
        3'b000: begin  // LB：符号扩展 1 字节
          case (byte_offset)
            2'b00: mem_data_o <= {{24{memory[word_addr][7]}}, memory[word_addr][7:0]};
            2'b01: mem_data_o <= {{24{memory[word_addr][15]}}, memory[word_addr][15:8]};
            2'b10: mem_data_o <= {{24{memory[word_addr][23]}}, memory[word_addr][23:16]};
            2'b11: mem_data_o <= {{24{memory[word_addr][31]}}, memory[word_addr][31:24]};
          endcase
        end
        3'b001: begin  // LH：符号扩展 2 字节
          case (byte_offset[1])
            1'b0: mem_data_o <= {{16{memory[word_addr][15]}}, memory[word_addr][15:0]};
            1'b1: mem_data_o <= {{16{memory[word_addr][31]}}, memory[word_addr][31:16]};
          endcase
        end
        3'b010:  mem_data_o <= memory[word_addr];  // LW：直接读取
        3'b011: begin  // LBU：零扩展 1 字节
          case (byte_offset)
            2'b00: mem_data_o <= {24'b0, memory[word_addr][7:0]};
            2'b01: mem_data_o <= {24'b0, memory[word_addr][15:8]};
            2'b10: mem_data_o <= {24'b0, memory[word_addr][23:16]};
            2'b11: mem_data_o <= {24'b0, memory[word_addr][31:24]};
          endcase
        end
        3'b100: begin  // LHU：零扩展 2 字节
          case (byte_offset[1])
            1'b0: mem_data_o <= {16'b0, memory[word_addr][15:0]};
            1'b1: mem_data_o <= {16'b0, memory[word_addr][31:16]};
          endcase
        end
        default: mem_data_o <= 32'b0;
      endcase
    end
  end

endmodule
