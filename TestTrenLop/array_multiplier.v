module array_multiplier(input [3:0] A, B, output [7:0] z);
  wire p[3:0][3:0]; // Mảng lưu tích từng bit của A và B
  wire [10:0] c;    // Dây nối chứa carry từ HA/FA
  wire [5:0] s;     // Dây nối chứa sum từ HA/FA

  genvar i, j;
  generate
    for (i = 0; i < 4; i = i + 1) begin : generate_and_gates
      for (j = 0; j < 4; j = j + 1) begin : generate_and
        assign p[i][j] = A[i] & B[j];
      end
    end
  endgenerate
  
  assign z[0] = p[0][0];

  // Row 0
  half_adder h0 (p[0][1], p[1][0], z[1], c[0]);
  half_adder h1 (p[1][1], p[2][0], s[0], c[1]);
  half_adder h2 (p[2][1], p[3][0], s[1], c[2]);
  
  // Row 1
  full_adder f0 (p[0][2], c[0], s[0], z[2], c[3]);
  full_adder f1 (p[1][2], c[1], s[1], s[2], c[4]);
  full_adder f2 (p[2][2], c[2], p[3][1], s[3], c[5]);
  
  // Row 2
  full_adder f3 (p[0][3], c[3], s[2], z[3], c[6]);
  full_adder f4 (p[1][3], c[4], s[3], s[4], c[7]);
  full_adder f5 (p[2][3], c[5], p[3][2], s[5], c[8]);
  
  // Row 3
  half_adder h3 (c[6], s[4], z[4], c[9]);
  full_adder f6 (c[9], c[7], s[5], z[5], c[10]);
  full_adder f7 (c[10], c[8], p[3][3], z[6], z[7]);
endmodule