module rib (
    input wire clk,
    input wire rst,

    // master 0 interface
    input  wire [31:0] m0_addr_i,
    input  wire [31:0] m0_data_i,
    output reg  [31:0] m0_data_o,
    input  wire        m0_req_i,
    input  wire        m0_we_i,
    input  wire        m0_re_i,
    input  wire [ 2:0] m0_size_i,

    // master 1 interface
    input  wire [31:0] m1_addr_i,
    input  wire [31:0] m1_data_i,
    output reg  [31:0] m1_data_o,
    input  wire        m1_req_i,
    input  wire        m1_we_i,

    // master 2 interface
    input  wire [31:0] m2_addr_i,
    input  wire [31:0] m2_data_i,
    output reg  [31:0] m2_data_o,
    input  wire        m2_req_i,
    input  wire        m2_we_i,

    // master 3 interface
    input  wire [31:0] m3_addr_i,
    input  wire [31:0] m3_data_i,
    output reg  [31:0] m3_data_o,
    input  wire        m3_req_i,
    input  wire        m3_we_i,

    // slave 0 interface (RAM)
    output reg  [31:0] s0_addr_o,
    output reg  [31:0] s0_data_o,
    input  wire [31:0] s0_data_i,
    output reg         s0_we_o,
    output reg         s0_re_o,
    output reg  [ 2:0] s0_size_o,

    // slave 1 interface (ROM)
    output reg  [31:0] s1_addr_o,
    output reg  [31:0] s1_data_o,
    input  wire [31:0] s1_data_i,
    output reg         s1_we_o,

    // slave 2 interface
    output reg  [31:0] s2_addr_o,
    output reg  [31:0] s2_data_o,
    input  wire [31:0] s2_data_i,
    output reg         s2_we_o,

    // slave 3 interface
    output reg  [31:0] s3_addr_o,
    output reg  [31:0] s3_data_o,
    input  wire [31:0] s3_data_i,
    output reg         s3_we_o,

    // slave 4 interface
    output reg  [31:0] s4_addr_o,
    output reg  [31:0] s4_data_o,
    input  wire [31:0] s4_data_i,
    output reg         s4_we_o,

    // slave 5 interface
    output reg  [31:0] s5_addr_o,
    output reg  [31:0] s5_data_o,
    input  wire [31:0] s5_data_i,
    output reg         s5_we_o,

    output reg hold_flag_o
);

  // 访问地址的最高4位决定要访问的是哪一个从设备
  parameter [3:0] slave_0 = 4'b0000;  // RAM
  parameter [3:0] slave_1 = 4'b0001;  // ROM
  parameter [3:0] slave_2 = 4'b0010;  // Timer
  parameter [3:0] slave_3 = 4'b0011;  // UART
  parameter [3:0] slave_4 = 4'b0100;  // GPIO
  parameter [3:0] slave_5 = 4'b0101;  // SPI

  parameter [1:0] grant0 = 2'h0;
  parameter [1:0] grant1 = 2'h1;
  parameter [1:0] grant2 = 2'h2;
  parameter [1:0] grant3 = 2'h3;

  wire [3:0] req;
  reg  [1:0] grant;
  assign req = {m3_req_i, m2_req_i, m1_req_i, m0_req_i};

  // 仲裁逻辑
  always @(*) begin
    if (req[0]) begin
      grant = grant0;
      hold_flag_o = 1'b1;
    end else if (req[1]) begin
      grant = grant1;
      hold_flag_o = 1'b1;
    end else if (req[2]) begin
      grant = grant2;
      hold_flag_o = 1'b1;
    end else begin
      grant = grant3;
      hold_flag_o = 1'b0;
    end
  end

  // 根据仲裁结果，选择对应的从设备
  always @(*) begin
    m0_data_o = 32'b0;
    m1_data_o = 32'h00000001;
    m2_data_o = 32'b0;
    m3_data_o = 32'b0;
    s0_addr_o = 32'b0;
    s1_addr_o = 32'b0;
    s2_addr_o = 32'b0;
    s3_addr_o = 32'b0;
    s4_addr_o = 32'b0;
    s5_addr_o = 32'b0;
    s0_data_o = 32'b0;
    s1_data_o = 32'b0;
    s2_data_o = 32'b0;
    s3_data_o = 32'b0;
    s4_data_o = 32'b0;
    s5_data_o = 32'b0;
    s0_we_o   = 1'b0;
    s0_re_o   = 1'b0;
    s0_size_o = 3'b0;
    s1_we_o   = 1'b0;
    s2_we_o   = 1'b0;
    s3_we_o   = 1'b0;
    s4_we_o   = 1'b0;
    s5_we_o   = 1'b0;

    case (grant)
      grant0: begin
        case (m0_addr_i[31:28])
          slave_0: begin
            s0_we_o   = m0_we_i;
            s0_re_o   = m0_re_i;
            s0_size_o = m0_size_i;
            s0_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
            s0_data_o = m0_data_i;
            m0_data_o = s0_data_i;
          end
          slave_1: begin
            s1_we_o   = 1'b0;  // ROM 只读
            s1_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
            s1_data_o = m0_data_i;
            m0_data_o = s1_data_i;
          end
          slave_2: begin
            s2_we_o   = m0_we_i;
            s2_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
            s2_data_o = m0_data_i;
            m0_data_o = s2_data_i;
          end
          slave_3: begin
            s3_we_o   = m0_we_i;
            s3_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
            s3_data_o = m0_data_i;
            m0_data_o = s3_data_i;
          end
          slave_4: begin
            s4_we_o   = m0_we_i;
            s4_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
            s4_data_o = m0_data_i;
            m0_data_o = s4_data_i;
          end
          slave_5: begin
            s5_we_o   = m0_we_i;
            s5_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
            s5_data_o = m0_data_i;
            m0_data_o = s5_data_i;
          end
          default: begin
          end
        endcase
      end
      grant1: begin
        case (m1_addr_i[31:28])
          slave_0: begin
            s0_we_o   = m1_we_i;
            s0_re_o   = ~m1_we_i & m1_req_i;  // 推导读使能
            s0_size_o = 3'b010;  // 默认半字访问
            s0_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
            s0_data_o = m1_data_i;
            m1_data_o = s0_data_i;
          end
          slave_1: begin
            s1_we_o   = 1'b0;  // ROM 只读
            s1_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
            s1_data_o = m1_data_i;
            m1_data_o = s1_data_i;
          end
          slave_2: begin
            s2_we_o   = m1_we_i;
            s2_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
            s2_data_o = m1_data_i;
            m1_data_o = s2_data_i;
          end
          slave_3: begin
            s3_we_o   = m1_we_i;
            s3_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
            s3_data_o = m1_data_i;
            m1_data_o = s3_data_i;
          end
          slave_4: begin
            s4_we_o   = m1_we_i;
            s4_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
            s4_data_o = m1_data_i;
            m1_data_o = s4_data_i;
          end
          slave_5: begin
            s5_we_o   = m1_we_i;
            s5_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
            s5_data_o = m1_data_i;
            m1_data_o = s5_data_i;
          end
          default: begin
          end
        endcase
      end
      grant2: begin
        case (m2_addr_i[31:28])
          slave_0: begin
            s0_we_o   = m2_we_i;
            s0_re_o   = ~m2_we_i & m2_req_i;
            s0_size_o = 3'b010;
            s0_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
            s0_data_o = m2_data_i;
            m2_data_o = s0_data_i;
          end
          slave_1: begin
            s1_we_o   = 1'b0;  // ROM 只读
            s1_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
            s1_data_o = m2_data_i;
            m2_data_o = s1_data_i;
          end
          slave_2: begin
            s2_we_o   = m2_we_i;
            s2_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
            s2_data_o = m2_data_i;
            m2_data_o = s2_data_i;
          end
          slave_3: begin
            s3_we_o   = m2_we_i;
            s3_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
            s3_data_o = m2_data_i;
            m2_data_o = s3_data_i;
          end
          slave_4: begin
            s4_we_o   = m2_we_i;
            s4_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
            s4_data_o = m2_data_i;
            m2_data_o = s4_data_i;
          end
          slave_5: begin
            s5_we_o   = m2_we_i;
            s5_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
            s5_data_o = m2_data_i;
            m2_data_o = s5_data_i;
          end
          default: begin
          end
        endcase
      end
      grant3: begin
        case (m3_addr_i[31:28])
          slave_0: begin
            s0_we_o   = m3_we_i;
            s0_re_o   = ~m3_we_i & m3_req_i;
            s0_size_o = 3'b010;
            s0_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
            s0_data_o = m3_data_i;
            m3_data_o = s0_data_i;
          end
          slave_1: begin
            s1_we_o   = 1'b0;  // ROM 只读
            s1_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
            s1_data_o = m3_data_i;
            m3_data_o = s1_data_i;
          end
          slave_2: begin
            s2_we_o   = m3_we_i;
            s2_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
            s2_data_o = m3_data_i;
            m3_data_o = s2_data_i;
          end
          slave_3: begin
            s3_we_o   = m3_we_i;
            s3_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
            s3_data_o = m3_data_i;
            m3_data_o = s3_data_i;
          end
          slave_4: begin
            s4_we_o   = m3_we_i;
            s4_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
            s4_data_o = m3_data_i;
            m3_data_o = s4_data_i;
          end
          slave_5: begin
            s5_we_o   = m3_we_i;
            s5_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
            s5_data_o = m3_data_i;
            m3_data_o = s5_data_i;
          end
          default: begin
          end
        endcase
      end
      default: begin
      end
    endcase
  end

endmodule
