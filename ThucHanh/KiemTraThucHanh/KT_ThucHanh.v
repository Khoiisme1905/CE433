module KT_ThucHanh
(
	input CLOCK_50,
	input [0:0] KEY,
	output LCD_ON,
	output LCD_BLON,
	output LCD_EN,
	output LCD_RW,
	output LCD_RS,
	output [7:0] LCD_DATA
);
system NIOS_system
(
.clk_clk(CLOCK_50),
.reset_reset_n(KEY[0]),
.lcd_data_external_connection_export({7'd0, LCD_DATA}),	
.lcd_rs_external_connection_export(LCD_RS),
.lcd_rw_external_connection_export(LCD_RW),
.lcd_en_external_connection_export(LCD_EN),	
.lcd_blon_external_connection_export(LCD_BLON),	
.lcd_on_external_connection_export(LCD_ON),
);
endmodule 
