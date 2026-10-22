module register_file (
 input logic clk,
 input logic i_reg_write,
 input logic [4:0] i_raddr1,
 input logic [4:0] i_raddr2,
 input logic [4:0] i_waddr,
 input logic [31:0] i_wdata,
 output logic [31:0] o_rdata1,
 output logic [31:0] o_rdata2
);

logic [31:0] register [31:0];

always_ff @(posedge clk)

begin 

if((i_reg_write) && (i_waddr !=5'd0))

register[i_waddr] <= i_wdata;

end


always_comb begin

if(i_raddr1 == 5'd0)

o_rdata1 = 32'b0;

else
o_rdata1 = register[i_raddr1];


if(i_raddr2 == 5'd0)

o_rdata2 = 32'b0;

else
o_rdata2 = register[i_raddr2];


end

endmodule

