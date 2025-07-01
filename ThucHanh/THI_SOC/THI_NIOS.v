module THI_NIOS(
	input CLOCK_50,
	input [3:0]SW,
	input [1:0]KEY,		//Dung KEY[1] bat nap
	output [6:0]HEX1,		//Dung HEX0 hien thi
	output [6:0]HEX2
);

	 system Nios_system(
		.clk_clk(CLOCK_50),
		.reset_reset_n(KEY[0]),
		.sw_in_external_connection_export(SW),
		.sw_en_external_connection_export(KEY[1]),	//Key 1 enable nap
		.hex_0_conduit_end_export(HEX1),
		.hex_1_conduit_end_export(HEX2)
	 );

endmodule