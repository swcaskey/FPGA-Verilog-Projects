module d_ff (
    input  logic d, clk,
    output logic q
);
    // One-bit state register. Reset is handled by each FSM's D-input logic.
    always_ff @(posedge clk)
        q <= d;
endmodule
