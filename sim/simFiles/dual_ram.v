module dual_ram #(
    parameter DW = 32,
    parameter AW = 12,
    parameter MEM_NUM = 4096
) (
    input wire    clk   ,
    input wire    rst   ,
    input wire    w_en   ,
    input wire[AW-1:0] w_addr_i ,
    input wire[DW-1:0]  w_data_i ,
    input wire    r_en   ,
    input wire[AW-1:0] r_addr_i ,
    output wire[DW-1:0]  r_data_o
);
  wire[DW-1:0] r_data_wire ;
  reg    rd_equ_wr_flag ;
  reg[DW-1:0]  w_data_reg  ;
  assign r_data_o = rd_equ_wr_flag ? w_data_reg : r_data_wire;
  // 打一拍
  always @(posedge clk) begin
    if (!rst) w_data_reg <= 'b0;
    else w_data_reg <= w_data_i;
  end
  always @(posedge clk) begin
    if (rst && w_en && r_en && (w_addr_i == r_addr_i)) rd_equ_wr_flag <= 1'b1;
    else rd_equ_wr_flag <= 1'b0;
  end
  dual_ram_template #(
      .DW(DW),
      .AW(AW),
      .MEM_NUM(MEM_NUM)
  ) dual_ram_template_inst (
      .clk     (clk),
      .rst     (rst),
      .w_en    (w_en),
      .w_addr_i(w_addr_i),
      .w_data_i(w_data_i),
      .r_en    (r_en),
      .r_addr_i(r_addr_i),
      .r_data_o(r_data_wire)
  );
endmodule

module dual_ram_template #(
    parameter DW = 32,
    parameter AW = 12,
    parameter MEM_NUM = 4096
) (
    input wire clk,
    input wire rst,
    input wire w_en,
    input wire [AW-1:0] w_addr_i,
    input wire [DW-1:0] w_data_i,
    input wire r_en,
    input wire [AW-1:0] r_addr_i,
    output reg [DW-1:0] r_data_o
);
  reg [DW-1:0] memory[0:MEM_NUM - 1];
  always @(posedge clk) begin
    if (!rst) r_data_o <= 'b0;
    else if (rst && r_en) r_data_o <= memory[r_addr_i];
  end
  always @(posedge clk) begin
    if (rst && w_en) memory[w_addr_i] <= w_data_i;
  end
endmodule
