module mips_single_cycle #(
    parameter ISTRUCT_file = "test_alu.hex"
) (
    input  logic        clk,
    input  logic        rst_n,
    output logic [31:0] o_pc,
    output logic [31:0] o_instruction
);

    // Main control signals
    logic       reg_dst;
    logic       reg_write;
    logic       alu_src;
    logic       mem_read;
    logic       mem_write;
    logic       mem_to_reg;
    logic       branch;
    logic       jump;
    logic       imm_zero_ext;
    logic [1:0] alu_op;
    logic [2:0] alu_ctrl;

    // Instruction fields
    logic [5:0]  opcode;
    logic [4:0]  rs;
    logic [4:0]  rt;
    logic [4:0]  rd;
    logic [5:0]  funct;
    logic [15:0] immediate;

    // Register file signals
    logic [4:0]  write_reg;
    logic [31:0] reg_data1;
    logic [31:0] reg_data2;
    logic [31:0] write_data;

    // Immediate and ALU signals
    logic [31:0] immediate_ext;
    logic [31:0] alu_operand_b;
    logic [31:0] alu_result;
    logic        alu_zero;

    // Data memory signal
    logic [31:0] mem_read_data;

    // PC and branch/jump signals
    logic [31:0] next_pc;
    logic [31:0] pc_plus_4;
    logic [31:0] branch_target;
    logic [31:0] jump_target;
    logic        branch_taken;


    
    // Program Counter
    

    pc_reg u_pc_reg_1 (
        .clk       (clk),
        .rst_n     (rst_n),
        .i_next_pc (next_pc),
        .o_pc      (o_pc)
    );


    // 2. Instruction Memory

    instruction_memory #(
       .Mem_DEPTH(256),
		 .ISTRUCT_file(ISTRUCT_file)
    ) u_instruction_memory (
        .i_addr        (o_pc),
        .o_instruction (o_instruction)
    );


    // 3.  Instruction Fields

    assign opcode    = o_instruction[31:26];
    assign rs        = o_instruction[25:21];
    assign rt        = o_instruction[20:16];
    assign rd        = o_instruction[15:11];
    assign immediate = o_instruction[15:0];
    assign funct     = o_instruction[5:0];


    // 4. Main Control Unit

    main_control u_main_control_1 (
        .i_opcode       (opcode),
        .o_reg_dst      (reg_dst),
        .o_reg_write    (reg_write),
        .o_alu_src      (alu_src),
        .o_mem_read     (mem_read),
        .o_mem_write    (mem_write),
        .o_mem_to_reg   (mem_to_reg),
        .o_branch       (branch),
        .o_jump         (jump),
        .o_imm_zero_ext (imm_zero_ext),
        .o_alu_op       (alu_op)
    );


    // 5. Register Destination MUX
    // choosing R type or I type

    assign write_reg = reg_dst ? rd : rt;


    
    // 6. Register File

    register_file u_register_file_1 (
        .clk         (clk),
        .i_reg_write (reg_write),
        .i_raddr1    (rs),
        .i_raddr2    (rt),
        .i_waddr     (write_reg),
        .i_wdata     (write_data),
        .o_rdata1    (reg_data1),
        .o_rdata2    (reg_data2),
		  .rst(rst_n)
    );


    // 7. Immediate Extender

    imm_extender u_imm_extender_1 (
        .i_immediate     (immediate),
        .i_zero_extend   (imm_zero_ext),
        .o_immediate_ext (immediate_ext)
    );


    // 8. ALU Source MUX

    assign alu_operand_b = alu_src ? immediate_ext : reg_data2;


    // 9. ALU Control Unit

    alu_control u_alu_control_1 (
        .i_alu_op   (alu_op),
        .i_funct    (funct),
        .o_alu_ctrl (alu_ctrl)
    );


    // 10. Arithmetic Logic Unit

    alu u_alu_1 (
        .i_operand_a (reg_data1),
        .i_operand_b (alu_operand_b),
        .i_alu_ctrl  (alu_ctrl),
        .o_result    (alu_result),
        .o_zero      (alu_zero)
    );


    // 11. Data Memory

    data_memory_wrapper u_data_memory_1 (
        .clk          (clk),
        .i_mem_read   (mem_read),
        .i_mem_write  (mem_write),
        .i_addr       (alu_result),
        .i_write_data (reg_data2),
        .o_read_data  (mem_read_data)
    );


    // 12. Writeback MUX

    assign write_data = mem_to_reg ? mem_read_data : alu_result;


    // 13. Branch and Jump Target Generation

    assign pc_plus_4 = o_pc + 32'd4;

    // Sign-extend the branch offset and convert words to bytes
    assign branch_target =
        pc_plus_4 + ({{16{immediate[15]}}, immediate} << 2);

    // Construct the MIPS jump target address
    assign jump_target =
        {pc_plus_4[31:28], o_instruction[25:0], 2'b00};

    // Branch is taken when the branch instruction compares equal
    assign branch_taken = branch & alu_zero;


    // 14. Next-PC Logic

    next_pc_logic u_next_pc_logic_1 (
        .i_pc_plus_4     (pc_plus_4),
        .i_branch_target (branch_target),
        .i_jump_target   (jump_target),
        .i_branch_taken  (branch_taken),
        .i_jump          (jump),
        .o_next_pc       (next_pc)
    );

endmodule