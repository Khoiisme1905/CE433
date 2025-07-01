module ThiTH
(
	input CLOCK_50,
	input [0:0] KEY,
	output LCD_ON,
	output LCD_BLON,
	output LCD_EN,
	output LCD_RW,
	output LCD_RS,
	output [19:0] LCD_DATA,
	input [4:0] SWITCH
);
system NIOS_system
(
.clk_clk(CLOCK_50),
.reset_reset_n(KEY[0]),
.lcd_data_external_connection_export(LCD_DATA),	
.lcd_rs_external_connection_export(LCD_RS),
.lcd_rw_external_connection_export(LCD_RW),
.lcd_en_external_connection_export(LCD_EN),	
.lcd_blon_external_connection_export(LCD_BLON),	
.lcd_on_external_connection_export(LCD_ON),
.sw_external_connection_export(SWITCH)
);
endmodule 
