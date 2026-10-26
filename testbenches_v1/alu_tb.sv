`timescale 1ns/1ps

module alu_tb;

    localparam logic [2:0] ALU_AND = 3'b000;
    localparam logic [2:0] ALU_OR  = 3'b001;
    localparam logic [2:0] ALU_ADD = 3'b010;
    localparam logic [2:0] ALU_SUB = 3'b110;
    localparam logic [2:0] ALU_SLT = 3'b111;

    localparam int NUM_RANDOM = 1000;

    logic [31:0] i_operand_a;
    logic [31:0] i_operand_b;
    logic [2:0]  i_alu_ctrl;
    logic [31:0] o_result;
    logic        o_zero;

    int errors = 0;
    int tests  = 0;

    alu dut (
        .i_operand_a (i_operand_a),
        .i_operand_b (i_operand_b),
        .i_alu_ctrl  (i_alu_ctrl),
        .o_result    (o_result),
        .o_zero      (o_zero)
    );

    // reference model
    function automatic logic [31:0] expected_result(input logic [31:0] a, input logic [31:0] b,
                                                    input logic [2:0] ctrl);
        case (ctrl)
            ALU_AND: return a & b;
            ALU_OR:  return a | b;
            ALU_ADD: return a + b;
            ALU_SUB: return a - b;
            ALU_SLT: return ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            default: return 32'd0;
        endcase
    endfunction

    // apply inputs and compare result and zero flag against the reference model
    task automatic check(input logic [31:0] a, input logic [31:0] b,
                         input logic [2:0] ctrl, input bit verbose);
        logic [31:0] exp_res;
        logic        exp_zero;
        i_operand_a = a;
        i_operand_b = b;
        i_alu_ctrl  = ctrl;
        #1;
        exp_res  = expected_result(a, b, ctrl);
        exp_zero = (exp_res == 32'd0);
        tests++;
        if (o_result !== exp_res || o_zero !== exp_zero) begin
            errors++;
            $display("FAIL ctrl=%b a=%h b=%h -> result=%h zero=%b, expected result=%h zero=%b",
                     ctrl, a, b, o_result, o_zero, exp_res, exp_zero);
        end else if (verbose) begin
            $display("PASS ctrl=%b a=%h b=%h -> result=%h zero=%b",
                     ctrl, a, b, o_result, o_zero);
        end
    endtask

    logic [2:0] ops [5] = '{ALU_AND, ALU_OR, ALU_ADD, ALU_SUB, ALU_SLT};

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        $display("---- AND ----");
        check(32'hFFFF_0000, 32'h0F0F_0F0F, ALU_AND, 1);
        check(32'hAAAA_AAAA, 32'h5555_5555, ALU_AND, 1);  // zero result
        check(32'hFFFF_FFFF, 32'hFFFF_FFFF, ALU_AND, 1);

        $display("---- OR ----");
        check(32'hFFFF_0000, 32'h0000_FFFF, ALU_OR, 1);
        check(32'h0000_0000, 32'h0000_0000, ALU_OR, 1);   // zero result
        check(32'h1234_0000, 32'h0000_5678, ALU_OR, 1);

        $display("---- ADD ----");
        check(32'd5,          32'd7,          ALU_ADD, 1);
        check(32'hFFFF_FFFF,  32'd1,          ALU_ADD, 1);  // wrap to zero
        check(32'h7FFF_FFFF,  32'd1,          ALU_ADD, 1);  // signed overflow
        check(32'hFFFF_FFFB,  32'd3,          ALU_ADD, 1);  // -5 + 3

        $display("---- SUB ----");
        check(32'd10,         32'd3,          ALU_SUB, 1);
        check(32'd42,         32'd42,         ALU_SUB, 1);  // equal -> zero (beq)
        check(32'd3,          32'd10,         ALU_SUB, 1);  // negative result
        check(32'h8000_0000,  32'd1,          ALU_SUB, 1);  // signed underflow

        $display("---- SLT (signed) ----");
        check(32'd3,          32'd5,          ALU_SLT, 1);  // 3 < 5    -> 1
        check(32'd5,          32'd3,          ALU_SLT, 1);  // 5 < 3    -> 0
        check(32'd7,          32'd7,          ALU_SLT, 1);  // equal    -> 0
        check(32'hFFFF_FFFF,  32'd1,          ALU_SLT, 1);  // -1 < 1   -> 1
        check(32'd1,          32'hFFFF_FFFF,  ALU_SLT, 1);  // 1 < -1   -> 0
        check(32'h8000_0000,  32'h7FFF_FFFF,  ALU_SLT, 1);  // min < max -> 1
        check(32'hFFFF_FFFE,  32'hFFFF_FFFF,  ALU_SLT, 1);  // -2 < -1  -> 1

        $display("---- undefined ctrl codes -> 0 ----");
        check(32'h1234_5678, 32'h9ABC_DEF0, 3'b011, 1);
        check(32'h1234_5678, 32'h9ABC_DEF0, 3'b100, 1);
        check(32'h1234_5678, 32'h9ABC_DEF0, 3'b101, 1);

        $display("---- random tests (%0d per op) ----", NUM_RANDOM);
        for (int k = 0; k < 5; k++) begin
            for (int n = 0; n < NUM_RANDOM; n++) begin
                check($random, $random, ops[k], 0);
            end
        end

        $display("========================================");
        if (errors == 0) $display("ALU TB PASSED: %0d checks", tests);
        else             $display("ALU TB FAILED: %0d / %0d checks failed", errors, tests);
        $display("========================================");
        $finish;
    end

endmodule
