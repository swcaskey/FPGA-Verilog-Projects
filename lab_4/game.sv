module game (
    input  logic clk, n, s, e, w, reset,
    output logic s6, win, s5, d, s4, s3, sw, s2, s1, s0, v
);
    // The two FSMs share the clock and reset
    // Room sends sw to Sword and Sword sends v back to Room
    room room_fsm (
        .clk(clk), .n(n), .s(s), .e(e), .w(w), .v(v), .reset(reset),
        .s6(s6), .win(win), .s5(s5), .d(d), .s4(s4),
        .s3(s3), .sw(sw), .s2(s2), .s1(s1), .s0(s0)
    );

    sword sword_fsm (
        .sw(sw), .reset(reset), .clk(clk), .v(v)
    );
endmodule
