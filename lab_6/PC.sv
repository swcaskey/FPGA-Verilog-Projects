// Lab 6 IN-LAB TOP, board 540.
// Keep PC as the Quartus top-level entity.
// rst is ACTIVE LOW.
// First rising edge fetches; next rising edge executes.
module PC (
    input  logic        clk, rst,
    input  logic [2:0]  instruction_A,
    input  logic        RegWrite, MemWrite,
    input  logic [3:0]  beq_sw,
    output logic [13:0] reg_probe_segments,
    output logic [13:0] data_probe_segments,
    output logic [7:0]  reg_probe_value,
    output logic [7:0]  data_probe_value
);
    /* PRELAB - saved fixed probes
    localparam logic [4:0] REG_PROBE_ADDR = 5'd1;
    localparam logic [4:0] DATA_PROBE_ADDR = 5'd9;
    */

    // IN-LAB: memory probe always observes memory[2].
    localparam logic [4:0] DATA_PROBE_ADDR = 5'd2;

    // Register probe follows the register most recently written.
    // ADD -> R10; SUB/BEQ -> R7; LW -> R8.
    // SW, idle and unmatched BEQ preserve the register view.
    logic [4:0] reg_probe_addr;

    logic [31:0] instruction;
    logic [31:0] RD1, RD2, SignImm, SrcB;
    logic [31:0] ALUResult, ReadData, Result;
    logic [4:0] WriteReg;

    logic RegDst, ALUSrc, MemtoReg;
    logic valid_reg_write, valid_mem_write;
    logic [2:0] ALUControl;

    instruction_memory i_m (
        .clk(clk),
        .rst(rst),
        .A_sw(instruction_A),
        .beq_sw(beq_sw),
        .RD(instruction)
    );

    // Decode standard ADD, SUB, LW and SW instructions.
    always_comb begin
        RegDst = 1'b0;
        ALUSrc = 1'b0;
        MemtoReg = 1'b0;
        ALUControl = 3'b010;
        valid_reg_write = 1'b0;
        valid_mem_write = 1'b0;

        case (instruction[31:26])
            6'b100011: begin // LW
                ALUSrc = 1'b1;
                MemtoReg = 1'b1;
                valid_reg_write = 1'b1;
            end

            6'b101011: begin // SW
                ALUSrc = 1'b1;
                valid_mem_write = 1'b1;
            end

            6'b000000: begin
                RegDst = 1'b1;

                case (instruction[5:0])
                    6'b100000: begin // ADD
                        valid_reg_write = 1'b1;
                    end

                    6'b100010: begin // SUB
                        ALUControl = 3'b110;
                        valid_reg_write = 1'b1;
                    end

                    default: begin end
                endcase
            end

            default: begin end
        endcase
    end

    // Change the register view only when a register is written.
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            reg_probe_addr <= 5'd10;
        else if (RegWrite &&
                 valid_reg_write &&
                 (WriteReg != 5'd0))
            reg_probe_addr <= WriteReg;
    end

    MUX_RegDst u_regdst (
        .RegDst(RegDst),
        .rt(instruction[20:16]),
        .rd(instruction[15:11]),
        .WriteReg(WriteReg)
    );

    register_file r_f (
        .clk(clk),
        .rst(rst),
        .A1(instruction[25:21]),
        .A2(instruction[20:16]),
        .A3(WriteReg),

        // PRELAB: .probe_addr(REG_PROBE_ADDR)
        .probe_addr(reg_probe_addr),

        .WD3(Result),
        .WE3(RegWrite && valid_reg_write),
        .RD1(RD1),
        .RD2(RD2),
        .prode(reg_probe_value)
    );

    sign_extend u_sign_extend (
        .Imm(instruction[15:0]),
        .SignImm(SignImm)
    );

    MUX_ALUSrc u_alusrc (
        .ALUSrc(ALUSrc),
        .RD2(RD2),
        .SignImm(SignImm),
        .SrcB(SrcB)
    );

    ALU u_alu (
        .SrcA(RD1),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult)
    );

    data_memory d_m (
        .clk(clk),
        .rst(rst),
        .A(ALUResult),
        .WD(RD2),
        .WE(MemWrite && valid_mem_write),
        .probe_addr(DATA_PROBE_ADDR),
        .RD(ReadData),
        .prode(data_probe_value)
    );

    MUX_MemtoReg u_memtoreg (
        .MemtoReg(MemtoReg),
        .ALUResult(ALUResult),
        .RD(ReadData),
        .MemtoReg_out(Result)
    );

    display u_reg_display (
        .data_in(reg_probe_value),
        .segments(reg_probe_segments)
    );

    display u_data_display (
        .data_in(data_probe_value),
        .segments(data_probe_segments)
    );
endmodule