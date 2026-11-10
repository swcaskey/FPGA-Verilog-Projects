// Lab 6: 32 locations x 8 bits. Reset sets dm_regs[i] = i.
// Addresses are WORD INDICES; do not divide the ALU result by four.
module data_memory (
    input  logic        clk, rst,
    input  logic [31:0] A, WD,
    input  logic        WE,
    input  logic [4:0]  probe_addr,
    output logic [31:0] RD,
    output logic [7:0]  prode
);
    logic [7:0] dm_regs [0:31];
    integer i;
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1)
                dm_regs[i] <= i[7:0];
        end else if (WE && (A < 32'd32)) begin
            dm_regs[A[4:0]] <= WD[7:0];
        end
    end
    assign RD = (A < 32'd32) ? {24'd0, dm_regs[A[4:0]]} : 32'd0;
    assign prode = dm_regs[probe_addr];
endmodule
