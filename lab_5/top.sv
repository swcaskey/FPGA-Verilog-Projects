// Single top-level module.
// rst is ACTIVE LOW. sw=1/2/3/4 selects ADD/SUB/LW/SW; 0 is idle.
// These four constants are the required PRELAB instructions.
module top (
    input  logic        clk, rst,
    input  logic [2:0]  sw,
    output logic [31:0] ALUResult,
    output logic [31:0] RD1, RD2,
    output logic [31:0] prode_register_file,
    output logic [31:0] prode,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    /* PRELAB - saved for later
	localparam logic [31:0] inst_1 =
		 32'b100100_00101_00100_00001_00000_000000;

	localparam logic [31:0] inst_2 =
		 32'b101100_01010_01000_00001_00000_000000;

	localparam logic [31:0] inst_3 =
		 32'b010101_00000_00001_0000000000000101;

	localparam logic [31:0] inst_4 =
		 32'b010100_00000_00110_0000000000000010;
	*/

	// IN-LAB - board 540
	// ADD: R5 + R2 -> R1, result 7
	localparam logic [31:0] inst_1 =
		 32'b100100_00101_00010_00001_00000_000000;

	// SUB: R5 - R3 -> R10, result 2
	localparam logic [31:0] inst_2 =
		 32'b101100_00101_00011_01010_00000_000000;

	// LW: memory[5] -> R1, result 5 (same as prelab)
	localparam logic [31:0] inst_3 =
		 32'b010101_00000_00001_0000000000000101;

	// SW: R0 -> memory[2], stores 0
	localparam logic [31:0] inst_4 =
		 32'b010100_00000_00000_0000000000000010;

    logic [31:0] inst_ex;
    logic        RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite;
    logic [2:0]  ALUControl;
    logic [4:0]  WriteReg;
    logic [31:0] SignImm, SrcB, ReadData, Result;

    always_comb begin
        case (sw)
            3'd1: inst_ex = inst_1;
            3'd2: inst_ex = inst_2;
            3'd3: inst_ex = inst_3;
            3'd4: inst_ex = inst_4;
            default: inst_ex = 32'd0;
        endcase
    end

    // The lab packs these control values directly into the six opcode bits.
    assign RegDst     = inst_ex[31];
    assign ALUSrc     = inst_ex[30];
    assign ALUControl = inst_ex[29:27];
    assign MemtoReg   = inst_ex[26];
    assign RegWrite   = (inst_ex[31:26] == 6'b100100) ||
                        (inst_ex[31:26] == 6'b101100) ||
                        (inst_ex[31:26] == 6'b010101);
    assign MemWrite   = (inst_ex[31:26] == 6'b010100);

    MUX_RegDst u_regdst (
        .RegDst(RegDst), .rt(inst_ex[20:16]),
        .rd(inst_ex[15:11]), .WriteReg(WriteReg)
    );
    register_file r_f (
        .clk(clk), .rst(rst),
        .A1(inst_ex[25:21]), .A2(inst_ex[20:16]), .A3(WriteReg),
        .WD3(Result), .WE3(RegWrite),
        .RD1(RD1), .RD2(RD2), .prode(prode_register_file)
    );
    sign_extend u_sign_extend (.Imm(inst_ex[15:0]), .SignImm(SignImm));
    MUX_ALUSrc u_alusrc (
        .ALUSrc(ALUSrc), .RD2(RD2), .SignImm(SignImm), .SrcB(SrcB)
    );
    ALU u_alu (
        .SrcA(RD1), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult)
    );
    data_memory d_m (
        .clk(clk), .rst(rst), .A(ALUResult), .WD(RD2), .WE(MemWrite),
        .RD(ReadData), .prode(prode)
    );
    MUX_MemtoReg u_memtoreg (
        .MemtoReg(MemtoReg), .ALUResult(ALUResult), .RD(ReadData),
        .MemtoReg_out(Result)
    );

    // Decimal register result on HEX2..0; memory[2] on HEX5..3.
    display u_register_display (
        .data_in(prode_register_file), .segments_ones(HEX0),
        .segments_tens(HEX1), .segments_hundreds(HEX2)
    );
    display u_memory_display (
        .data_in(prode), .segments_ones(HEX3),
        .segments_tens(HEX4), .segments_hundreds(HEX5)
    );
endmodule
