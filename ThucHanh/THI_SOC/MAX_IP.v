module MAX_IP(
	input iClk,
	input iReset_n,
	input iChipselect_n,
	input iWrite_n,
	input iRead_n,
	input [1:0]iAddress,
	input [31:0]iData,
	output reg [31:0]oData
);

	reg [31:0]D_I;
	wire [31:0]D_O;
	//Goi module
	FMAX FindMax(D_I[19:0], D_O[6:0]);
	
	always@(posedge iClk, negedge iReset_n)begin
		if(~iReset_n)begin
			oData <= 32'd0;
		end
		else begin
			if(~iChipselect_n & ~iRead_n)begin
				case(iAddress)
					2'd0: oData <= {12'd0, D_I[19:0]};
					2'd1: oData <= {25'd0, D_O[6:0]};
				endcase
			end
			if(~iChipselect_n & ~iWrite_n)begin
				case(iAddress)
					2'd0: D_I <= iData;		//Chi duoc ghi vao buff0
				endcase
			end
		end
	end

endmodule