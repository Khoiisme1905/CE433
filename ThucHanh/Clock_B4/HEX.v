module HEX #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4
)(
    // Avalon-MM Slave Interface
    input  wire                        clk,
    input  wire                        reset_n,
    input  wire [ADDR_WIDTH-1:0]       avs_address,
    input  wire                        avs_read,
    input  wire                        avs_write,
    input  wire [DATA_WIDTH-1:0]       avs_writedata,
    output reg  [DATA_WIDTH-1:0]       avs_readdata,
    output wire                        avs_waitrequest,
    
    // Time Input (từ Timer component)
    input  wire [4:0]                  hours,
    input  wire [5:0]                  minutes,
    input  wire [5:0]                  seconds,
    
    // HEX Display Outputs
    output wire [6:0]                  hex0,  // Seconds units
    output wire [6:0]                  hex1,  // Seconds tens
    output wire [6:0]                  hex2,  // Minutes units
    output wire [6:0]                  hex3,  // Minutes tens
    output wire [6:0]                  hex4,  // Hours units
    output wire [6:0]                  hex5,  // Hours tens
    
    // Control
    input  wire                        display_enable,
    input  wire [1:0]                  display_mode
);

    // Register Map
    localparam ADDR_TIME_DISPLAY = 4'h0;  // Current time display
    localparam ADDR_DISPLAY_CTRL = 4'h1;  // Display control
    localparam ADDR_HEX_RAW      = 4'h2;  // Raw HEX values
    
    // Internal signals for BCD conversion
    wire [3:0] hour_tens, hour_units;
    wire [3:0] min_tens, min_units;
    wire [3:0] sec_tens, sec_units;
    
    // Convert binary to BCD
    assign hour_tens  = hours / 10;
    assign hour_units = hours % 10;
    assign min_tens   = minutes / 10;
    assign min_units  = minutes % 10;
    assign sec_tens   = seconds / 10;
    assign sec_units  = seconds % 10;
    
    // 7-segment decoder instances
    seven_segment_decoder dec0 (.bcd(sec_units),  .segments(hex0));
    seven_segment_decoder dec1 (.bcd(sec_tens),   .segments(hex1));
    seven_segment_decoder dec2 (.bcd(min_units),  .segments(hex2));
    seven_segment_decoder dec3 (.bcd(min_tens),   .segments(hex3));
    seven_segment_decoder dec4 (.bcd(hour_units), .segments(hex4));
    seven_segment_decoder dec5 (.bcd(hour_tens),  .segments(hex5));
    
    // Avalon-MM interface
    assign avs_waitrequest = 1'b0;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            avs_readdata <= 32'h0;
        end else begin
            if (avs_read) begin
                case (avs_address)
                    ADDR_TIME_DISPLAY: 
                        avs_readdata <= {11'h0, hours, 2'h0, minutes, 2'h0, seconds};
                    ADDR_DISPLAY_CTRL: 
                        avs_readdata <= {29'h0, display_mode, display_enable};
                    ADDR_HEX_RAW:
                        avs_readdata <= {8'h0, 
                                       hour_tens, hour_units,
                                       min_tens, min_units,
                                       sec_tens, sec_units};
                    default: 
                        avs_readdata <= 32'h0;
                endcase
            end
        end
    end

endmodule


/*
  7-Segment Decoder
  Chuyển đổi BCD (4-bit) thành mã 7-segment
*/
module seven_segment_decoder (
    input  wire [3:0] bcd,
    output reg  [6:0] segments
);

    always @(*) begin
        case (bcd)
            4'h0: segments = 7'b1000000;  // 0
            4'h1: segments = 7'b1111001;  // 1
            4'h2: segments = 7'b0100100;  // 2
            4'h3: segments = 7'b0110000;  // 3
            4'h4: segments = 7'b0011001;  // 4
            4'h5: segments = 7'b0010010;  // 5
            4'h6: segments = 7'b0000010;  // 6
            4'h7: segments = 7'b1111000;  // 7
            4'h8: segments = 7'b0000000;  // 8
            4'h9: segments = 7'b0010000;  // 9
            default: segments = 7'b1111111;  // Tắt
        endcase
    end

endmodule


