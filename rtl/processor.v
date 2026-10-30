// Lab 7: Single-Cycle Processor with Control Unit
// Supports: LW, SW, ADD, ADDI, SUB, AND, OR, NOR, XOR

module processor(
    input clock,
    input reset,
    // Serial port interface - accessed via memory-mapped I/O in data memory
    input  [7:0] serial_in,
    input        serial_ready_in,
    input        serial_valid_in,
    output [7:0] serial_out,
    output       serial_rden_out,
    output       serial_wren_out,
	 // Output Debug ports for FPGA Demonstration - Internal signals aren't accessible to top-level de1-soc wrapper module unless explicitly assigned as ports
    output [31:0] pc_out,       // Output Program Counter
    output [31:0] inst_out,     // Output Current Instruction
    output [31:0] alu_out,      // Output ALU Result
    output [31:0] r11_out,      // Output Register 11
    output [31:0] r12_out,      // Output Register 12
    output [31:0] r13_out       // Output Register 13
);

    // Wires
    wire [31:0] pc_current, pc_next; // Program counter current and next values
    wire [31:0] instruction; // Current instruction 
    wire [31:0] reg_read_data1, reg_read_data2; // Register file read data outputs
    wire [31:0] sign_extended_imm; // Sign-extended immediate value
    wire [31:0] alu_input_b, alu_result; // ALU input B and result 
    wire [31:0] memory_read_data, reg_write_data; // Data from memory and data to write to register file
    wire [4:0]  reg_write_addr; // Register file write address

    // Instruction fields
    wire [5:0]  opcode = instruction[31:26]; // Wired from instruction[31:26]
    wire [5:0]  funct  = instruction[5:0];   // Wired from instruction[5:0]
    wire [4:0]  rs     = instruction[25:21]; // register source
    wire [4:0]  rt     = instruction[20:16]; // register target
    wire [4:0]  rd     = instruction[15:11]; // register destination
    wire [15:0] imm    = instruction[15:0];  // immediate value

    // Control signals
    wire reg_dst;
    wire reg_write;
    wire mem_to_reg;
    wire [5:0] alu_op;
    wire alu_src;
    wire mem_write;
    wire mem_read;
	 
	 // Assigning debug outputs for FPGA demonstration
	assign pc_out   = pc_current;
    assign inst_out = instruction;
    assign alu_out  = alu_result;

    // === CONTROL UNIT ===
    control ctrl (
        .opcode(opcode),
        .funct(funct),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .mem_to_reg(mem_to_reg),    
        .alu_op(alu_op),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_read(mem_read)
    );

    // === STAGE 1: FETCH ===

    // PC increment: add 4 to current PC (each instruction is 4 bytes)
    adder pc_adder (
        .a_in(pc_current),
        .b_in(32'd4),
        .sum_out(pc_next)
    );

    pc_register pc (
        .clock(clock),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc_current)
    );

        inst_rom #(
            .INIT_PROGRAM("c:/Users/LESTER/Desktop/code/mips_computer/lab7/test/nbhelloworld.inst_rom.memh")
        ) instruction_memory (
            .clock(clock),
            .reset(reset),
            .addr_in(pc_current),	
            .data_out(instruction)
        );

        // === STAGE 2: DECODE ===

        // RegDst mux: select write register (rt for I-type, rd for R-type)
        mux2 #(.WIDTH(5)) reg_dst_mux (
            .in0(rt),
            .in1(rd),
            .sel(reg_dst),
            .out(reg_write_addr)
        );

    sign_extend sign_ext (
        .imm_in(imm),
        .imm_out(sign_extended_imm)
    );

    register_file regfile (
        .clock(clock),
        .reset(reset),
        .read_addr1(rs),
        .read_addr2(rt),
        .write_addr(reg_write_addr),
        .write_data(reg_write_data),
        .write_enable(reg_write),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2),
        .r11_out(r11_out), // Debug output for register 11 for FPGA demo
        .r12_out(r12_out), // Debug output for register 12 for FPGA demo
        .r13_out(r13_out) // Debug output for register 13 for FPGA demo
    );

    // === STAGE 3: EXECUTE ===

    mux2 #(.WIDTH(32)) alu_src_mux (
        .in0(reg_read_data2),
        .in1(sign_extended_imm),
        .sel(alu_src),
        .out(alu_input_b)
    );

    alu main_alu (
        .Func_in(alu_op),
        .A_in(reg_read_data1),
        .B_in(alu_input_b),
        .O_out(alu_result)
    );

    // === STAGE 4: MEMORY ===

    data_memory #(
        .INIT_PROGRAM0("c:/Users/LESTER/Desktop/code/mips_computer/lab7/test/nbhelloworld.data_ram0.memh"),
        .INIT_PROGRAM1("c:/Users/LESTER/Desktop/code/mips_computer/lab7/test/nbhelloworld.data_ram1.memh"),
        .INIT_PROGRAM2("c:/Users/LESTER/Desktop/code/mips_computer/lab7/test/nbhelloworld.data_ram2.memh"),
        .INIT_PROGRAM3("c:/Users/LESTER/Desktop/code/mips_computer/lab7/test/nbhelloworld.data_ram3.memh")
    ) data_mem (
        .clock(clock),
        .reset(reset),
        .addr_in(alu_result),
        .writedata_in(reg_read_data2),
        .re_in(mem_read),
        .we_in(mem_write),
        .size_in(2'b11),
        .readdata_out(memory_read_data),
        // Serial port connections
        .serial_in(serial_in),
        .serial_ready_in(serial_ready_in),
        .serial_valid_in(serial_valid_in),
        .serial_out(serial_out),
        .serial_rden_out(serial_rden_out),
        .serial_wren_out(serial_wren_out)
    );

    // === STAGE 5: WRITE-BACK ===

    mux2 #(.WIDTH(32)) mem_to_reg_mux (
        .in0(alu_result),          // sel=0: ALU result (R-type, ADDI)
        .in1(memory_read_data),   // sel=1: Memory data (LW)
        .sel(mem_to_reg),
        .out(reg_write_data)
    );

endmodule
