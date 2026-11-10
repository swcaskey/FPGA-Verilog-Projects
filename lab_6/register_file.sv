// Lab 6: 32 locations x 8 bits. Reset sets rf_regs[i] = i.
// Read ports are zero-extended for the reused 32-bit ALU/MUX modules.
module register_file (
    input  logic        clk, rst,
    input  logic [4:0]  A1, A2, A3, probe_addr,
    input  logic [31:0] WD3,
    input  logic        WE3,
    output logic [31:0] RD1, RD2,
    output logic [7:0]  prode
);
    logic [7:0] rf_regs [0:31];
    integer i;
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1)
                rf_regs[i] <= i[7:0];
        end else if (WE3 && (A3 != 5'd0)) begin
            rf_regs[A3] <= WD3[7:0];
        end
    end
    assign RD1 = {24'd0, rf_regs[A1]};
    assign RD2 = {24'd0, rf_regs[A2]};
    assign prode = rf_regs[probe_addr];
endmodule
