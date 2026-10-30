// Sign Extender: 16-bit to 32-bit
module sign_extend(
    input  [15:0] imm_in,
    output [31:0] imm_out
);
    // Copy sign bit (imm_in[15]) into upper 16 bits
    assign imm_out = {{16{imm_in[15]}}, imm_in};
endmodule
