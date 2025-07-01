module HEX_Control(
    input iClk,
    input iReset_n,
    input iChip_select_n,
    input iWrite_n,
    input [7:0] iHex_Data,			//Do yeu cau avalon la boi so cua 8
    output reg [6:0] oHex_Display
);

    always @(posedge iClk or negedge iReset_n) begin
        if (~iReset_n) begin
            oHex_Display <= 7'b1111111; // All segments off (common-anode)
        end
        else if (~iChip_select_n && ~iWrite_n) begin
            case (iHex_Data[7:0])			//Lay 6 bit thoi
				6'h0: oHex_Display = 7'b1000000; // 0
				6'h1: oHex_Display = 7'b1111001; // 1
				6'h2: oHex_Display = 7'b0100100; // 2
				6'h3: oHex_Display = 7'b0110000; // 3
				6'h4: oHex_Display = 7'b0011001; // 4
				6'h5: oHex_Display = 7'b0010010; // 5
				6'h6: oHex_Display = 7'b0000010; // 6
				6'h7: oHex_Display = 7'b1111000; // 7
				6'h8: oHex_Display = 7'b0000000; // 8
				6'h9: oHex_Display = 7'b0010000; // 9
				6'hA: oHex_Display = 7'b0001000; // A
				6'hB: oHex_Display = 7'b0000011; // b
				6'hC: oHex_Display = 7'b1000110; // C
				6'hD: oHex_Display = 7'b0100001; // d
				6'hE: oHex_Display = 7'b0000110; // E
				6'hF: oHex_Display = 7'b0001110; // F
				default: oHex_Display = 7'b1111111; // tắt hết nếu không hợp lệ
            endcase
        end
    end

endmodule