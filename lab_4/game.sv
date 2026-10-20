// Make this the top module as this connects the room and sword modules

module game (
    input  logic clk, n, s, e, w, reset,
    output logic s6, win, s5, d, s4, s3, sw, s2, s1, s0, v
);
    // Board switches are independent of the CLOCK_50 (board clock). Sample each through
    // two registers before it can reach any state-register D-input logic.
    // Hold reset high for at least three rising clock edges after programming.
    // This adds two clock periods of input latency; it is not a debouncer.
	// The point of this is to synchronize switch levels.
	// preserve asks Quartus to retain these registers.
    (* preserve *) logic [4:0] switch_meta;
    (* preserve *) logic [4:0] switch_sync;
		// switch_sync[4]=reset, [3]=n, [2]=s, [1]=e, [0]=w.


	// Input changes pass through two stages before the FSM uses them.
	// For simple simulations, hold each test input for 4 clocks.

	// Use 4 full clock cycles per input, which is 80 ns with your 20 ns clock.
	// For example, hold East high for 80 ns, then return it low
	// This gives the signal time to pass through both synchronizer
	// stages and update the FSM

	// Clock period is 20 ns.
	// Rising edges at 10 (1st), 30 (2nd), 50 (3rd), 70 (4th)
	// For example, East changing at 20 ns...
	// 30 ns: switch_meta captures East.
	// 50 ns: switch_sync receives East.
	// 70 ns: the Room FSM updates using East.
    always_ff @(posedge clk) begin
        switch_meta <= {reset, n, s, e, w};
        switch_sync <= switch_meta;
    end

    // The two FSMs share the clock and synchronized reset
    // Room sends sw to Sword and Sword sends v back to Room
	
	// Module instance. room is the module type; room_fsm is the instance name
    room room_fsm (
        .clk(clk), .n(switch_sync[3]), .s(switch_sync[2]),
        .e(switch_sync[1]), .w(switch_sync[0]), .v(v),
        .reset(switch_sync[4]),
        .s6(s6), .win(win), .s5(s5), .d(d), .s4(s4),
        .s3(s3), .sw(sw), .s2(s2), .s1(s1), .s0(s0)
    );

	// Module instance. sword is the module type; sword_fsm is the instance name
    sword sword_fsm (
        .sw(sw), .reset(switch_sync[4]), .clk(clk), .v(v)
    );
endmodule
