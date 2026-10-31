`timescale 1ns/1ps

module alu_control_tb();

    logic [1:0] i_alu_op;
    logic [5:0] i_funct;
    logic [2:0] o_alu_ctrl;
    //connecting the wires
    alu_control u_alu_control_1 (
        .i_alu_op (i_alu_op),
        .i_funct (i_funct),
        .o_alu_ctrl(o_alu_ctrl)
    );

    int errors = 0;
    int checks = 0;

    //options of alu_op (00 lw/sw/addi, 01 beq, 10 R-type, 11 andi)
    logic [1:0] ops [4] = '{2'b00, 2'b01, 2'b10, 2'b11};

    initial begin
        logic [2:0] expected;

        $display("4 alu_ops x 64 funct.");
        for (int i = 0; i < 4; i++) begin
            for (int f = 0; f < 64; f++) begin
                //return of alu_control
                i_alu_op = ops[i];
                i_funct = f[5:0];
                #1; //wait 1ns

                //expected ctrl for alu_op and funct
                case (ops[i])
                    2'b00: expected = 3'b010; //add
                    2'b01: expected = 3'b110; //sub
                    2'b11: expected = 3'b000; //and
                    default: case (f[5:0])
                        6'b100000: expected = 3'b010; //add
                        6'b100010: expected = 3'b110; //sub
                        6'b100100: expected = 3'b000; //and
                        6'b100101: expected = 3'b001; //or
                        6'b101010: expected = 3'b111; //slt
                        default: expected = 3'b010;
                    endcase
                endcase

                checks++;
                if (o_alu_ctrl === expected) begin
                    //all is good
                end else begin
                    errors++;
                    $display("FAIL op=%b funct=%b -> %b (exp %b)", ops[i], f[5:0], o_alu_ctrl, expected);
                end
            end
        end

        if (errors == 0)
            $display("alu_control_tb: PASS (%0d checks)", checks);
        else
            $display("alu_control_tb: FAIL (%0d errors / %0d checks)", errors, checks);
        $finish;
    end

endmodule
