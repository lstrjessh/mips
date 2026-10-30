// Lab 7: Program Counter Register
// Resets to 0x003FFFFC for Lab 7 test program
module pc_register(
    input clock,
    input reset,
    input [31:0] pc_next,
    output reg [31:0] pc
);
    parameter RESET_VALUE = 32'h003FFFFC;

    always @(posedge clock or posedge reset) begin
        if (reset)
            pc <= RESET_VALUE;
        else
            pc <= pc_next;
    end
endmodule
    