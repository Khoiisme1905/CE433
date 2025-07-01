module Tinhtoan(
	input [31:0] a, b, x,
	output [31:0] y
);
assign y = a*x + b;
endmodule