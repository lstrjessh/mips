// Lab 6: Single-Cycle MIPS Datapath
// Control signals left unconnected - just checking datapath wiring

module processor(
    input clock,
    input reset
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
    wire [4:0]  rs     = instruction[25:21]; // register source
    wire [4:0]  rt     = instruction[20:16]; // register target
    wire [4:0]  rd     = instruction[15:11]; // register destination
    wire [15:0] imm    = instruction[15:0];  // immediate value

    // === STAGE 1: FETCH ===
    
    // PC increment: add 4 to current PC (each instruction is 4 bytes)
    adder pc_adder (
        .a_in(pc_current),
        .b_in(32'd4),
        .sum_out(pc_next)
    );
    // Program counter register
    pc_register pc (
        .clock(clock),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc_current)
    );

    // Fetch instruction from ROM
    inst_rom #(
        .INIT_PROGRAM("c:/Users/LESTER/Desktop/code/mips_computer/lab6/blank.memh")
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

    // Sign extend the 16-bit immediate to 32 bits
    sign_extend sign_ext (
        .imm_in(imm),
        .imm_out(sign_extended_imm)
    );

    // Register file: read rs and rt
    register_file regfile (
        .clock(clock),
        .reset(reset),
        .read_addr1(rs),
        .read_addr2(rt),
        .write_addr(reg_write_addr),
        .write_data(reg_write_data),
        .write_enable(reg_write_enable),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2)
    );
    
    // === STAGE 3: EXECUTE === 
    
    // ALU source mux: pick register or immediate   
    mux2 #(.WIDTH(32)) alu_src_mux (    
        .in0(reg_read_data2),   
        .in1(sign_extended_imm),    
        .sel(alu_src_imm),  
        .out(alu_input_b)   
    );  

    // ALU
    alu main_alu (
        .Func_in(alu_func),
        .A_in(reg_read_data1),
        .B_in(alu_input_b),
        .O_out(alu_result)
    );

    // === STAGE 4: MEMORY ===
    // Data memory
    data_memory #(
        .INIT_PROGRAM0("c:/Users/LESTER/Desktop/code/mips_computer/lab6/blank.memh"),
        .INIT_PROGRAM1("c:/Users/LESTER/Desktop/code/mips_computer/lab6/blank.memh"),
        .INIT_PROGRAM2("c:/Users/LESTER/Desktop/code/mips_computer/lab6/blank.memh"),
        .INIT_PROGRAM3("c:/Users/LESTER/Desktop/code/mips_computer/lab6/blank.memh")
    ) data_mem (
        .clock(clock),
        .reset(reset),
        .addr_in(alu_result),
        .writedata_in(reg_read_data2),
        .re_in(mem_read),
        .we_in(mem_write),
        .size_in(2'b11),
        .readdata_out(memory_read_data),
        // Serial port I/O connections
        .serial_in(serial_in),
        .serial_out(serial_out),
        .serial_rden_out(serial_rden_out),
        .serial_wren_out(serial_wren_out),
        .serial_ready_in(serial_ready_in),
        .serial_valid_in(serial_valid_in)
    );

    // === STAGE 5: WRITE-BACK ===
    // Write-back mux: memory or ALU result goes to register file
    mux2 #(.WIDTH(32)) reg_write_mux (
        .in0(memory_read_data),
        .in1(alu_result),
        .sel(reg_src_alu),
        .out(reg_write_data)
    );
endmodule
