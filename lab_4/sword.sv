module sword (
    input  logic sw, reset, clk,
    output logic v
);
    logic next_sword;

    // Get the sword when sw=1 and retain it until synchronous reset
    assign next_sword = ~reset & (v | sw);
    d_ff ff_sword (.d(next_sword), .clk(clk), .q(v));
endmodule
