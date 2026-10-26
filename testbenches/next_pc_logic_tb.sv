module next_pc_logic_tb();

logic [31:0] i_pc_plus_4;
logic [31:0] i_branch_target;
logic [31:0] i_jump_target;
logic i_branch_taken;
logic i_jump;
logic [31:0] o_next_pc;

next_pc_logic u_next_pc_logic_1(

.i_pc_plus_4(i_pc_plus_4),
.i_branch_target(i_branch_target),
.i_branch_taken(i_branch_taken),
.i_jump(i_jump),
.o_next_pc(o_next_pc)
);

initial begin 
i_pc_plus_4 = 32'd104;
i_branch_target = 32'd200;
i_jump_target= 32'd500;

#5;

//normal excution

i_branch_taken =0;
i_jump=0;
#5;
if(o_next_pc != 32'd104)
$error("Error in normal excution");
else
$display ("normal excution works");



//branch test


i_branch_taken =1;
i_jump=0;
#5;
if(o_next_pc != 32'd200)
$error("Error in branch");
else
$display ("branch works");


//jump test


i_branch_taken =0;
i_jump=1;
#5;
if(o_next_pc != 32'd500)
$error("Error in jump");
else
$display ("jump works");



//priority test jump

i_branch_taken =1;
i_jump=1;
#5;
if(o_next_pc != 32'd500)
$error("Error in jump priority");
else
$display ("jump priority works");



$display("next_pc_logic_tb complete");
$finish;

end

endmodule









