module imm_extender_tb ();

logic [15:0] i_immediate;
logic        i_zero_extend; 
logic [31:0] o_immediate_ext;

imm_extender u_imm_extender_1 ( 
 .i_immediate(i_immediate),
 .i_zero_extend(i_zero_extend),
 .o_immediate_ext(o_immediate_ext)
 );
 
 
initial begin

//zero extend test for 3

 i_zero_extend= 1;
 i_immediate =16'd3;
 #5;
 if(o_immediate_ext !== 32'd3)
 $error("Error in zero extend");
else
$display ("zero extend works");

//zero extend test for -3 --> 1111111111111101 -->FFFD
#1;
 i_zero_extend= 1;
 i_immediate =16'hFFFD;
 #5;
 if(o_immediate_ext !== 32'h0000FFFD)
 $error("Error in zero extend -3");
else
$display ("zero extend works, -3");

//sign extend test for 3

 i_zero_extend= 0;
 i_immediate =16'd3;
 #5;
 if(o_immediate_ext !== 32'd3)
 $error("Error in sign extend");
else
$display ("sign extend works");

//sign extend test for -3
 i_zero_extend= 0;
 i_immediate =16'hFFFD;
 #5;
 if(o_immediate_ext !== 32'hFFFFFFFD)
 $error("Error in sign extend -3");
else
$display ("sign extend works, -3");




$display("imm_extender test complete");
$finish;

end

endmodule








 
 
 
 
 



