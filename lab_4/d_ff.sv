// One flip-flop stores one bit of the CURRENT state.
// d is the NEXT value; q is the stored CURRENT value.
// At each rising clock edge, q receives d.
// <= is a nonblocking assignment: all flip-flops update together.
// Between clock edges, q holds its value.
// Reset is handled in the Room/Sword next-state equations.

module d_ff (
    input  logic d, clk,
    output logic q
);
    // One-bit state register. Reset is handled by each FSM's D-input logic.
    always_ff @(posedge clk)
        q <= d;
endmodule
