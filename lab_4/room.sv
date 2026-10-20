module room (
	// ROOM MAP:
	// s0 = Cave of Cacophony: E -> s1
	// s1 = Twisty Tunnel: W -> s0, S -> s2
	// s2 = Rapid River: N -> s1, W -> s3, SE -> s4
	// s3 = Sword Stash: E -> s2
	// s4 = Dragon's Den: automatically -> s5 if v=1, otherwise s6
	// s5 = Victory Vault: stay until reset
	// s6 = Grievous Graveyard: stay until reset
	//
	// raw_next_state = normal transition equations.
	// next_state = values actually sent to the seven flip-flops.
    input  logic clk, n, s, e, w, v, reset,
    output logic s6, win, s5, d, s4, s3, sw, s2, s1, s0
);
    logic move_n, move_s, move_e, move_w, move_se;
    logic [6:0] next_state, raw_next_state;
    logic valid_state;

	// Combinational logic: evaluated whenever its inputs change.
	// Check whether exactly one room bit is active.
	// This is STATE validity, not DIRECTION validity.
	// If the state is invalid, next_state selects s0 for recovery.
	// Bit order is {s6,s5,s4,s3,s2,s1,s0}; 0000001 means s0.
    always_comb begin
        case ({s6, s5, s4, s3, s2, s1, s0})
            7'b0000001, 7'b0000010, 7'b0000100, 7'b0001000,
            7'b0010000, 7'b0100000, 7'b1000000: valid_state = 1'b1;
            default: valid_state = 1'b0;
        endcase
    end

	// next_state = raw_next_state IF valid_state ELSE 0000001
    assign next_state = valid_state ? raw_next_state : 7'b0000001;

    // The legal combinations as all other direction combinations are ignored
    assign move_n  =  n & ~s & ~e & ~w;
    assign move_s  = ~n &  s & ~e & ~w;
    assign move_e  = ~n & ~s &  e & ~w;
    assign move_w  = ~n & ~s & ~e &  w;
    assign move_se = ~n &  s &  e & ~w;

    // One-hot state bits
    // Active-high synchronous reset takes over movement and selects s0
    assign raw_next_state[0] = reset | (~reset &
        ((s1 & move_w) | (s0 & ~move_e)));
		// Example s0:
		// (s1 & move_w) = enter s0 from s1 by going West.
		// (s0 & ~move_e) = stay in s0 unless exact East is applied.
    assign raw_next_state[1] = ~reset &
        ((s0 & move_e) | (s2 & move_n) |
         (s1 & ~(move_w | move_s)));
    assign raw_next_state[2] = ~reset &
        ((s1 & move_s) | (s3 & move_e) |
         (s2 & ~(move_n | move_w | move_se)));
    assign raw_next_state[3] = ~reset &
        ((s2 & move_w) | (s3 & ~move_e));
    assign raw_next_state[4] = ~reset & s2 & move_se;
	// Other rooms include a term referencing themselves (hold term),
	// such as s0 & ~move_e, to stay active. Dragon has no
	// such term because the game requires an automatic outcome.
    assign raw_next_state[5] = ~reset & ((s4 & v) | s5);
    assign raw_next_state[6] = ~reset & ((s4 & ~v) | s6);

    // 7 flip-flop instances
	// .d(next_state[i]) connects the computed next value.
	// .q(si) produces the current room bit used by the equations.
	// All instances share clk and update on the same rising edge.
    d_ff ff_s0 (.d(next_state[0]), .clk(clk), .q(s0));
    d_ff ff_s1 (.d(next_state[1]), .clk(clk), .q(s1));
    d_ff ff_s2 (.d(next_state[2]), .clk(clk), .q(s2));
    d_ff ff_s3 (.d(next_state[3]), .clk(clk), .q(s3));
    d_ff ff_s4 (.d(next_state[4]), .clk(clk), .q(s4));
    d_ff ff_s5 (.d(next_state[5]), .clk(clk), .q(s5));
    d_ff ff_s6 (.d(next_state[6]), .clk(clk), .q(s6));

    // Moore outputs (depend only on the current room)
		// sw means "currently in the sword room"; v means "own the sword".
		// Sword persistence stays in sword.sv.
    assign sw  = s3;
    assign win = s5;
    assign d   = s6;
endmodule
