module HEX_Control(
    input iClk,
    input iReset_n,
    input iChip_select_n,
    input iWrite_n,
	 input [1:0]iAddress,
    input [7:0] iHex_Data,			//Do yeu cau avalon la boi so cua 8
    output reg [7:0] oHex_Display
);
	reg [7:0] temp_hex;
	reg [7:0]temp_in;
	always @(*) begin 
		 case (temp_in[3:0])			//Lay 4 bit thoi
				4'h0: temp_hex = 8'b01000000; // 0
				4'h1: temp_hex = 8'b01111001; // 1
				4'h2: temp_hex = 8'b00100100; // 2
				4'h3: temp_hex = 8'b00110000; // 3
				4'h4: temp_hex = 8'b00011001; // 4
				4'h5: temp_hex = 8'b00010010; // 5
				4'h6: temp_hex = 8'b00000010; // 6
				4'h7: temp_hex = 8'b01111000; // 7
				4'h8: temp_hex = 8'b00000000; // 8
				4'h9: temp_hex = 8'b00010000; // 9
				4'hA: temp_hex = 8'b00001000; // A
				4'hB: temp_hex = 8'b00000011; // b
				4'hC: temp_hex = 8'b01000110; // C
				4'hD: temp_hex = 8'b00100001; // d
				4'hE: temp_hex = 8'b00000110; // E
				4'hF: temp_hex = 8'b00001110; // F
				default: temp_hex = 8'b01111111; // tắt hết nếu không hợp lệ
            endcase
	end
    always @(posedge iClk or negedge iReset_n) begin
        if (~iReset_n) begin
            oHex_Display <= 8'b01111111; // All segments off (common-anode)
        end
        else begin 
			if (~iChip_select_n && ~iWrite_n) begin
				if(iAddress == 2'd0) temp_in <= iHex_Data;
			end
			else if (!iChip_select_n) begin 
				if(iAddress == 2'd1) oHex_Display<= temp_hex;
			end
			end
    end

endmodule