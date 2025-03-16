module ram (
    input  wire        clk,
    input  wire [31:0] mem_addr_i,
    input  wire [31:0] mem_data_i,
    input  wire        mem_we_i,
    input  wire        mem_re_i,
    output reg  [31:0] mem_data_o   // 读取的内存数据（新增输出）
);
endmodule
