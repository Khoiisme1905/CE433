module Memory
#(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 4
) (
    input iClk,
    input iReset_n,
    input iChipSelect_n,
    input iRead_n,
    input iWrite_n,
    input [ADDRESS_WIDTH - 1 : 0] iAddress,
    input [DATA_WIDTH - 1 : 0] iData,
    output reg [DATA_WIDTH - 1 : 0] oData
);
    reg [DATA_WIDTH - 1 : 0] mem [2**ADDRESS_WIDTH - 1 : 0];
    reg [ADDRESS_WIDTH - 1 : 0] address_reg;
    
    integer i;
    // Khởi tạo bộ nhớ
    initial begin
        for (i = 0; i < 2**ADDRESS_WIDTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
        address_reg = {ADDRESS_WIDTH{1'b0}};
        oData = {DATA_WIDTH{1'b0}};
    end
    
    always@ (posedge iClk or negedge iReset_n)
    begin
        if (~iReset_n) begin
            address_reg <= {ADDRESS_WIDTH{1'b0}};
            oData <= {DATA_WIDTH{1'b0}};
        end
        else begin
            if (~iChipSelect_n & ~iWrite_n) begin
                mem[iAddress] <= iData;
            end
            
            if (~iChipSelect_n & ~iRead_n) begin    
                address_reg <= iAddress;
                oData <= mem[iAddress]; // Đọc đồng bộ trực tiếp từ iAddress
            end
        end
    end
endmodule