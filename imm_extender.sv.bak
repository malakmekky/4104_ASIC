module imm_extender ( 
input  logic [15:0] i_immediate, 
input  logic        i_zero_extend, 
output logic [31:0] o_immediate_ext 
); 

always_comb begin

if(i_zero_extend)
o_immediate_ext = {16'b0,i_immediate};
else
o_immediate_ext = {{16{i_immediate[15]}},i_immediate};
end

endmodule


