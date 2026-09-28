module room (
    input wire clk,
    input wire reset,
    input wire n,
    input wire s,
    input wire e,
    input wire w,
    input wire v,

    output wire s0,
    output wire s1,
    output wire s2,
    output wire s3,
    output wire s4,
    output wire s5,
    output wire s6,
    output wire sw,
    output wire win,
    output wire d
);

    reg [6:0] state;
    wire [6:0] next_state;

    assign next_state[0] =
        (state[1] & w) |
        (state[0] & ~e);

    assign next_state[1] =
        (state[0] & e) |
        (state[2] & n) |
        (state[1] & ~(w | s));

    assign next_state[2] =
        (state[1] & s) |
        (state[3] & e) |
        (state[2] & ~(n | e | w));

    assign next_state[3] =
        (state[2] & w) |
        (state[3] & ~e);

    assign next_state[4] =
        state[2] & e;

    assign next_state[5] =
        (state[4] & v) | state[5];

    assign next_state[6] =
        (state[4] & ~v) | state[6];

    always @(posedge clk) begin
        if (reset)
            state <= 7'b0000001;
        else
            state <= next_state;
    end

    assign s0 = state[0];
    assign s1 = state[1];
    assign s2 = state[2];
    assign s3 = state[3];
    assign s4 = state[4];
    assign s5 = state[5];
    assign s6 = state[6];

    assign sw  = state[3];
    assign win = state[5];
    assign d   = state[6];

endmodule