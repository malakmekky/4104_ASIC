`timescale 1ns/1ps

module alu_tb();

    logic [31:0] i_operand_a;
    logic [31:0] i_operand_b;
    logic [2:0] i_alu_ctrl;
    logic [31:0] o_result;
    logic o_zero;
    //connecting the wires
    alu u_alu_1 (
        .i_operand_a (i_operand_a),
        .i_operand_b (i_operand_b),
        .i_alu_ctrl (i_alu_ctrl),
        .o_result (o_result),
        .o_zero(o_zero)
    );
    
    int errors = 0;
    int checks = 0;

    //options of operations (last 3 are unused codes, alu should give 0)
    logic [2:0] ops [8] = '{3'b000, 3'b001, 3'b010, 3'b110, 3'b111, 3'b011, 3'b100, 3'b101};

    //edge case operands, tried first for every operation
    logic [31:0] a_edge [12] = '{32'hFFFF_0000, 32'hAAAA_AAAA, 32'h0000_0000, 32'hFFFF_FFFF,
                                 32'h7FFF_FFFF, 32'h8000_0000, 32'h0000_002A, 32'h0000_0003,
                                 32'h0000_0001, 32'h8000_0000, 32'hFFFF_FFFE, 32'h0000_0005};
    logic [31:0] b_edge [12] = '{32'h0F0F_0F0F, 32'h5555_5555, 32'h0000_0000, 32'h0000_0001,
                                 32'h0000_0001, 32'h0000_0001, 32'h0000_002A, 32'h0000_000A,
                                 32'hFFFF_FFFF, 32'h7FFF_FFFF, 32'hFFFF_FFFF, 32'h0000_0007};

    initial begin
        logic [31:0] a, b, expected;

        $display("12 edge + 1000 random operands x 8 ops.");
        for (int i = 0; i < 8; i++) begin
            for (int n = 0; n < 1012; n++) begin
                if (n < 12) begin
                    a = a_edge[n];
                    b = b_edge[n];
                end else begin
                    a = $random;
                    b = $random;
                end

                //return of alu
                i_operand_a = a;
                i_operand_b = b;
                i_alu_ctrl = ops[i];
                #1; //wait 1ns

                //a OPERATION b
                case (ops[i])
                    3'b000: expected = a & b;
                    3'b001: expected = a | b;
                    3'b010: expected = a + b;
                    3'b110: expected = a - b;
                    3'b111: expected = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                    default: expected = 32'd0;
                endcase

                checks++;
                if (o_result === expected && o_zero === (expected == 32'd0)) begin
                    //all is good
                end else begin
                    errors++;
                    $display("FAIL a=%h b=%h ctrl=%b -> %h zero=%b (exp %h zero=%b)", a, b, ops[i], o_result, o_zero, expected, (expected == 32'd0));
                end
            end
        end

        if (errors == 0)
            $display("alu_tb: PASS (%0d checks)", checks);
        else
            $display("alu_tb: FAIL (%0d errors / %0d checks)", errors, checks);
        $finish;
    end

endmodule
