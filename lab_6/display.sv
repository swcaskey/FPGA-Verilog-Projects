// Two DECIMAL digits, active-low segments.
// [6:0] = ones, [13:7] = tens. Values above 99 display --.
module display (
    input  logic [7:0] data_in,
    output logic [13:0] segments
);
    logic [7:0] tens_value, ones_value;
    logic [3:0] tens_digit, ones_digit;
    assign tens_value = data_in / 8'd10;
    assign ones_value = data_in % 8'd10;
    assign tens_digit = (data_in <= 8'd99) ? tens_value[3:0] : 4'hF;
    assign ones_digit = (data_in <= 8'd99) ? ones_value[3:0] : 4'hF;
    seven_segment tens (.digit(tens_digit), .segments(segments[13:7]));
    seven_segment ones (.digit(ones_digit), .segments(segments[6:0]));
endmodule
