/*
  Switch Controller Module
  Xử lý logic điều khiển từ switches
  Kết nối với Avalon Bus trong Qsys
*/

module switches #(
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
    
    // External Switch Inputs
    input  wire [9:0]                  switches,
    
    // Control Outputs
    output reg                         clock_enable,
    output reg                         set_mode,
    output reg [4:0]                   set_hour,
    output reg [5:0]                   set_minute,
    output reg [5:0]                   set_second,
    output reg                         reset_clock,
    
    // Status Output
    output reg [9:0]                   status_leds
);

    // Register Map
    localparam ADDR_SWITCH_VALUE = 4'h0;  // Read switch values
    localparam ADDR_CONTROL      = 4'h1;  // Control register
    localparam ADDR_TIME_SET     = 4'h2;  // Time setting register
    localparam ADDR_STATUS       = 4'h3;  // Status register
    
    // Internal registers
    reg [DATA_WIDTH-1:0] control_reg;
    reg [DATA_WIDTH-1:0] time_set_reg;
    reg [DATA_WIDTH-1:0] status_reg;
    
    // Switch processing
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            clock_enable <= 1'b1;    // Default: clock running
            set_mode     <= 1'b0;
            set_hour     <= 5'h0;
            set_minute   <= 6'h0;
            set_second   <= 6'h0;
            reset_clock  <= 1'b0;
            status_leds  <= 10'h0;
            control_reg  <= 32'h0;
            time_set_reg <= 32'h0;
            status_reg   <= 32'h0;
        end else begin
            // Switch mapping
            clock_enable <= switches[0];           // SW0: Enable/Disable clock
            set_mode     <= switches[1];           // SW1: Time setting mode
            reset_clock  <= switches[2];           // SW2: Reset clock
            
            // Time setting from switches when in set mode
            if (switches[1]) begin  // Set mode active
                set_hour   <= switches[7:3];       // SW7-SW3: Hour (0-23)
                set_minute <= switches[9:8] * 10 + switches[7:4]; // Minutes from switches
                set_second <= 6'h0;                // Reset seconds when setting
            end
            
            // Status LEDs
            status_leds[0] <= clock_enable;
            status_leds[1] <= set_mode;
            status_leds[2] <= reset_clock;
            status_leds[9:3] <= 7'h0;
            
            // Update status register
            status_reg <= {22'h0, switches};
        end
    end
    
    // Avalon-MM interface
    assign avs_waitrequest = 1'b0;  // Always ready
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            avs_readdata <= 32'h0;
        end else begin
            if (avs_read) begin
                case (avs_address)
                    ADDR_SWITCH_VALUE: avs_readdata <= {22'h0, switches};
                    ADDR_CONTROL:      avs_readdata <= {26'h0, reset_clock, set_mode, clock_enable, 3'h0};
                    ADDR_TIME_SET:     avs_readdata <= {21'h0, set_hour, set_minute};
                    ADDR_STATUS:       avs_readdata <= {22'h0, status_leds};
                    default:           avs_readdata <= 32'h0;
                endcase
            end
            
            if (avs_write) begin
                case (avs_address)
                    ADDR_CONTROL: begin
                        clock_enable <= avs_writedata[0];
                        set_mode     <= avs_writedata[1];
                        reset_clock  <= avs_writedata[2];
                    end
                    ADDR_TIME_SET: begin
                        set_hour   <= avs_writedata[10:6];
                        set_minute <= avs_writedata[5:0];
                    end
                endcase
            end
        end
    end

endmodule
