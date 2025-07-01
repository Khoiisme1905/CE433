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
            case (iHex_Data[3:0])			//Lay 4 bit thoi
				4'h0: oHex_Display = 7'b1000000; // 0
				4'h1: oHex_Display = 7'b1111001; // 1
				4'h2: oHex_Display = 7'b0100100; // 2
				4'h3: oHex_Display = 7'b0110000; // 3
				4'h4: oHex_Display = 7'b0011001; // 4
				4'h5: oHex_Display = 7'b0010010; // 5
				4'h6: oHex_Display = 7'b0000010; // 6
				4'h7: oHex_Display = 7'b1111000; // 7
				4'h8: oHex_Display = 7'b0000000; // 8
				4'h9: oHex_Display = 7'b0010000; // 9
				4'hA: oHex_Display = 7'b0001000; // A
				4'hB: oHex_Display = 7'b0000011; // b
				4'hC: oHex_Display = 7'b1000110; // C
				4'hD: oHex_Display = 7'b0100001; // d
				4'hE: oHex_Display = 7'b0000110; // E
				4'hF: oHex_Display = 7'b0001110; // F
				default: oHex_Display = 7'b1111111; // tắt hết nếu không hợp lệ
            endcase
        end
    end

endmodule