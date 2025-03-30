module half_adder(
    input a, 
    input b, 
    output s0, 
    output c0
);
    assign s0 = a ^ b;
    assign c0 = a & b;
endmodule