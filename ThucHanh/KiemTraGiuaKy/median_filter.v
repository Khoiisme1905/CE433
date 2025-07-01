module median_filter (
    input [7:0] Datain,
    input Clk,
    input reset,
    input Enable,
    output reg [7:0] Dataout
);
    // Declare registers to store 5 input values
    reg [7:0] data_buffer [0:4];
    
    // Temporary variables for sorting
    reg [7:0] sorted_data [0:4];
    integer i, j;
    reg [7:0] temp;

    // Main sequential logic
    always @(posedge Clk or posedge reset) begin
        if (reset) begin
            // Reset all stored values
            for (i = 0; i < 5; i = i + 1) begin
                data_buffer[i] <= 8'b0;
            end
            Dataout <= 8'b0;
        end
        else if (Enable) begin
            // Shift buffer and add new input
            for (i = 4; i > 0; i = i - 1) begin
                data_buffer[i] <= data_buffer[i-1];
            end
            data_buffer[0] <= Datain;

            // Copy data to sorted array
            for (i = 0; i < 5; i = i + 1) begin
                sorted_data[i] <= data_buffer[i];
            end

            // Bubble sort to find median
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4 - i; j = j + 1) begin
                    if (sorted_data[j] > sorted_data[j+1]) begin
                        // Swap
                        temp = sorted_data[j];
                        sorted_data[j] = sorted_data[j+1];
                        sorted_data[j+1] = temp;
                    end
                end
            end

            // Output the median (middle value)
            Dataout <= sorted_data[2];
        end
    end
endmodule