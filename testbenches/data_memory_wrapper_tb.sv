module data_memory_wrapper_tb ();
 logic        clk; 
 logic        i_mem_read;
 logic        i_mem_write; 
 logic [31:0] i_addr; 
 logic [31:0] i_write_data; 
 logic [31:0] o_read_data;

 data_memory_wrapper u_data_memory_wrapper_1(
 .clk(clk), 
 .i_mem_read (i_mem_read),
 .i_mem_write(i_mem_write),
 .i_addr(i_addr), 
 .i_write_data(i_write_data),
 .o_read_data (o_read_data)
 );
 
 always #5 clk = ~clk;

 
 initial begin
 clk = 0;
 i_mem_read = 0;
 i_mem_write = 0;
 i_addr = 0;
 i_write_data = 0;
 
 #1;
 
 //testing write 75 in address 8 which corresponds to  mem[2]
 
i_mem_read = 1;
i_mem_write = 1;
i_addr = 32'd8;
i_write_data = 32'd75;

@(posedge clk);
#1;
if(o_read_data !== 32'd75)
$error("Error in write");
else
$display ("write works");

//testing if it will write if i_mem_write = 0;

i_mem_read = 1;
i_mem_write = 0;
i_addr = 32'd8;
i_write_data = 32'd90;

@(posedge clk);
#1;
if(o_read_data !== 32'd75)
$error("Error in write =0");
else
$display ("i_mem_write = 0 works");

//testing if it will read if i_mem_read = 0
i_mem_read = 0;
i_mem_write = 1;
i_addr = 32'd8;
i_write_data = 32'd90;

@(posedge clk);
#1;
if(o_read_data !== 32'b0)
$error("Error in read");
else
$display ("i_mem_read = 0 works");



$display("register_file test complete");
$finish;

end

endmodule







 