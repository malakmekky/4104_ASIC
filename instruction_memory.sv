module instruction_memory #(
    parameter Mem_DEPTH = 256,
    parameter ISTRUCT_file = "test_alu.hex"
)(
    input  logic [31:0] i_addr,
    output logic [31:0] o_instruction
);

    logic [31:0] mem [0:Mem_DEPTH-1];

    initial begin
        $readmemh(ISTRUCT_file, mem);
    end

    always_comb begin
        o_instruction = mem[i_addr[9:2]];
    end

endmodule