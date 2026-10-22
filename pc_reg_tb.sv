module pc_reg_tb();
logic clk;
logic rst_n;
logic [31:0] i_next_pc;
logic [31:0] o_pc;


pc_reg u_pc_reg_1(
.clk(clk),
.rst_n(rst_n),
.i_next_pc(i_next_pc),
.o_pc(o_pc)
);

always #5 clk = ~clk;

initial
begin 

clk=0;
rst_n=1;
i_next_pc = 32'h00000004;

 
 
 //reset test
 #1;
rst_n=1;
#1;
if(  o_pc != 32'h00000000)
$error("Error is reset");
else
$display ("reset works");

//load test
#1;

rst_n=1;
i_next_pc = 32'h00000008;

 
 @(posedge clk);
#1;
if(  o_pc != 32'h00000008)
$error("Error in load 0%d",  o_pc);
else
$display ("load works");


//hold test

#1;
i_next_pc = 32'h0000000C;
#1;


if(  o_pc != 32'h00000008)
$error("Error in hold");
else
$display ("hold works");






$display("pc_reg test complete");
$finish;

end

endmodule




