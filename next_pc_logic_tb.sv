module next_pc_logic_tb();

    logic [31:0] i_pc_plus_4;
    logic [31:0] i_branch_target;
    logic [31:0] i_jump_target;
    logic i_branch_taken;
    logic i_jump;
    logic [31:0] o_next_pc;

    integer pass_count;
    integer fail_count;

    next_pc_logic u_next_pc_logic_1 (
        .i_pc_plus_4(i_pc_plus_4),
        .i_branch_target(i_branch_target),
        .i_jump_target(i_jump_target),
        .i_branch_taken(i_branch_taken),
        .i_jump(i_jump),
        .o_next_pc(o_next_pc)
    );

    initial begin

        pass_count = 0;
        fail_count = 0;

        i_pc_plus_4 = 32'd104;
        i_branch_target = 32'd200;
        i_jump_target = 32'd500;

        i_branch_taken = 0;
        i_jump = 0;

        #5;

        // Test 1: Normal execution
        if (o_next_pc !== 32'd104) begin
            $display("FAIL: Normal execution");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Normal execution");
            pass_count = pass_count + 1;
        end

        // Test 2: Branch taken
        i_branch_taken = 1;
        i_jump = 0;
        #5;

        if (o_next_pc !== 32'd200) begin
            $display("FAIL: Branch");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Branch");
            pass_count = pass_count + 1;
        end

        // Test 3: Jump
        i_branch_taken = 0;
        i_jump = 1;
        #5;

        if (o_next_pc !== 32'd500) begin
            $display("FAIL: Jump");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Jump");
            pass_count = pass_count + 1;
        end

        // Test 4: Jump priority over branch
        i_branch_taken = 1;
        i_jump = 1;
        #5;

        if (o_next_pc !== 32'd500) begin
            $display("FAIL: Jump priority");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Jump priority");
            pass_count = pass_count + 1;
        end

        // Test 5: Neither branch nor jump
        i_branch_taken = 0;
        i_jump = 0;
        #5;

        if (o_next_pc !== 32'd104) begin
            $display("FAIL: Neither branch nor jump");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Neither branch nor jump");
            pass_count = pass_count + 1;
        end

        // Final summary
        $display("--------------------------------");
        $display("NEXT PC LOGIC TEST SUMMARY");
        $display("Passed tests: %0d", pass_count);
        $display("Failed tests: %0d", fail_count);
        $display("--------------------------------");

        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $fatal(1, "TESTBENCH FAILED");

        $finish;

    end

endmodule