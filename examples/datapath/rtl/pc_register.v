module pc_register(
    input clock,
    input reset,
    input [31:0] pc_next,
    output reg [31:0] pc
);
    parameter RESET_VALUE = 32'h003FFFFC; // Resets to 0x003FFFFC as specified

    always @(posedge clock or posedge reset) begin // Trigger on clock edge or reset
        if (reset)
            pc <= RESET_VALUE; // Reset PC to 0x003FFFFC
        else
            pc <= pc_next; // Update PC to next value
    end
endmodule
