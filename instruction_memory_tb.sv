`timescale 1ns/1ps

module instruction_memory_tb();

    logic [31:0] i_addr;
    logic [31:0] o_instruction;

    instruction_memory #(.Mem_DEPTH(8)) u_instruction_memory (
        .i_addr(i_addr),
        .o_instruction(o_instruction)
    );

    initial begin
        // Test 1
        i_addr = 32'd0;
        #10;

        if (o_instruction !== 32'h20010007)
            $error("Test 1 failed: expected 20010007, got %h", o_instruction);
        else
            $display("Test 1 passed: address 0");

        // Test 2
        i_addr = 32'd4;
        #10;

        if (o_instruction !== 32'h20020003)
            $error("Test 2 failed: expected 20020003, got %h", o_instruction);
        else
            $display("Test 2 passed: address 4");

        // Test 3
        i_addr = 32'd8;
        #10;

        if (o_instruction !== 32'h00221820)
            $error("Test 3 failed: expected 00221820, got %h", o_instruction);
        else
            $display("Test 3 passed: address 8");

        // Test 4
        i_addr = 32'd12;
        #10;

        if (o_instruction !== 32'h00222022)
            $error("Test 4 failed: expected 00222022, got %h", o_instruction);
        else
            $display("Test 4 passed: address 12");

        $display("Instruction memory test complete");
        $finish;
    end

endmodule