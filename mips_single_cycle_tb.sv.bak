`timescale 1ns/1ps

module mips_single_cycle_tb;

    logic clk;
    logic rst_n;

    logic [31:0] pc_alu, instr_alu;
    logic [31:0] pc_mem, instr_mem;
    logic [31:0] pc_ctrl, instr_ctrl;
    logic [31:0] pc_sum, instr_sum;

    integer errors = 0;

    // ------------------------------------------
    // Processor instances
    // ------------------------------------------

    mips_single_cycle #(
        .ISTRUCT_file("test_alu.hex")
    ) dut_alu (
        .clk(clk),
        .rst_n(rst_n),
        .o_pc(pc_alu),
        .o_instruction(instr_alu)
    );

    mips_single_cycle #(
        .ISTRUCT_file("test_memory.hex")
    ) dut_mem (
        .clk(clk),
        .rst_n(rst_n),
        .o_pc(pc_mem),
        .o_instruction(instr_mem)
    );

    mips_single_cycle #(
        .ISTRUCT_file("test_control.hex")
    ) dut_ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .o_pc(pc_ctrl),
        .o_instruction(instr_ctrl)
    );

    mips_single_cycle #(
        .ISTRUCT_file("array_sum.hex")
    ) dut_sum (
        .clk(clk),
        .rst_n(rst_n),
        .o_pc(pc_sum),
        .o_instruction(instr_sum)
    );

    // ------------------------------------------
    // Clock generation
    // ------------------------------------------

    initial clk = 1'b0;
    always #5 clk = ~clk;

    // ------------------------------------------
    // Test sequence
    // ------------------------------------------

    initial begin

        $display("======================================");
        $display(" MIPS SINGLE-CYCLE PROCESSOR TEST");
        $display("======================================");

        // Reset processors
        rst_n = 1'b0;

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        // Let the programs execute
        repeat (100) @(posedge clk);
        #1;

        // ======================================
        // TEST 1: Arithmetic and Logic
        // ======================================

        $display("\n--- TEST 1: ALU ---");

        if (dut_alu.u_register_file_1.regs[1] !== 32'd7)
            begin
                $error("T1 R1 failed");
                errors = errors + 1;
            end
        else $display("T1 R1 passed");

        if (dut_alu.u_register_file_1.regs[2] !== 32'd6)
            begin
                $error("T1 R2 failed");
                errors = errors + 1;
            end
        else $display("T1 R2 passed");

        if (dut_alu.u_register_file_1.regs[3] !== 32'd10)
            begin
                $error("T1 R3 failed");
                errors = errors + 1;
            end
        else $display("T1 R3 passed");

        if (dut_alu.u_register_file_1.regs[4] !== 32'd4)
            begin
                $error("T1 R4 failed");
                errors = errors + 1;
            end
        else $display("T1 R4 passed");

        if (dut_alu.u_register_file_1.regs[5] !== 32'd3)
            begin
                $error("T1 R5 failed");
                errors = errors + 1;
            end
        else $display("T1 R5 passed");

        if (dut_alu.u_register_file_1.regs[6] !== 32'd7)
            begin
                $error("T1 R6 failed");
                errors = errors + 1;
            end
        else $display("T1 R6 passed");

        if (dut_alu.u_register_file_1.regs[7] !== 32'd1)
            begin
                $error("T1 R7 failed");
                errors = errors + 1;
            end
        else $display("T1 R7 passed");

        if (dut_alu.u_register_file_1.regs[8] !== 32'hFFFFFFFF)
            begin
                $error("T1 R8 failed");
                errors = errors + 1;
            end
        else $display("T1 R8 passed");

        if (dut_alu.u_register_file_1.regs[9] !== 32'h00008001)
            begin
                $error("T1 R9 failed");
                errors = errors + 1;
            end
        else $display("T1 R9 passed");

        // ======================================
        // TEST 2: Memory
        // ======================================

        $display("\n--- TEST 2: MEMORY ---");

        if (dut_mem.u_register_file_1.regs[1] !== 32'd64)
            begin
                $error("T2 R1 failed");
                errors = errors + 1;
            end
        else $display("T2 R1 passed");

        if (dut_mem.u_register_file_1.regs[2] !== 32'd42)
            begin
                $error("T2 R2 failed");
                errors = errors + 1;
            end
        else $display("T2 R2 passed");

        if (dut_mem.u_register_file_1.regs[3] !== 32'd42)
            begin
                $error("T2 R3 failed");
                errors = errors + 1;
            end
        else $display("T2 R3 passed");

        if (dut_mem.u_data_memory_1.mem[16] !== 32'd42)
            begin
                $error("T2 memory word 16 failed");
                errors = errors + 1;
            end
        else $display("T2 memory word 16 passed");

        // ======================================
        // TEST 3: Branches and Jumps
        // ======================================

        $display("\n--- TEST 3: CONTROL ---");

        if (dut_ctrl.u_register_file_1.regs[1] !== 32'd5)
            begin
                $error("T3 R1 failed");
                errors = errors + 1;
            end
        else $display("T3 R1 passed");

        if (dut_ctrl.u_register_file_1.regs[2] !== 32'd5)
            begin
                $error("T3 R2 failed");
                errors = errors + 1;
            end
        else $display("T3 R2 passed");

        if (dut_ctrl.u_register_file_1.regs[3] !== 32'd2)
            begin
                $error("T3 R3 failed");
                errors = errors + 1;
            end
        else $display("T3 R3 passed");

        // ======================================
        // TEST 4: Array Sum
        // ======================================

        $display("\n--- TEST 4: ARRAY SUM ---");

        if (dut_sum.u_register_file_1.regs[1] !== 32'd16)
            begin
                $error("T4 R1 failed");
                errors = errors + 1;
            end
        else $display("T4 R1 passed");

        if (dut_sum.u_register_file_1.regs[2] !== 32'd0)
            begin
                $error("T4 R2 failed");
                errors = errors + 1;
            end
        else $display("T4 R2 passed");

        if (dut_sum.u_register_file_1.regs[3] !== 32'd25)
            begin
                $error("T4 R3 failed");
                errors = errors + 1;
            end
        else $display("T4 R3 passed");

        if (dut_sum.u_register_file_1.regs[4] !== 32'd10)
            begin
                $error("T4 R4 failed");
                errors = errors + 1;
            end
        else $display("T4 R4 passed");

        if (dut_sum.u_register_file_1.regs[7] !== 32'd0)
            begin
                $error("T4 R7 failed");
                errors = errors + 1;
            end
        else $display("T4 R7 passed");

        if (dut_sum.u_data_memory_1.mem[4] !== 32'd25)
            begin
                $error("T4 memory word 4 failed");
                errors = errors + 1;
            end
        else $display("T4 memory word 4 passed");

        // ======================================
        // Final result
        // ======================================

        $display("\n======================================");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);

        $display("======================================");

        $finish;
    end

endmodule