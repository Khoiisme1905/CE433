module avalon_array_multiplier(
input iClk, 
input iReset_n,
input iChipSelect_n,
input iWrite_n,
input iRead_n,
input [1:0] iAddress,
input [31:0] iData,
output reg [31:0] oData
);

reg [31:0] A, B;
wire [31:0] Z;

array_multiplier arr_mult(
	.A(A[3:0]),
	.B(B[3:0]),
	.z(Z[7:0])
);

always @(posedge iClk or negedge iReset_n) begin
	if (~iReset_n) begin
		oData <= 32'd0;
		A <= 32'd0;
		B <= 32'd0;
	end
	else if ( ~iChipSelect_n & ~iWrite_n) begin
		case(iAddress)
			2'd0: A[3:0] <= iData[3:0];
			2'd1: B[3:0] <= iData[3:0];
		endcase
	end
	else if (~iChipSelect_n & ~iRead_n) begin
		case(iAddress)
			2'd0: oData <= A;
			2'd1: oData <= B;
			2'd2: oData <= Z;
		endcase
	end
end

endmodule