// Register File: 32 registers x 32 bits
// - Two async read ports, one sync write port
// - $0 is hardwired to 0 (MIPS convention because it's a common constant)
module register_file(
    input clock,
    input reset,
    input [4:0] read_addr1, // Read address 1
    input [4:0] read_addr2, // Read address 2
    input [4:0] write_addr, // Write address
    input [31:0] write_data, // Write data
    input write_enable, // Write enable
    output [31:0] read_data1, // Read data 1
    output [31:0] read_data2 // Read data 2
);
    reg [31:0] registers [31:0]; // 32 registers x 32 bits
    integer i; // Index for loop

    // Reads are combinational (asynchronous, no clock needed) return 0 always for register $0
    assign read_data1 = (read_addr1 == 0) ? 32'b0 : registers[read_addr1]; 
    assign read_data2 = (read_addr2 == 0) ? 32'b0 : registers[read_addr2];

    // Writes happen on rising clock edge (synchronous)
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0; // Initialize all registers to 0 on reset
        end else if (write_enable && write_addr != 0) begin
            registers[write_addr] <= write_data; // Write data to specified register (except $0)
        end
    end
endmodule
