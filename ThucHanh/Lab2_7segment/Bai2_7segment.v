module Bai2_7segment(
    input CLOCK_50,
    input [0:0] KEY,
    input [15:0] SW,
    output [15:0] LEDR,
    output [6:0] HEX0
);
    wire [31:0] led_export;
    assign LEDR = led_export[15:0];

    system nios_system(
        .clk_clk(CLOCK_50),
        .reset_reset_n(KEY[0]),
        .led_external_connection_export(led_export),
        .hex0_external_connection_export(HEX0),
        .switch_external_connection_export(SW)
    );
endmodule