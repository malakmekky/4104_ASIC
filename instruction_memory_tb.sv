`timescale 1ns/1ps

module instruction_memory_tb();

    logic [31:0] i_addr;
    logic [31:0] o_instruction;

    integer pass_count;
    integer fail_count;

    instruction_memory #(.Mem_DEPTH(256), .ISTRUCT_file("test_alu.hex")) u_instruction_memory (
        .i_addr(i_addr),
        .o_instruction(o_instruction)
    );

    initial begin

        pass_count = 0;
        fail_count = 0;
        i_addr = 32'd0;

        // Test 1: Read instruction at address 0
        #10;

        if (o_instruction !== 32'h20010007) begin
            $display("FAIL: Address 0. Expected 20010007, got %h",
                     o_instruction);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Address 0");
            pass_count = pass_count + 1;
        end

        // Test 2: Read instruction at address 4
        i_addr = 32'd4;
        #10;

        if (o_instruction !== 32'h20020003) begin
            $display("FAIL: Address 4. Expected 20020003, got %h",
                     o_instruction);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Address 4");
            pass_count = pass_count + 1;
        end

        // Test 3: Read instruction at address 8
        i_addr = 32'd8;
        #10;

        if (o_instruction !== 32'h00221820) begin
            $display("FAIL: Address 8. Expected 00221820, got %h",
                     o_instruction);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Address 8");
            pass_count = pass_count + 1;
        end

        // Test 4: Read instruction at address 12
        i_addr = 32'd12;
        #10;

        if (o_instruction !== 32'h00222022) begin
            $display("FAIL: Address 12. Expected 00222022, got %h",
                     o_instruction);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Address 12");
            pass_count = pass_count + 1;
        end

        // Final summary
        $display("--------------------------------");
        $display("INSTRUCTION MEMORY TEST SUMMARY");
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