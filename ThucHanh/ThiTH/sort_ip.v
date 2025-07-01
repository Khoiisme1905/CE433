module sort_ip (
    input wire clk,              // Xung nhịp
    input wire rst,              // Reset
    input wire [3:0] switch,     // Giá trị 4-bit từ switch
    input wire confirm,          // Tín hiệu xác nhận
    output reg [19:0] sorted_values, // 5 giá trị 4-bit đã sắp xếp (20 bit)
    output reg done              // Tín hiệu báo hoàn thành
);

// Bộ nhớ tĩnh lưu 5 giá trị
reg [3:0] values [0:4];
reg [2:0] count; // Đếm số giá trị đã nhập (0-4)
reg [2:0] i, j;  // Biến đếm cho thuật toán sắp xếp
reg sorting;     // Trạng thái đang sắp xếp

// Trạng thái FSM
localparam IDLE = 2'b00,
           INPUT = 2'b01,
           SORT  = 2'b10,
           DONE  = 2'b11;
reg [1:0] state;

// Xử lý logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset tất cả
        count <= 0;
        state <= IDLE;
        done <= 0;
        sorting <= 0;
        for (i = 0; i < 5; i = i + 1) begin
            values[i] <= 0;
        end
        sorted_values <= 0;
    end else begin
        case (state)
            IDLE: begin
                done <= 0;
                if (confirm && count < 5) begin
                    state <= INPUT;
                end
            end
            
            INPUT: begin
                // Lưu giá trị từ switch vào bộ nhớ
                values[count] <= switch;
                count <= count + 1;
                if (count == 4) begin
                    state <= SORT;
                    sorting <= 1;
                    i <= 0;
                    j <= 0;
                end else begin
                    state <= IDLE;
                end
            end
            
            SORT: begin
                if (sorting) begin
                    // Thuật toán Bubble Sort
                    if (i < 4) begin
                        if (j < 4 - i) begin
                            if (values[j] > values[j + 1]) begin
                                // Hoán đổi
                                reg [3:0] temp;
                                temp = values[j];
                                values[j] = values[j + 1];
                                values[j + 1] = temp;
                            end
                            j <= j + 1;
                        end else begin
                            j <= 0;
                            i <= i + 1;
                        end
                    end else begin
                        sorting <= 0;
                        state <= DONE;
                        // Gán kết quả ra sorted_values
                        sorted_values <= {values[4], values[3], values[2], values[1], values[0]};
                    end
                end
            end
            
            DONE: begin
                done <= 1;
                state <= DONE; // Dừng ở trạng thái DONE
            end
        endcase
    end
end

endmodule