module imm_extender_tb();

    logic [15:0] i_immediate;
    logic        i_zero_extend;
    logic [31:0] o_immediate_ext;

    integer pass_count;
    integer fail_count;

    imm_extender u_imm_extender_1 (
        .i_immediate(i_immediate),
        .i_zero_extend(i_zero_extend),
        .o_immediate_ext(o_immediate_ext)
    );

    initial begin

        pass_count = 0;
        fail_count = 0;

        // Test 1: Zero extend positive value 3
        i_zero_extend = 1;
        i_immediate = 16'h0003;
        #5;

        if (o_immediate_ext !== 32'h00000003) begin
            $display("FAIL: Zero extend positive 3");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Zero extend positive 3");
            pass_count = pass_count + 1;
        end

        // Test 2: Zero extend negative representation -3
        i_zero_extend = 1;
        i_immediate = 16'hFFFD;
        #5;

        if (o_immediate_ext !== 32'h0000FFFD) begin
            $display("FAIL: Zero extend FFFD");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Zero extend FFFD");
            pass_count = pass_count + 1;
        end

        // Test 3: Sign extend positive value 3
        i_zero_extend = 0;
        i_immediate = 16'h0003;
        #5;

        if (o_immediate_ext !== 32'h00000003) begin
            $display("FAIL: Sign extend positive 3");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Sign extend positive 3");
            pass_count = pass_count + 1;
        end

        // Test 4: Sign extend negative value -3
        i_zero_extend = 0;
        i_immediate = 16'hFFFD;
        #5;

        if (o_immediate_ext !== 32'hFFFFFFFD) begin
            $display("FAIL: Sign extend negative 3");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Sign extend negative 3");
            pass_count = pass_count + 1;
        end

        // Test 5: Zero extend maximum positive 16-bit value
        i_zero_extend = 1;
        i_immediate = 16'h7FFF;
        #5;

        if (o_immediate_ext !== 32'h00007FFF) begin
            $display("FAIL: Zero extend 7FFF");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Zero extend 7FFF");
            pass_count = pass_count + 1;
        end

        // Test 6: Sign extend minimum negative 16-bit value
        i_zero_extend = 0;
        i_immediate = 16'h8000;
        #5;

        if (o_immediate_ext !== 32'hFFFF8000) begin
            $display("FAIL: Sign extend 8000");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Sign extend 8000");
            pass_count = pass_count + 1;
        end

        // Test 7: Zero extend zero
        i_zero_extend = 1;
        i_immediate = 16'h0000;
        #5;

        if (o_immediate_ext !== 32'h00000000) begin
            $display("FAIL: Zero extend zero");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Zero extend zero");
            pass_count = pass_count + 1;
        end

        // Test 8: Sign extend -1
        i_zero_extend = 0;
        i_immediate = 16'hFFFF;
        #5;

        if (o_immediate_ext !== 32'hFFFFFFFF) begin
            $display("FAIL: Sign extend -1");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Sign extend -1");
            pass_count = pass_count + 1;
        end

        // Final summary
        $display("--------------------------------");
        $display("IMMEDIATE EXTENDER TEST SUMMARY");
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