
`timescale 1ns/1ps

module main_control (
    input logic [5:0] i_opcode,
    output logic o_reg_dst,
    output logic o_reg_write,
    output logic o_alu_src,
    output logic o_mem_read,
    output logic o_mem_write,
    output logic o_mem_to_reg,
    output logic o_branch,
    output logic o_jump,
    output logic o_imm_zero_ext,
    output logic [1:0] o_alu_op
);

    localparam logic [5:0] OP_RTYPE = 6'b000000;
    localparam logic [5:0] OP_ADDI = 6'b001000;
    localparam logic [5:0] OP_ANDI = 6'b001100;
    localparam logic [5:0] OP_LW = 6'b100011;
    localparam logic [5:0] OP_SW = 6'b101011;
    localparam logic [5:0] OP_BEQ = 6'b000100;
    localparam logic [5:0] OP_J = 6'b000010;

    always_comb begin
        o_reg_dst = 1'b0;
        o_reg_write = 1'b0;
        o_alu_src = 1'b0;
        o_mem_read = 1'b0;
        o_mem_write = 1'b0;
        o_mem_to_reg = 1'b0;
        o_branch = 1'b0;
        o_jump = 1'b0;
        o_imm_zero_ext = 1'b0;
        o_alu_op = 2'b00;

        case (i_opcode)
            OP_RTYPE: begin
                o_reg_dst = 1'b1;
                o_reg_write = 1'b1;
                o_alu_op = 2'b10;
            end
            OP_ADDI: begin
                o_reg_write = 1'b1;
                o_alu_src = 1'b1;
                o_alu_op = 2'b00;
            end
            OP_ANDI: begin
                o_reg_write = 1'b1;
                o_alu_src = 1'b1;
                o_imm_zero_ext = 1'b1;
                o_alu_op = 2'b11;
            end
            OP_LW: begin
                o_reg_write = 1'b1;
                o_alu_src = 1'b1;
                o_mem_read = 1'b1;
                o_mem_to_reg = 1'b1;
                o_alu_op = 2'b00;
            end
            OP_SW: begin
                o_alu_src = 1'b1;
                o_mem_write = 1'b1;
                o_alu_op = 2'b00;
            end
            OP_BEQ: begin
                o_branch = 1'b1;
                o_alu_op = 2'b01;
            end
            OP_J: begin
                o_jump = 1'b1;
            end
            default: begin

            end
        endcase
    end

endmodule
