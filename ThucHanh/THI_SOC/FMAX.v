module FMAX(
	input [19:0]Val,
	output reg [7:0]Val_Max
);

	wire [3:0]V1, V2, V3, V4, V5;
	
	assign V1 = Val[19:16];
	assign V2 = Val[15:12];
	assign V3 = Val[11:8];
	assign V4 = Val[7:4];
	assign V5 = Val[3:0];
	
	always@(*)begin
		Val_Max = V1 + V2 + V3 + V4 + V5;
	end
endmodule