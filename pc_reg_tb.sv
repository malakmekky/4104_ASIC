module pc_reg_tb();

    logic clk;
    logic rst_n;
    logic [31:0] i_next_pc;
    logic [31:0] o_pc;

    integer pass_count;
    integer fail_count;

    pc_reg u_pc_reg_1 (
        .clk(clk),
        .rst_n(rst_n),
        .i_next_pc(i_next_pc),
        .o_pc(o_pc)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst_n = 1;
        i_next_pc = 32'h00000004;

        pass_count = 0;
        fail_count = 0;

        // Reset test
        #1;
        rst_n = 0;
        #1;

        if (o_pc !== 32'h00000000) begin
            $display("FAIL: Reset test. Expected 00000000, got %h", o_pc);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Reset test");
            pass_count = pass_count + 1;
        end

        // Release reset
        rst_n = 1;
        i_next_pc = 32'h00000008;

        // Load test
        @(posedge clk);
        #1;

        if (o_pc !== 32'h00000008) begin
            $display("FAIL: Load test. Expected 00000008, got %h", o_pc);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Load test");
            pass_count = pass_count + 1;
        end

        // Hold test
        i_next_pc = 32'h0000000C;
        #1;

        if (o_pc !== 32'h00000008) begin
            $display("FAIL: Hold test. Expected 00000008, got %h", o_pc);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Hold test");
            pass_count = pass_count + 1;
        end

        // Load next PC value
        @(posedge clk);
        #1;

        if (o_pc !== 32'h0000000C) begin
            $display("FAIL: Next load test. Expected 0000000C, got %h", o_pc);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Next load test");
            pass_count = pass_count + 1;
        end

        // Final summary
        $display("-----------------------------");
        $display("PC REGISTER TEST SUMMARY");
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        $display("-----------------------------");

        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $fatal(1, "SOME TESTS FAILED");

        $finish;

    end

endmodule