module ram (
    input  wire        clk,         // 时钟信号
    input  wire [31:0] mem_addr_i,  // 内存地址输入
    input  wire [31:0] mem_data_i,  // 写入数据输入
    input  wire        mem_we_i,    // 写使能
    input  wire        mem_re_i,    // 读使能
    input  wire [ 2:0] mem_size_i,  // 操作大小 (000: byte, 001: halfword, 010: word)
    output reg  [31:0] mem_data_o   // 读取数据输出
);

  // 定义 4KB 内存，32 位宽，地址范围 0-4095
  reg [31:0] memory[0:4095];

  // 地址解析
  wire [31:0] word_addr = mem_addr_i[31:2];  // 字地址（32 位对齐）
  wire [1:0] byte_offset = mem_addr_i[1:0];  // 字节偏移

  // 写使能信号生成
  reg [3:0] wea;
  always @(*) begin
    case (mem_size_i)
      3'b000: begin  // 字节操作 (sb)
        case (byte_offset)
          2'b00: wea = 4'b0001;
          2'b01: wea = 4'b0010;
          2'b10: wea = 4'b0100;
          2'b11: wea = 4'b1000;
        endcase
      end
      3'b001: begin  // 半字操作 (sh)
        case (byte_offset[1])
          1'b0: wea = 4'b0011;
          1'b1: wea = 4'b1100;
        endcase
      end
      3'b010:  wea = 4'b1111;  // 字操作 (sw)
      default: wea = 4'b0000;  // 默认不写入
    endcase
  end

  // 同步写
  always @(posedge clk) begin
    if (mem_we_i) begin
      case (mem_size_i)
        3'b000: begin  // 字节操作 (sb)
          if (wea[0]) memory[word_addr][7:0] <= mem_data_i[7:0];
          if (wea[1]) memory[word_addr][15:8] <= mem_data_i[7:0];
          if (wea[2]) memory[word_addr][23:16] <= mem_data_i[7:0];
          if (wea[3]) memory[word_addr][31:24] <= mem_data_i[7:0];
        end
        3'b001: begin  // 半字操作 (sh)
          if (wea[0]) memory[word_addr][7:0] <= mem_data_i[7:0];
          if (wea[1]) memory[word_addr][15:8] <= mem_data_i[15:8];
          if (wea[2]) memory[word_addr][23:16] <= mem_data_i[7:0];
          if (wea[3]) memory[word_addr][31:24] <= mem_data_i[15:8];
        end
        3'b010: begin  // 字操作 (sw)
          memory[word_addr] <= mem_data_i;
        end
        default: ;  // 无操作
      endcase
    end
  end

  // 同步读（写优先）
  always @(posedge clk) begin
    if (mem_re_i) begin
      if (mem_we_i && word_addr == mem_addr_i[31:2]) begin
        // 写优先，前递新数据
        case (mem_size_i)
          3'b000:  mem_data_o <= {{24{mem_data_i[7]}}, mem_data_i[7:0]};  // lb
          3'b001:  mem_data_o <= {{16{mem_data_i[15]}}, mem_data_i[15:0]};  // lh
          3'b010:  mem_data_o <= mem_data_i;  // lw
          3'b011:  mem_data_o <= {24'b0, mem_data_i[7:0]};  // lbu
          3'b100:  mem_data_o <= {16'b0, mem_data_i[15:0]};  // lhu
          default: mem_data_o <= 32'b0;
        endcase
      end else begin
        // 正常读取
        case (mem_size_i)
          3'b000: begin  // lb (有符号字节加载)
            case (byte_offset)
              2'b00: mem_data_o <= {{24{memory[word_addr][7]}}, memory[word_addr][7:0]};
              2'b01: mem_data_o <= {{24{memory[word_addr][15]}}, memory[word_addr][15:8]};
              2'b10: mem_data_o <= {{24{memory[word_addr][23]}}, memory[word_addr][23:16]};
              2'b11: mem_data_o <= {{24{memory[word_addr][31]}}, memory[word_addr][31:24]};
            endcase
          end
          3'b001: begin  // lh (有符号半字加载)
            case (byte_offset[1])
              1'b0: mem_data_o <= {{16{memory[word_addr][15]}}, memory[word_addr][15:0]};
              1'b1: mem_data_o <= {{16{memory[word_addr][31]}}, memory[word_addr][31:16]};
            endcase
          end
          3'b010: begin  // lw (字加载)
            mem_data_o <= memory[word_addr];
          end
          3'b011: begin  // lbu (无符号字节加载)
            case (byte_offset)
              2'b00: mem_data_o <= {24'b0, memory[word_addr][7:0]};
              2'b01: mem_data_o <= {24'b0, memory[word_addr][15:8]};
              2'b10: mem_data_o <= {24'b0, memory[word_addr][23:16]};
              2'b11: mem_data_o <= {24'b0, memory[word_addr][31:24]};
            endcase
          end
          3'b100: begin  // lhu (无符号半字加载)
            case (byte_offset[1])
              1'b0: mem_data_o <= {16'b0, memory[word_addr][15:0]};
              1'b1: mem_data_o <= {16'b0, memory[word_addr][31:16]};
            endcase
          end
          default: mem_data_o <= 32'b0;
        endcase
      end
    end
  end

endmodule
