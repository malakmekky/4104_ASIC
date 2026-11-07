module data_memory_wrapper_tb();

    logic        clk;
    logic        i_mem_read;
    logic        i_mem_write;
    logic [31:0] i_addr;
    logic [31:0] i_write_data;
    logic [31:0] o_read_data;

    integer pass_count;
    integer fail_count;

    data_memory_wrapper u_data_memory_wrapper_1 (
        .clk(clk),
        .i_mem_read(i_mem_read),
        .i_mem_write(i_mem_write),
        .i_addr(i_addr),
        .i_write_data(i_write_data),
        .o_read_data(o_read_data)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        i_mem_read = 0;
        i_mem_write = 0;
        i_addr = 0;
        i_write_data = 0;

        pass_count = 0;
        fail_count = 0;

        #1;

        // Test 1: Write 75 to address 8 (mem[2])
        i_mem_read = 1;
        i_mem_write = 1;
        i_addr = 32'd8;
        i_write_data = 32'd75;

        @(posedge clk);
        #1;

        if (o_read_data !== 32'd75) begin
            $display("FAIL: Write 75 to address 8");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Write 75 to address 8");
            pass_count = pass_count + 1;
        end

        // Test 2: Writing disabled
        i_mem_read = 1;
        i_mem_write = 0;
        i_addr = 32'd8;
        i_write_data = 32'd90;

        @(posedge clk);
        #1;

        if (o_read_data !== 32'd75) begin
            $display("FAIL: Write disabled");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Write disabled");
            pass_count = pass_count + 1;
        end

        // Test 3: Reading disabled
        i_mem_read = 0;
        i_mem_write = 1;
        i_addr = 32'd8;
        i_write_data = 32'd90;

        @(posedge clk);
        #1;

        if (o_read_data !== 32'd0) begin
            $display("FAIL: Read disabled");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Read disabled");
            pass_count = pass_count + 1;
        end

        // Test 4: Read the newly written value
        i_mem_read = 1;
        i_mem_write = 0;
        i_addr = 32'd8;

        #1;

        if (o_read_data !== 32'd90) begin
            $display("FAIL: Read updated value");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Read updated value");
            pass_count = pass_count + 1;
        end

        // Test 5: Write a value to another address
        i_mem_read = 1;
        i_mem_write = 1;
        i_addr = 32'd12;
        i_write_data = 32'd120;

        @(posedge clk);
        #1;

        if (o_read_data !== 32'd120) begin
            $display("FAIL: Write to address 12");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Write to address 12");
            pass_count = pass_count + 1;
        end

        // Test 6: Check that the first address still contains 90
        i_mem_read = 1;
        i_mem_write = 0;
        i_addr = 32'd8;

        #1;

        if (o_read_data !== 32'd90) begin
            $display("FAIL: Previous memory value retained");
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Previous memory value retained");
            pass_count = pass_count + 1;
        end

        // Final summary
        $display("--------------------------------");
        $display("DATA MEMORY TEST SUMMARY");
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