module Bai2
(
	input CLOCK_50,
	input [0:0] KEY,
	input [15:0] SW,
	output [15:0] LEDR,
	output [6:0] HEX0
);
	system nios_system(
		.clk_clk			(CLOCK_50),
		.reset_reset_n	(KEY[0]),
		.switch_external_connection_export ({16'd0, SW}),
		.led_external_connection_export		({16'd0,LEDR}),
		.hex0_external_connection_export(HEX0)
	);
endmodule
