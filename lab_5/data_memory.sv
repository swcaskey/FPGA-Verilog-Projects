// 256 words x 32 bits, initialized as dm_regs[i] = i on active-low reset.
// The lab uses WORD INDICES: A=5 selects word 5. Do not divide A by four.
// Asynchronous read permits LW to complete at one rising edge.
module data_memory (
    input  logic        clk, rst,
    input  logic [31:0] A, WD,
    input  logic        WE,
    output logic [31:0] RD,
    output logic [31:0] prode
);
    logic [31:0] dm_regs [0:255];
    integer i;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 256; i = i + 1)
                dm_regs[i] <= i;
        end else if (WE && (A < 32'd256)) begin
            dm_regs[A[7:0]] <= WD;
        end
    end

    // Guard the whole address, so an invalid address cannot wrap to word zero.
    assign RD    = (A < 32'd256) ? dm_regs[A[7:0]] : 32'd0;
    assign prode = dm_regs[2];
endmodule
