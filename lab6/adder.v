// Simple 32-bit adder for PC increment (PC + 4)
module adder(
    input [31:0] a_in,    // First operand
    input [31:0] b_in,    // Second operand
    output [31:0] sum_out // Sum result
);

    // Simple combinational addition
    assign sum_out = a_in + b_in;

endmodule
