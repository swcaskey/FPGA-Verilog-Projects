module game (
    input  logic clk, n, s, e, w, reset,
    output logic s6, win, s5, d, s4, s3, sw, s2, s1, s0, v
);
    // Board switches are asynchronous to CLOCK_50. Sample each through
    // two registers before it can reach any state-register D-input logic.
    // Hold reset high for at least three rising clock edges after programming.
    // This adds two clock periods of input latency; it is not a debouncer.
    (* preserve *) logic [4:0] switch_meta;
    (* preserve *) logic [4:0] switch_sync;

    always_ff @(posedge clk) begin
        switch_meta <= {reset, n, s, e, w};
        switch_sync <= switch_meta;
    end

    // The two FSMs share the clock and synchronized reset
    // Room sends sw to Sword and Sword sends v back to Room
    room room_fsm (
        .clk(clk), .n(switch_sync[3]), .s(switch_sync[2]),
        .e(switch_sync[1]), .w(switch_sync[0]), .v(v),
        .reset(switch_sync[4]),
        .s6(s6), .win(win), .s5(s5), .d(d), .s4(s4),
        .s3(s3), .sw(sw), .s2(s2), .s1(s1), .s0(s0)
    );

    sword sword_fsm (
        .sw(sw), .reset(switch_sync[4]), .clk(clk), .v(v)
    );
endmodule
