module MUX_MemtoReg (
    input  logic        MemtoReg,
    input  logic [31:0] ALUResult, RD,
    output logic [31:0] MemtoReg_out
);
    assign MemtoReg_out = MemtoReg ? RD : ALUResult;
endmodule
