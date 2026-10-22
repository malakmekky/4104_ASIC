module pc_reg (
 input logic clk,
 input logic rst_n,
 input logic [31:0] i_next_pc,
 output logic [31:0] o_pc
);

always_ff @(posedge clk or negedge rst_n)
 begin 
 if(!rst_n)
 o_pc <= 32'b0;
 else
 o_pc <= i_next_pc;
 end
 
 endmodule