`timescale 1ns/1ps

module alu_control_tb;

    logic [1:0] i_alu_op;
    logic [5:0] i_funct;
    logic [2:0] o_alu_ctrl;

    int errors = 0;
    int tests  = 0;

    alu_control dut (
        .i_alu_op   (i_alu_op),
        .i_funct    (i_funct),
        .o_alu_ctrl (o_alu_ctrl)
    );

    // apply inputs and compare against the expected control code
    task automatic check(input logic [1:0] alu_op, input logic [5:0] funct,
                         input logic [2:0] expected, input string name);
        i_alu_op = alu_op;
        i_funct  = funct;
        #1;
        tests++;
        if (o_alu_ctrl !== expected) begin
            errors++;
            $display("FAIL %-14s alu_op=%b funct=%b -> got %b, expected %b",
                     name, alu_op, funct, o_alu_ctrl, expected);
        end else begin
            $display("PASS %-14s alu_op=%b funct=%b -> %b",
                     name, alu_op, funct, o_alu_ctrl);
        end
    endtask

    // reference model of the expected decode
    function automatic logic [2:0] expected_ctrl(input logic [1:0] alu_op, input logic [5:0] funct);
        case (alu_op)
            2'b00: return 3'b010;
            2'b01: return 3'b110;
            2'b11: return 3'b000;
            2'b10: case (funct)
                       6'b100000: return 3'b010;
                       6'b100010: return 3'b110;
                       6'b100100: return 3'b000;
                       6'b100101: return 3'b001;
                       6'b101010: return 3'b111;
                       default:   return 3'b010;
                   endcase
            default: return 3'b010;
        endcase
    endfunction

    initial begin
        $dumpfile("alu_control_tb.vcd");
        $dumpvars(0, alu_control_tb);

        $display("---- directed tests ----");
        // alu_op 00/01/11 ignore funct
        check(2'b00, 6'b000000, 3'b010, "lw/sw/addi");
        check(2'b00, 6'b100010, 3'b010, "add(ign funct)");
        check(2'b01, 6'b000000, 3'b110, "beq");
        check(2'b01, 6'b100101, 3'b110, "sub(ign funct)");
        check(2'b11, 6'b000000, 3'b000, "andi");
        check(2'b11, 6'b101010, 3'b000, "and(ign funct)");

        // R-type decode
        check(2'b10, 6'b100000, 3'b010, "R add");
        check(2'b10, 6'b100010, 3'b110, "R sub");
        check(2'b10, 6'b100100, 3'b000, "R and");
        check(2'b10, 6'b100101, 3'b001, "R or");
        check(2'b10, 6'b101010, 3'b111, "R slt");
        check(2'b10, 6'b000000, 3'b010, "R unknown");
        check(2'b10, 6'b111111, 3'b010, "R unknown");

        $display("---- exhaustive sweep (all alu_op x funct) ----");
        for (int op = 0; op < 4; op++) begin
            for (int f = 0; f < 64; f++) begin
                i_alu_op = op[1:0];
                i_funct  = f[5:0];
                #1;
                tests++;
                if (o_alu_ctrl !== expected_ctrl(op[1:0], f[5:0])) begin
                    errors++;
                    $display("FAIL sweep alu_op=%b funct=%b -> got %b, expected %b",
                             op[1:0], f[5:0], o_alu_ctrl, expected_ctrl(op[1:0], f[5:0]));
                end
            end
        end

        $display("========================================");
        if (errors == 0) $display("ALU_CONTROL TB PASSED: %0d checks", tests);
        else             $display("ALU_CONTROL TB FAILED: %0d / %0d checks failed", errors, tests);
        $display("========================================");
        $finish;
    end

endmodule
