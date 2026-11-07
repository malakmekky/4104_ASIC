module register_file_tb();

    logic clk;
    logic rst;
    logic i_reg_write;
    logic [4:0] i_raddr1;
    logic [4:0] i_raddr2;
    logic [4:0] i_waddr;
    logic [31:0] i_wdata;
    logic [31:0] o_rdata1;
    logic [31:0] o_rdata2;

    integer pass_count;
    integer fail_count;

    register_file u_register_file_1 (
        .clk(clk),
        .i_reg_write(i_reg_write),
        .i_raddr1(i_raddr1),
        .i_raddr2(i_raddr2),
        .i_waddr(i_waddr),
        .i_wdata(i_wdata),
        .o_rdata1(o_rdata1),
        .o_rdata2(o_rdata2),
	.rst(rst)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 0;
        i_reg_write = 0;
        i_raddr1 = 0;
        i_raddr2 = 0;
        i_waddr = 0;
        i_wdata = 0;

        pass_count = 0;
        fail_count = 0;

        // Test 1: Reset
        #1;

        if ((o_rdata1 !== 32'd0) || (o_rdata2 !== 32'd0)) begin
            $display("FAIL: Reset test");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Reset test");
            pass_count = pass_count + 1;
        end

        rst = 1;

        // Test 2: Write 25 into register 1
        i_wdata = 32'd25;
        i_waddr = 5'd1;
        i_raddr1 = 5'd1;
        i_reg_write = 1;

        @(posedge clk);
        #1;

        if (o_rdata1 !== 32'd25) begin
            $display("FAIL: Write to register 1");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Write to register 1");
            pass_count = pass_count + 1;
        end

        // Test 3: Write 9 into register 5 and read both ports
        i_wdata = 32'd9;
        i_waddr = 5'd5;
        i_raddr1 = 5'd1;
        i_raddr2 = 5'd5;

        @(posedge clk);
        #1;

        if ((o_rdata1 !== 32'd25) || (o_rdata2 !== 32'd9)) begin
            $display("FAIL: Two-port reading");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Two-port reading");
            pass_count = pass_count + 1;
        end

        // Test 4: Try writing 17 into register 0
        i_wdata = 32'd17;
        i_waddr = 5'd0;
        i_raddr1 = 5'd0;
        i_raddr2 = 5'd5;

        @(posedge clk);
        #1;

        if ((o_rdata1 !== 32'd0) || (o_rdata2 !== 32'd9)) begin
            $display("FAIL: Register 0 protection");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Register 0 protection");
            pass_count = pass_count + 1;
        end

        // Test 5: Overwrite register 1 with 30
        i_wdata = 32'd30;
        i_waddr = 5'd1;
        i_raddr1 = 5'd1;

        @(posedge clk);
        #1;

        if (o_rdata1 !== 32'd30) begin
            $display("FAIL: Overwrite register 1");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Overwrite register 1");
            pass_count = pass_count + 1;
        end

        // Test 6: Write disabled
        i_reg_write = 0;
        i_wdata = 32'd50;
        i_waddr = 5'd1;

        @(posedge clk);
        #1;

        if (o_rdata1 !== 32'd30) begin
            $display("FAIL: Write disabled");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Write disabled");
            pass_count = pass_count + 1;
        end

        // Test 7: Read register 5 again
        i_raddr1 = 5'd5;
        i_raddr2 = 5'd1;
        #1;

        if ((o_rdata1 !== 32'd9) || (o_rdata2 !== 32'd30)) begin
            $display("FAIL: Reading stored values");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Reading stored values");
            pass_count = pass_count + 1;
        end

        // Final summary
        $display("--------------------------------");
        $display("REGISTER FILE TEST SUMMARY");
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