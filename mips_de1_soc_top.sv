
module mips_de1_soc_top (
    input  logic        CLOCK_50,
    input  logic [3:0]  KEY,

    output logic [31:0] o_pc,
    output logic [31:0] o_instruction
);

    // MIPS processor instance
    mips_single_cycle #(
        .ISTRUCT_file("test_alu.hex")
    ) u_mips (
        .clk           (CLOCK_50),
        .rst_n         (KEY[0]),
        .o_pc          (o_pc),
        .o_instruction (o_instruction)
    );

endmodule
