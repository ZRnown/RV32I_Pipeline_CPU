module ALU (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [ 3:0] op,
    output reg  [31:0] S
);
  always @(*) begin
    case (op)
      4'b0000: S = A + B;
      4'b0001: S = A - B;
      4'b0010: S = A & B;
      4'b0011: S = A | B;
      4'b0100: S = A ^ B;
      4'b0101: S = A << B[4:0];
      4'b0110: S = A >> B[4:0];
      4'b0111: S = $signed(A) >>> B[4:0];
      4'b1000: S = ($signed(A) < $signed(B)) ? 1 : 0;
      4'b1001: S = (A < B) ? 1 : 0;
      default: S = 32'b0;
    endcase
  end

endmodule
