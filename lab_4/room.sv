module room (
    input  logic clk, n, s, e, w, v, reset,
    output logic s6, win, s5, d, s4, s3, sw, s2, s1, s0
);
    logic move_n, move_s, move_e, move_w, move_se;
    logic [6:0] next_state;

    // The legal combinations as all other direction combinations are ignored
    assign move_n  =  n & ~s & ~e & ~w;
    assign move_s  = ~n &  s & ~e & ~w;
    assign move_e  = ~n & ~s &  e & ~w;
    assign move_w  = ~n & ~s & ~e &  w;
    assign move_se = ~n &  s &  e & ~w;

    // One-hot state bits
    // Active-high synchronous reset takes over movement and selects s0
    assign next_state[0] = reset | (~reset &
        ((s1 & move_w) | (s0 & ~move_e)));
    assign next_state[1] = ~reset &
        ((s0 & move_e) | (s2 & move_n) |
         (s1 & ~(move_w | move_s)));
    assign next_state[2] = ~reset &
        ((s1 & move_s) | (s3 & move_e) |
         (s2 & ~(move_n | move_w | move_se)));
    assign next_state[3] = ~reset &
        ((s2 & move_w) | (s3 & ~move_e));
    assign next_state[4] = ~reset & s2 & move_se;
    assign next_state[5] = ~reset & ((s4 & v) | s5);
    assign next_state[6] = ~reset & ((s4 & ~v) | s6);

    // 7 flip-flop instances
    d_ff ff_s0 (.d(next_state[0]), .clk(clk), .q(s0));
    d_ff ff_s1 (.d(next_state[1]), .clk(clk), .q(s1));
    d_ff ff_s2 (.d(next_state[2]), .clk(clk), .q(s2));
    d_ff ff_s3 (.d(next_state[3]), .clk(clk), .q(s3));
    d_ff ff_s4 (.d(next_state[4]), .clk(clk), .q(s4));
    d_ff ff_s5 (.d(next_state[5]), .clk(clk), .q(s5));
    d_ff ff_s6 (.d(next_state[6]), .clk(clk), .q(s6));

    // Moore outputs (depend only on the current room)
    assign sw  = s3;
    assign win = s5;
    assign d   = s6;
endmodule
