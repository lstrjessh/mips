// DE1-SoC MIPS Processor Demo - Processor debug monitoring for FPGA
module de1soc_demo(
    // Clock and Reset
    input  wire        clock_50,    // 50 MHz Internal Clock
    input  wire [3:0]  key,        // KEY[0] is active-low reset
    
    // Switches and LEDs
    input  wire [9:0]  sw,         // SW[9]=clock speed, SW[2:0]=display mode
    output wire [7:0]  ledr,       // LEDR[7:0]=display data upper byte
    
    // 7-Segment Displays
    output wire [6:0]  hex0,       // Rightmost display
    output wire [6:0]  hex1,
    output wire [6:0]  hex2,
    output wire [6:0]  hex3,
    output wire [6:0]  hex4,
    output wire [6:0]  hex5        // Leftmost display
);

    // System Control
    wire sys_reset;
    wire mips_clock;
    wire slow_clock;
    
    // Clock Divider for Slow Mode
    reg [25:0] clock_divider;
    
    // Processor Debug Signals
    wire [31:0] pc_debug;
    wire [31:0] inst_debug;
    wire [31:0] alu_debug;
    wire [31:0] r11_debug;
    wire [31:0] r12_debug;
    wire [31:0] r13_debug;
    
    // Serial Port Signals
    wire [7:0] serial_char;
    wire       serial_wren;
    reg  [7:0] last_serial_char;
    
    // Display Multiplexer
    reg [31:0] display_data;

    // Clock and Reset Logic
    assign sys_reset = key[0];
    
    // Clock divider: 50MHz / 2^26 ≈ 0.75Hz
    always @(posedge clock_50 or negedge sys_reset) begin
        if (!sys_reset)
            clock_divider <= 26'b0;
        else
            clock_divider <= clock_divider + 1;
    end
    assign slow_clock = clock_divider[25];
    
    // Clock speed select: SW[9] = 0 (50MHz), SW[9] = 1 (slow mode)
    assign mips_clock = sw[9] ? slow_clock : clock_50;

    // MIPS Processor Instance
    processor cpu(
        .clock(mips_clock),
        .reset(~sys_reset),
        .serial_in(8'b0),
        .serial_ready_in(1'b1),
        .serial_valid_in(1'b0),
        .serial_out(serial_char),
        .serial_rden_out(),
        .serial_wren_out(serial_wren),
        .pc_out(pc_debug),
        .inst_out(inst_debug),
        .alu_out(alu_debug),
        .r11_out(r11_debug),
        .r12_out(r12_debug),
        .r13_out(r13_debug)
    );
    
    // Serial Character Latching
    always @(posedge mips_clock or negedge sys_reset) begin
        if (!sys_reset)
            last_serial_char <= 8'h00;
        else if (serial_wren)
            last_serial_char <= serial_char;
    end
    
    // Display Mode Multiplexer
    always @(*) begin
        case (sw[2:0])
            3'b000: display_data = pc_debug;                    // PC
            3'b001: display_data = inst_debug;                  // Instruction
            3'b010: display_data = r11_debug;                    // Register $11
            3'b011: display_data = r12_debug;                    // Register $12
            3'b100: display_data = r13_debug;                    // Register $13
            3'b101: display_data = alu_debug;                   // ALU Result
            3'b110: display_data = {24'b0, last_serial_char};  // Serial Output
            3'b111: display_data = 32'h0;                       // Reserved
            default: display_data = 32'h0;
        endcase
    end

    // LED Outputs
    assign ledr[7:4] = display_data[31:28];  // Upper nibble
    assign ledr[3:0] = display_data[27:24];  // Lower nibble

    // 7-Segment Display Drivers
    HexTo7Seg seg5 (.x(display_data[23:20]), .z(hex5));
    HexTo7Seg seg4 (.x(display_data[19:16]), .z(hex4));
    HexTo7Seg seg3 (.x(display_data[15:12]), .z(hex3));
    HexTo7Seg seg2 (.x(display_data[11:8]),  .z(hex2));
    HexTo7Seg seg1 (.x(display_data[7:4]),   .z(hex1));
    HexTo7Seg seg0 (.x(display_data[3:0]),   .z(hex0));

endmodule
