`timescale 1ns/1ps

module testbench();

reg clock;
reg reset;

wire [7:0] serial_out;
wire serial_wren;

// Generate clock at 100 MHz
initial begin
    clock = 0;
    forever #10 clock = ~clock;
end

// Assert reset for 200 ns, then deassert
initial begin
    reset = 1;
    #200 reset = 0;
end

// Instantiate the processor "DUT"
processor dut(
    .clock(clock),
    .reset(reset),
    .serial_in(8'b0),
    .serial_valid_in(1'b0),
    .serial_ready_in(1'b1),
    .serial_rden_out(),
    .serial_out(serial_out),
    .serial_wren_out(serial_wren)
);

// Print message when serial port is written to
always @(posedge clock) begin
    if (!reset && serial_wren) begin
        $display("[%0d] Serial: %c", $time, serial_out);
    end
end

endmodule