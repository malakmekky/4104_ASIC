
`timescale 1ns/1ps

module register_file_tb;

    logic clk;
    logic i_reg_write;
    logic [4:0] i_raddr1, i_raddr2, i_waddr;
    logic [31:0] i_wdata;
    logic [31:0] o_rdata1, o_rdata2;

    logic [31:0] ref_regs [0:31]; 
    int errors = 0;
    int checks = 0;

    register_file dut (
        .clk (clk),
        .i_reg_write(i_reg_write),
        .i_raddr1 (i_raddr1),
        .i_raddr2 (i_raddr2),
        .i_waddr (i_waddr),
        .i_wdata (i_wdata),
        .o_rdata1 (o_rdata1),
        .o_rdata2 (o_rdata2)
    );

    // 10 ns clock
    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic check_read(input logic [4:0] a1, input logic [4:0] a2, input string tag);
        logic [31:0] exp1, exp2;
        i_raddr1 = a1;
        i_raddr2 = a2;
        #1; 
        exp1 = ref_regs[a1];
        exp2 = ref_regs[a2];
        checks++;
        if (o_rdata1 !== exp1 || o_rdata2 !== exp2) begin
            errors++;
            $display("FAIL [%s] rd1 R%0d=%h (exp %h) | rd2 R%0d=%h (exp %h)",
                     tag, a1, o_rdata1, exp1, a2, o_rdata2, exp2);
        end
    endtask

    task automatic do_write(input logic we, input logic [4:0] wa, input logic [31:0] wd);
        @(negedge clk);
        i_reg_write = we;
        i_waddr     = wa;
        i_wdata     = wd;
        @(posedge clk);
        if (we && wa != 5'd0) ref_regs[wa] = wd;
        #1;
        @(negedge clk);
        i_reg_write = 1'b0;
    endtask

    initial begin
        i_reg_write = 1'b0;
        i_raddr1 = '0; i_raddr2 = '0; i_waddr = '0; i_wdata = '0;
        for (int r = 0; r < 32; r++) ref_regs[r] = 32'b0;

        $display("testing write/read all registers.");
        for (int r = 0; r < 32; r++)
            do_write(1'b1, r[4:0], 32'hA5A5_0000 | (r << 8) | r);
        for (int r = 0; r < 32; r++)
            check_read(r[4:0], 5'(31 - r), "write/read all");

        $display("testing R0 writes ignored.");
        do_write(1'b1, 5'd0, 32'hFFFF_FFFF);
        check_read(5'd0, 5'd0, "R0 after write");
        checks++;
        if (o_rdata1 !== 32'b0 || o_rdata2 !== 32'b0) begin
            errors++;
            $display("FAIL [R0 explicit] rd1=%h rd2=%h", o_rdata1, o_rdata2);
        end

        $display("testing write enable low.");
        do_write(1'b0, 5'd7, 32'hDEAD_BEEF);
        check_read(5'd7, 5'd7, "we=0 hold");

        $display("testing synchronous write timing.");
        @(negedge clk);
        i_raddr1    = 5'd9;
        i_reg_write = 1'b1;
        i_waddr     = 5'd9;
        i_wdata     = 32'h1234_5678;
        #1;
        checks++;
        if (o_rdata1 !== ref_regs[9]) begin
            errors++;
            $display("FAIL [sync write] R9 changed before clock edge: %h", o_rdata1);
        end
        @(posedge clk); #1;
        ref_regs[9] = 32'h1234_5678;
        checks++;
        if (o_rdata1 !== 32'h1234_5678) begin
            errors++;
            $display("FAIL [sync write] R9 not updated after edge: %h", o_rdata1);
        end
        @(negedge clk);
        i_reg_write = 1'b0;

        $display("testing asynchronous read.");
        @(negedge clk);
        for (int r = 0; r < 32; r++) begin
            logic [4:0] a2;
            a2 = 5'(r + 1);
            i_raddr1 = r[4:0];
            i_raddr2 = a2;
            #0.1;  
            checks++;
            if (o_rdata1 !== ref_regs[r] || o_rdata2 !== ref_regs[a2]) begin
                errors++;
                $display("FAIL [async read] R%0d/R%0d rd1=%h (exp %h) rd2=%h (exp %h)",
                         r, a2, o_rdata1, ref_regs[r], o_rdata2, ref_regs[a2]);
            end
        end
        $display("testing 2000 random cycles.");
        for (int n = 0; n < 2000; n++) begin
            do_write($urandom_range(0, 1), 5'($urandom), $urandom);
            check_read(5'($urandom), 5'($urandom), "random");
        end

        if (errors == 0)
            $display("register_file_tb: PASS (%0d checks)", checks);
        else
            $display("register_file_tb: FAIL (%0d errors / %0d checks)", errors, checks);
        $finish;
    end

endmodule
