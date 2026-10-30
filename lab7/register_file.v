// Lab 7: Register File with Debug Outputs
// - 32 registers, each 32 bits wide
// - Two read ports (asynchronous)
// - One write port (synchronous, on positive clock edge)
// - Register $0 always reads as 0
module register_file(
    input clock,
    input reset,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr,
    input [31:0] write_data,
    input write_enable,
    output [31:0] read_data1,
    output [31:0] read_data2,
    // Output ports for debug registers 11, 12, 13  
    output [31:0] r11_out,
    output [31:0] r12_out,
    output [31:0] r13_out
);
    reg [31:0] registers [31:0];
    integer i;

    // Asynchronous reads (register $0 always returns 0)
    assign read_data1 = (read_addr1 == 0) ? 32'b0 : registers[read_addr1];
    assign read_data2 = (read_addr2 == 0) ? 32'b0 : registers[read_addr2];

    // Debug outputs for registers 11, 12, 13
    assign r11_out = registers[11];
    assign r12_out = registers[12];
    assign r13_out = registers[13];

    // Synchronous write on positive clock edge
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (write_enable && write_addr != 0) begin
            registers[write_addr] <= write_data;
        end
    end

endmodule
