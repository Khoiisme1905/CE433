module Sort5 #(
    parameter DATA_WIDTH = 32
)(
    input iClk,
    input iReset_n,
    input iChipSelect_n,
    input iRead_n,
    input iWrite_n,
    input [3:0] iAddress,              // 3 bits đủ cho 0–9
    input [DATA_WIDTH-1:0] iData,
    output reg [DATA_WIDTH-1:0] oData
);

    reg [DATA_WIDTH-1:0] in0, in1, in2, in3, in4;
    reg [DATA_WIDTH-1:0] sorted0, sorted1, sorted2, sorted3, sorted4;
    reg start;

    always @(posedge iClk or negedge iReset_n) begin
        if (!iReset_n) begin
            in0 <= 0; in1 <= 0; in2 <= 0; in3 <= 0; in4 <= 0;
            sorted0 <= 0; sorted1 <= 0; sorted2 <= 0; sorted3 <= 0; sorted4 <= 0;
            start <= 0;
        end else begin
            if (!iChipSelect_n && !iWrite_n) begin
                case (iAddress)
                    4'd0: in0 <= iData;
                    4'd1: in1 <= iData;
                    4'd2: in2 <= iData;
                    4'd3: in3 <= iData;
                    4'd4: in4 <= iData;
                    4'd5: start <= 1'b1;
                endcase
            end

            if (start) begin
                // Gán tạm
                reg [DATA_WIDTH-1:0] t0, t1, t2, t3, t4;
                reg [DATA_WIDTH-1:0] tmp;

                t0 = in0;
                t1 = in1;
                t2 = in2;
                t3 = in3;
                t4 = in4;

                // Bước 1
                if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end
                if (t1 > t2) begin tmp = t1; t1 = t2; t2 = tmp; end
                if (t2 > t3) begin tmp = t2; t2 = t3; t3 = tmp; end
                if (t3 > t4) begin tmp = t3; t3 = t4; t4 = tmp; end

                // Bước 2
                if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end
                if (t1 > t2) begin tmp = t1; t1 = t2; t2 = tmp; end
                if (t2 > t3) begin tmp = t2; t2 = t3; t3 = tmp; end

                // Bước 3
                if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end
                if (t1 > t2) begin tmp = t1; t1 = t2; t2 = tmp; end

                // Bước 4
                if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end

                // Lưu kết quả
                sorted0 <= t0;
                sorted1 <= t1;
                sorted2 <= t2;
                sorted3 <= t3;
                sorted4 <= t4;

                start <= 0;
            end
        end
    end

    // Đọc dữ liệu
    always @(posedge iClk) begin
        if (!iChipSelect_n && !iRead_n) begin
            case (iAddress)
                4'd0: oData <= in0;
                4'd1: oData <= in1;
                4'd2: oData <= in2;
                4'd3: oData <= in3;
                4'd4: oData <= in4;
                4'd6: oData <= sorted0;
                4'd7: oData <= sorted1;
                4'd8: oData <= sorted2;
                4'd9: oData <= sorted3;
                4'd10: oData <= sorted4;
                default: oData <= 0;
            endcase
        end
    end

endmodule
