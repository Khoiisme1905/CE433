module Bai5_Test 
(  
    input  CLOCK_50,
    output lcd_on_export,
    output lcd_blon_export,
    output lcd_en_export,
    output lcd_rw_export,
    output lcd_rs_export,
    output [7:0] lcd_d_export,
    input  [7:0] switch_export,
	 input  [0:0] KEY
);   
 
    system NIOS_system 
    ( 
        .clk_clk(CLOCK_50), 
        .lcd_on_export(lcd_on_export),
        .lcd_blon_export(lcd_blon_export),
        .lcd_en_export(lcd_en_export),
        .lcd_rw_export(lcd_rw_export),
        .lcd_rs_export(lcd_rs_export),
        .lcd_d_export(lcd_d_export),
        .switch_export(switch_export),
		  .reset_reset_n(KEY[0])
    ); 
endmodule
module Bai5_Test 
(  
	input  CLOCK_50,
	input [0:0] KEY,
	output LCD_EN,
	output LCD_RS,
	output LCD_RW,
	output LCD_ON,
	output LCD_BLON,
	output [7:0] LCD_DATA
);   
 
 
	system NIOS_system 
	( 
		.clk_clk(CLOCK_50), 
		.reset_reset_n(KEY[0]),
		.lcd_on_export		(LCD_ON),
		.lcd_blon_export	(LCD_BLON),
		.lcd_rs_export		(LCD_RS),
		.lcd_en_export		(LCD_EN),
		.lcd_rw_export		(LCD_RW),
		.lcd_d_export		({8'd0,LCD_DATA})
	); 
endmodule