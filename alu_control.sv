
module alu_control (
    input  logic [1:0] i_alu_op,
    input  logic [5:0] i_funct,
    output logic [2:0] o_alu_ctrl
);

    always_comb begin
        o_alu_ctrl = 3'b010;

        case (i_alu_op)
            2'b00: o_alu_ctrl = 3'b010;  //addi lw sw - ADD
            2'b01: o_alu_ctrl = 3'b110;  // beq - SUB
            2'b11: o_alu_ctrl = 3'b000;  // andi - AND

            2'b10: begin
                case (i_funct)
                    6'b100000: o_alu_ctrl = 3'b010;  // ADD
                    6'b100010: o_alu_ctrl = 3'b110;  // SUB
                    6'b100100: o_alu_ctrl = 3'b000;  // AND
                    6'b100101: o_alu_ctrl = 3'b001;  // OR
                    6'b101010: o_alu_ctrl = 3'b111;  // SLT
                    default:   o_alu_ctrl = 3'b010;
                endcase
            end

            default: o_alu_ctrl = 3'b010;
        endcase
    end

endmodule
