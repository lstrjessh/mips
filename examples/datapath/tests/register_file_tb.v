// Lab 6: Register File Testbench
`include "register_file.v"
`timescale 1ns/1ps

module register_file_tb();

    reg clock, reset;
    reg [4:0] read_addr1, read_addr2, write_addr;
    reg [31:0] write_data;
    reg write_enable;
    wire [31:0] read_data1, read_data2;

    register_file uut (
        .clock(clock),
        .reset(reset),
        .read_addr1(read_addr1), // Read address 1
        .read_addr2(read_addr2), // Read address 2
        .write_addr(write_addr), // Write address
        .write_data(write_data), // Write data
        .write_enable(write_enable), // Write enable
        .read_data1(read_data1), // Read data 1
        .read_data2(read_data2) // Read data 2
    );

    // Clock generation (20ns period)
    initial begin
        clock = 0;
        forever #10 clock = ~clock;
    end

    initial begin
        // Initialize
        reset = 1; write_enable = 0;
        read_addr1 = 0; read_addr2 = 0;
        write_addr = 0; write_data = 0;
        #10 reset = 0;

        // Write 0xAAAAAAAA to $1
        @(posedge clock);
        write_addr = 5'd1; write_data = 32'hAAAAAAAA; write_enable = 1;
        $display("[%0t] WRITE: $%0d = 0x%h", $time, write_addr, write_data);
        
        // Write 0xBBBBBBBB to $2
        @(posedge clock);
        write_addr = 5'd2; write_data = 32'hBBBBBBBB;
        $display("[%0t] WRITE: $%0d = 0x%h", $time, write_addr, write_data);
        
        // Read $1 and $2 simultaneously
        @(posedge clock);
        write_enable = 0;
        read_addr1 = 5'd1; read_addr2 = 5'd2;
        $display("[%0t] READ:  $1 = 0x%h, $2 = 0x%h", $time, read_data1, read_data2);

        // Try writing to $0 (should be ignored)
        @(posedge clock);
        write_addr = 5'd0; write_data = 32'hCCCCCCCC; write_enable = 1;
        $display("[%0t] WRITE: $0 = 0x%h", $time, write_data);
        
        // Read $0 (should still be 0)
        @(posedge clock);
        write_enable = 0;
        read_addr1 = 5'd0;
        $display("[%0t] READ:  $0 = 0x%h", $time, read_data1);

        @(posedge clock);
        $display("--- Test Complete ---");
        $finish;
    end    // Waveform output
    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);
    end

endmodule
