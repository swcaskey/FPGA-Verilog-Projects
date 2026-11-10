// Lab 6 IN-LAB, board 540.
// Six slots, each containing a 32-bit instruction.
module instruction_memory (
    input  logic        clk, rst,
    input  logic [2:0]  A_sw,
    input  logic [3:0]  beq_sw,
    output logic [31:0] RD
);
    // PRELAB - saved:
    // localparam logic [3:0] BEQ_DIGIT = 4'd0;

    // IN-LAB: board 540 uses MSB=5 and LSB=9
    // because the handout replaces a zero digit with 9.
    localparam logic [3:0] BEQ_DIGIT = 4'd9;

    logic [31:0] ins_regs [0:5];
    logic [2:0] internal_addr;

    always_comb begin
        internal_addr = 3'd0;

        if (A_sw < 3'd5)
            internal_addr = A_sw;
        else if ((A_sw == 3'd5) &&
                 (beq_sw == BEQ_DIGIT) &&
                 (ins_regs[5][15:0] >= 16'd1) &&
                 (ins_regs[5][15:0] <= 16'd4))
            internal_addr = ins_regs[5][2:0];

        // Unmatched BEQ or invalid slot: select no-op.
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_regs[0] <= 32'd0;

            /* PRELAB - saved instructions
            // LW: memory[R2 + 3] -> R1
            ins_regs[1] <=
                32'b100011_00010_00001_0000000000000011;

            // SW: R1 -> memory[R8 + 1]
            ins_regs[2] <=
                32'b101011_01000_00001_0000000000000001;

            // ADD: R3 + R4 -> R1
            ins_regs[3] <=
                32'b000000_00011_00100_00001_00000_100000;

            // SUB: R10 - R8 -> R1
            ins_regs[4] <=
                32'b000000_01010_01000_00001_00000_100010;

            // BEQ: target slot 1 (LW)
            ins_regs[5] <=
                32'b000000_00000_00000_0000000000000001;
            */

            // IN-LAB slot 1: ADD R9 + R2 -> R10
            // 9 + 2 = 11
            ins_regs[1] <=
                32'b000000_01001_00010_01010_00000_100000;

            // IN-LAB slot 2: SUB R5 - R3 -> R7
            // 5 - 3 = 2
            ins_regs[2] <=
                32'b000000_00101_00011_00111_00000_100010;

            // IN-LAB slot 3: LW memory[R0 + 5] -> R8
            // Loads 5 into R8.
            ins_regs[3] <=
                32'b100011_00000_01000_0000000000000101;

            // IN-LAB slot 4: SW R9 -> memory[R0 + 2]
            // Stores 9 in memory[2].
            ins_regs[4] <=
                32'b101011_00000_01001_0000000000000010;

            // IN-LAB slot 5: BEQ targets slot 2 (SUB).
            // Taken when beq_sw = 9.
            ins_regs[5] <=
                32'b000000_00000_00000_0000000000000010;

            RD <= 32'd0;
        end else begin
            RD <= ins_regs[internal_addr];
        end
    end
endmodule