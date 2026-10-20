module sword (
    input  logic sw, reset, clk,
    output logic v
);
    logic next_sword;

    // v = CURRENT sword ownership
		// Get the sword (v) when sw=1 and retain it until synchronous reset
    assign next_sword = ~reset & (v | sw);
	
	// One d_ff stores ownership; this is separate from room state.
    d_ff ff_sword (.d(next_sword), .clk(clk), .q(v));
endmodule
