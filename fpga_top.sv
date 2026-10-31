// DE1-SoC wrapper for mips_single_cycle.
//
// KEY[0]  reset (active low)
// KEY[1]  step: each press runs one instruction (SW[9] down)
// SW[9]   up = run at about 6 Hz, down = step with KEY[1]
// SW[1:0] picks what HEX5-HEX0 show:
//         00  PC
//         01  last register write: HEX5-4 = register number, HEX3-0 = data[15:0]
//         10  last memory write:   HEX5-4 = address[7:0],    HEX3-0 = data[15:0]
//         11  instruction[23:0]
// LEDR[7:0] PC word index, LEDR[8] mem_write, LEDR[9] reg_write
//
// array_sum.hex ends with PC = 00002C and, on view 10, 10 0019 (25 at address 16).

module fpga_top #(
    parameter ISTRUCT_file  = "array_sum.hex",
    parameter RUN_DIV_BIT   = 22,  // 50 MHz / 2^23 = about 6 Hz
    parameter DEBOUNCE_BITS = 20   // sample KEY[1] about every 21 ms
) (
    input  logic       CLOCK_50,
    input  logic [1:0] KEY,
    input  logic [9:0] SW,
    output logic [9:0] LEDR,
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5
);

    logic        rst_n;
    logic        proc_clk;
    logic [23:0] div;
    logic [1:0]  key_sync;
    logic        step_level;

    logic [31:0] pc;
    logic [31:0] instruction;
    logic        reg_write;
    logic [4:0]  write_reg;
    logic [31:0] write_data;
    logic        mem_write;
    logic [31:0] alu_result;
    logic [31:0] mem_write_data;

    logic [4:0]  last_reg;
    logic [15:0] last_reg_data;
    logic [7:0]  last_mem_addr;
    logic [15:0] last_mem_data;
    logic [23:0] view;

    assign rst_n = KEY[0];


    // Processor clock
    // The switches are slow, so proc_clk comes from a register instead of a
    // clock enable. ASIC_PROJECT.sdc declares it as a generated clock.

    always_ff @(posedge CLOCK_50) begin
        div      <= div + 24'd1;
        key_sync <= {key_sync[0], ~KEY[1]};

        if (div[DEBOUNCE_BITS-1:0] == '0)
            step_level <= key_sync[1];

        proc_clk <= SW[9] ? div[RUN_DIV_BIT] : step_level;
    end


    // Processor

    mips_single_cycle #(
        .ISTRUCT_file(ISTRUCT_file)
    ) u_mips_single_cycle_1 (
        .clk              (proc_clk),
        .rst_n            (rst_n),
        .o_pc             (pc),
        .o_instruction    (instruction),
        .o_reg_write      (reg_write),
        .o_write_reg      (write_reg),
        .o_write_data     (write_data),
        .o_mem_write      (mem_write),
        .o_alu_result     (alu_result),
        .o_mem_write_data (mem_write_data)
    );


    // Remember the last writes so the result stays on the display

    always_ff @(posedge proc_clk or negedge rst_n) begin
        if (!rst_n) begin
            last_reg      <= 5'd0;
            last_reg_data <= 16'd0;
            last_mem_addr <= 8'd0;
            last_mem_data <= 16'd0;
        end else begin
            if (reg_write) begin
                last_reg      <= write_reg;
                last_reg_data <= write_data[15:0];
            end
            if (mem_write) begin
                last_mem_addr <= alu_result[7:0];
                last_mem_data <= mem_write_data[15:0];
            end
        end
    end


    // Display

    always_comb begin
        case (SW[1:0])
            2'b00:   view = pc[23:0];
            2'b01:   view = {3'b0, last_reg, last_reg_data};
            2'b10:   view = {last_mem_addr, last_mem_data};
            default: view = instruction[23:0];
        endcase
    end

    function automatic logic [6:0] seg7(input logic [3:0] digit);
        case (digit)
            4'h0: return 7'b1000000;
            4'h1: return 7'b1111001;
            4'h2: return 7'b0100100;
            4'h3: return 7'b0110000;
            4'h4: return 7'b0011001;
            4'h5: return 7'b0010010;
            4'h6: return 7'b0000010;
            4'h7: return 7'b1111000;
            4'h8: return 7'b0000000;
            4'h9: return 7'b0010000;
            4'hA: return 7'b0001000;
            4'hB: return 7'b0000011;
            4'hC: return 7'b1000110;
            4'hD: return 7'b0100001;
            4'hE: return 7'b0000110;
            default: return 7'b0001110;
        endcase
    endfunction

    assign HEX0 = seg7(view[3:0]);
    assign HEX1 = seg7(view[7:4]);
    assign HEX2 = seg7(view[11:8]);
    assign HEX3 = seg7(view[15:12]);
    assign HEX4 = seg7(view[19:16]);
    assign HEX5 = seg7(view[23:20]);

    assign LEDR = {reg_write, mem_write, pc[9:2]};

endmodule
