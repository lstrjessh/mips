// Lab 7: Control Unit Testbench
// Verifies control signal outputs for each supported instruction
`include "control.v"

module control_tb;
    reg [5:0] opcode;
    reg [5:0] funct;
    wire reg_dst, reg_write, mem_to_reg, alu_src, mem_write, mem_read;
    wire [5:0] alu_op;

    // DUT
    control dut (
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

    // Opcodes
    localparam OP_RTYPE = 6'b000000;
    localparam OP_ADDI  = 6'b001000;
    localparam OP_LW    = 6'b100011;
    localparam OP_SW    = 6'b101011;

    // Funct codes (R-type)
    localparam F_ADD = 6'b100000;
    localparam F_SUB = 6'b100010;
    localparam F_AND = 6'b100100;
    localparam F_OR  = 6'b100101;
    localparam F_XOR = 6'b100110;
    localparam F_NOR = 6'b100111;

    initial begin
        $display("Testing control unit outputs...");
        // R-type: ADD
        opcode = OP_RTYPE; funct = F_ADD; #10;
        $display("R-type ADD: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // R-type: SUB
        opcode = OP_RTYPE; funct = F_SUB; #10;
        $display("R-type SUB: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // R-type: AND
        opcode = OP_RTYPE; funct = F_AND; #10;
        $display("R-type AND: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // R-type: OR
        opcode = OP_RTYPE; funct = F_OR; #10;
        $display("R-type OR: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // R-type: XOR
        opcode = OP_RTYPE; funct = F_XOR; #10;
        $display("R-type XOR: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // R-type: NOR
        opcode = OP_RTYPE; funct = F_NOR; #10;
        $display("R-type NOR: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // ADDI
        opcode = OP_ADDI; funct = 6'bxxxxxx; #10;
        $display("ADDI: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // LW
        opcode = OP_LW; funct = 6'bxxxxxx; #10;
        $display("LW: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        // SW
        opcode = OP_SW; funct = 6'bxxxxxx; #10;
        $display("SW: reg_dst=%b reg_write=%b mem_to_reg=%b alu_op=%b alu_src=%b mem_write=%b mem_read=%b", reg_dst, reg_write, mem_to_reg, alu_op, alu_src, mem_write, mem_read);
        $display("Control unit testbench finished.");
        $finish;
    end
endmodule
