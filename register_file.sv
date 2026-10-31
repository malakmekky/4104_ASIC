module register_file (
    input logic clk,rst,
    input logic i_reg_write,
    input logic [4:0] i_raddr1,
    input logic [4:0] i_raddr2,
    input logic [4:0] i_waddr,
    input logic [31:0] i_wdata,
    output logic [31:0] o_rdata1,
    output logic [31:0] o_rdata2
);

    logic [31:0] regs [0:31];
	 


    always_ff @(posedge clk , negedge rst) begin
		if (!rst)
		begin
		for (int i = 0;i<32;i++)
		regs[i] <='b0;
		end
		else 
			begin
        if (i_reg_write && (i_waddr != 5'd0)) begin
            regs[i_waddr] <= i_wdata;
        end
    end
	end

    assign o_rdata1 = (i_raddr1 == 5'd0) ? 32'b0 : regs[i_raddr1];
    assign o_rdata2 = (i_raddr2 == 5'd0) ? 32'b0 : regs[i_raddr2];

endmodule