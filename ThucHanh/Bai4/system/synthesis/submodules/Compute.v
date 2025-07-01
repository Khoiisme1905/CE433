module Compute(
	input iClk,
	input iReset_n,
	input iChipSelect_n,
	input iWrite_n,
	input iRead_n,
	input [1:0] iAddress,
	input [31:0] iData,
	output reg [31:0] oData
);
Tinhtoan Tinhtoan_y(
	.a(a), 
	.b(b), 
	.x(x), 
	.y(y)
);


reg [31:0] a, b, x;
		always@(posedge iClk, negedge iReset_n)
		begin
			if(~iReset_n)
			begin
				oData <= 32'd0;
				a <= 32'd0;
				b <= 32'd0;
				x <= 32'd0;
			end
			else
			begin
			if (~iChipSelect_n & ~iWrite_n)
			begin
			case (iAddress)
				2'd0: a[3:0] <= iData[3:0];
				2'd1: b[3:0] <= iData[3:0];
				2'd2: x[3:0] <= iData[3:0];
			endcase
			end
			if (~iChipSelect_n & ~iRead_n)
			begin
			case (iAddress)
				2'd0: oData <= a;
				2'd1: oData <= b;
				2'd2: oData <= x;
				// 2'd3: oData <= a*x + b;
			endcase
			end
			end
			end
			endmodule