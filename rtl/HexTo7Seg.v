module HexTo7Seg (
    input [3:0] x,
    output reg [6:0] z
);

    always @(*) begin
        case (x)
            4'h0: z = 7'b1000000; // 0
            4'h1: z = 7'b1111001; // 1
            4'h2: z = 7'b0100100; // 2
            4'h3: z = 7'b0110000; // 3
            4'h4: z = 7'b0011001; // 4
            4'h5: z = 7'b0010010; // 5
            4'h6: z = 7'b0000010; // 6
            4'h7: z = 7'b1111000; // 7
            4'h8: z = 7'b0000000; // 8
            4'h9: z = 7'b0010000; // 9
            4'hA: z = 7'b0001000; // A
            4'hB: z = 7'b0000011; // b
            4'hC: z = 7'b1000110; // C
            4'hD: z = 7'b0100001; // d
            4'hE: z = 7'b0000110; // E
            4'hF: z = 7'b0001110; // F
            default: z = 7'b1111111; // Blank (all segments off)
        endcase
    end
endmodule
