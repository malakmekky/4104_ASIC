
`timescale 1ns/1ps

module imm_extender_tb;

    logic [15:0] i_immediate;
    logic i_zero_extend;
    logic [31:0] o_immediate_ext;

    int errors = 0;
    int checks = 0;

    imm_extender dut (
        .i_immediate (i_immediate),
        .i_zero_extend (i_zero_extend),
        .o_immediate_ext(o_immediate_ext)
    );

    task automatic check(input logic [15:0] imm, input logic zext, input logic [31:0] expected, input string tag);
        i_immediate = imm;
        i_zero_extend = zext;
        #1;
        checks++;
        if (o_immediate_ext !== expected) begin
            errors++;
            $display("FAIL [%s] imm=%h zext=%b -> %h (exp %h)", tag, imm, zext, o_immediate_ext, expected);
        end
    endtask

    initial begin
        $display("directed cases.");
        check(16'h0007, 1'b0, 32'h0000_0007, "addi R1,R0,7");
        check(16'hFFFF, 1'b0, 32'hFFFF_FFFF, "addi R8,R0,-1 (sign)");
        check(16'h8001, 1'b1, 32'h0000_8001, "andi R9,R8,0x8001 (zero)");
        check(16'h8001, 1'b0, 32'hFFFF_8001, "0x8001 sign extended");
        check(16'h0006, 1'b1, 32'h0000_0006, "andi R2,R1,6");
        check(16'h0010, 1'b0, 32'h0000_0010, "sw R3,16(R0)");
        check(16'h0000, 1'b0, 32'h0000_0000, "zero (sign)");
        check(16'h0000, 1'b1, 32'h0000_0000, "zero (zero)");
        check(16'h7FFF, 1'b0, 32'h0000_7FFF, "max positive (sign)");
        check(16'h8000, 1'b0, 32'hFFFF_8000, "min negative (sign)");
        check(16'h8000, 1'b1, 32'h0000_8000, "0x8000 (zero)");
        check(16'hFFFF, 1'b1, 32'h0000_FFFF, "0xFFFF (zero)");

        $display("exhaustive: 65536 x 2 modes.");
        for (int v = 0; v < 65536; v++) begin
            check(v[15:0], 1'b0, {{16{v[15]}}, v[15:0]}, "exh sign");
            check(v[15:0], 1'b1, {16'b0,       v[15:0]}, "exh zero");
        end

        if (errors == 0)
            $display("imm_extender_tb: PASS (%0d checks)", checks);
        else
            $display("imm_extender_tb: FAIL (%0d errors / %0d checks)", errors, checks);
        $finish;
    end

endmodule
