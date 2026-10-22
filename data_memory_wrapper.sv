module data_memory_wrapper ( 
input  logic        clk, 
input  logic        i_mem_read, 
input  logic        i_mem_write, 
input  logic [31:0] i_addr, 
input  logic [31:0] i_write_data, 
output logic [31:0] o_read_data 
);

logic [31:0] mem [0 :255];

always_ff @(posedge clk)
begin
if(i_mem_write)
 mem[i_addr[9:2]]  <= i_write_data;
 end
 
 
always_comb begin
if(i_mem_read)
o_read_data = mem[i_addr[9:2]];
else
o_read_data = 32'b0;


end 
endmodule
 
