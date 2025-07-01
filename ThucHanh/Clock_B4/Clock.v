module Clock
(
	input CLOCK_50,
	input [0:0] KEY,
	input [9:0] SW,
	output [27:0] HEX
);
	system nios_system(
		.clk_clk			(CLOCK_50),
		.reset_reset_n	(KEY[0]),
		.sw_external_connection_export (SW),
		.hex_external_connection_export(HEX)
	);
endmodule
