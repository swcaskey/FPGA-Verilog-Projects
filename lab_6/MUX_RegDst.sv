module MUX_RegDst (
    input  logic       RegDst,
    input  logic [4:0] rt, rd,
    output logic [4:0] WriteReg
);
    assign WriteReg = RegDst ? rd : rt;
endmodule
