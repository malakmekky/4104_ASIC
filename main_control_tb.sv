
`timescale 1ns/1ps

module main_control_tb;

    logic [5:0] i_opcode;
    logic o_reg_dst, o_reg_write, o_alu_src, o_mem_read, o_mem_write;
    logic o_mem_to_reg, o_branch, o_jump, o_imm_zero_ext;
    logic [1:0] o_alu_op;

    int errors = 0;
    int checks = 0;

    main_control dut (
        .i_opcode (i_opcode),
        .o_reg_dst (o_reg_dst),
        .o_reg_write (o_reg_write),
        .o_alu_src (o_alu_src),
        .o_mem_read (o_mem_read),
        .o_mem_write (o_mem_write),
        .o_mem_to_reg (o_mem_to_reg),
        .o_branch (o_branch),
        .o_jump (o_jump),
        .o_imm_zero_ext(o_imm_zero_ext),
        .o_alu_op (o_alu_op)
    );

    logic [10:0] ctrl;
    assign ctrl = {o_reg_dst, o_reg_write, o_alu_src, o_mem_read, o_mem_write, o_mem_to_reg, o_branch, o_jump, o_imm_zero_ext, o_alu_op};

    task automatic check(input logic [5:0] op, input logic [10:0] expected, input string tag);
        i_opcode = op;
        #1;
        checks++;
        if ($isunknown(ctrl) || ctrl !== expected) begin
            errors++;
            $display("FAIL [%s] opcode=%b ctrl=%b (exp %b)", tag, op, ctrl, expected);
        end
    endtask

    function automatic bit is_supported(input logic [5:0] op);
        return (op == 6'b000000) || (op == 6'b001000) || (op == 6'b001100) ||
               (op == 6'b100011) || (op == 6'b101011) || (op == 6'b000100) ||
               (op == 6'b000010);
    endfunction

    initial begin
        $display("main control table");
        check(6'b000000, 11'b1_1_0_0_0_0_0_0_0_10, "R-type");
        check(6'b001000, 11'b0_1_1_0_0_0_0_0_0_00, "addi");
        check(6'b001100, 11'b0_1_1_0_0_0_0_0_1_11, "andi");
        check(6'b100011, 11'b0_1_1_1_0_1_0_0_0_00, "lw");
        check(6'b101011, 11'b0_0_1_0_1_0_0_0_0_00, "sw");
        check(6'b000100, 11'b0_0_0_0_0_0_1_0_0_01, "beq");
        check(6'b000010, 11'b0_0_0_0_0_0_0_1_0_00, "j");

        $display("unsupported opcodes -> safe defaults.");
        for (int op = 0; op < 64; op++)
            if (!is_supported(op[5:0]))
                check(op[5:0], 11'b0, "unsupported");

        if (errors == 0)
            $display("main_control_tb: PASS (%0d checks)", checks);
        else
            $display("main_control_tb: FAIL (%0d errors / %0d checks)", errors, checks);
        $finish;
    end

endmodule
