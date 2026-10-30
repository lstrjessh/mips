// Lab 7: Control Unit
// Decodes opcode/funct and generates control signals for datapath
// Supported: LW, SW, ADD, ADDI, SUB, AND, OR, NOR, XOR
module control(
    input [5:0] opcode,           // instruction[31:26]
    input [5:0] funct,            // instruction[5:0] (R-type only)
    
    output reg reg_dst,           // 0=rt (I-type), 1=rd (R-type)
    output reg reg_write,         // 1=write to register file
    output reg mem_to_reg,        // 0=ALU result, 1=memory data
    output reg [5:0] alu_op,      // operation for ALU
    output reg alu_src,           // 0=register, 1=immediate
    output reg mem_write,         // 1=write to memory (SW)
    output reg mem_read           // 1=read from memory (LW)
);

    // Opcode constants
    localparam OP_RTYPE = 6'b000000;  // R-type (ADD, SUB, AND, OR, XOR, NOR)
    localparam OP_ADDI  = 6'b001000;  // ADDI rt, rs, imm
    localparam OP_LW    = 6'b100011;  // LW rt, offset(rs)
    localparam OP_SW    = 6'b101011;  // SW rt, offset(rs)
    
    // ALU function codes (matches funct field for R-type)
    localparam ALU_ADD = 6'b100000;
    localparam ALU_SUB = 6'b100010;
    localparam ALU_AND = 6'b100100;
    localparam ALU_OR  = 6'b100101;
    localparam ALU_XOR = 6'b100110;
    localparam ALU_NOR = 6'b100111;

    always @(*) begin // Combinational logic for control signals since control unit is purely combinational
        // Default: NOP (do nothing) - Set all control signals to 0
        reg_dst    = 0;
        reg_write  = 0;
        mem_to_reg = 0;
        alu_op     = 000000;
        alu_src    = 0;
        mem_write  = 0;
        mem_read   = 0;

        case (opcode)
            // R-type: rd = rs OP rt
            OP_RTYPE: begin
                reg_dst    = 1;       // write to rd
                reg_write  = 1;
                mem_to_reg = 0;       // ALU result (sel=0 selects ALU)
                alu_src    = 0;       // second operand from register
                alu_op     = funct;   // funct field determines ALU operation
            end

            // ADDI: rt = rs + sign_ext(imm)
            OP_ADDI: begin
                reg_dst    = 0;       // write to rt
                reg_write  = 1;
                mem_to_reg = 0;       // ALU result (sel=0 selects ALU)
                alu_src    = 1;       // second operand is immediate
                alu_op     = ALU_ADD;
            end

            // LW: rt = Memory[rs + sign_ext(offset)]
            OP_LW: begin
                reg_dst    = 0;       // write to rt
                reg_write  = 1;
                mem_to_reg = 1;       // data from memory (sel=1 selects memory)
                alu_src    = 1;       // address = rs + offset
                alu_op     = ALU_ADD;
                mem_read   = 1;
            end

            // SW: Memory[rs + sign_ext(offset)] = rt
            OP_SW: begin
                reg_write  = 0;       // no register write
                alu_src    = 1;       // address = rs + offset
                alu_op     = ALU_ADD;
                mem_write  = 1;
            end

            default: begin
                // Unknown opcode: NOP (do nothing) - Set all control signals to 0
            end
        endcase
    end

endmodule
