// Display an unsigned value 0..999 as three decimal digits, including zeros.
// Values outside that range (including negative two's-complement results)
// display --- instead of silently truncating the value.
module display (
    input  logic [31:0] data_in,
    output logic [6:0]  segments_hundreds,
    output logic [6:0]  segments_tens,
    output logic [6:0]  segments_ones
);
    logic [9:0] small_value, hundreds_value, tens_value, ones_value;
    logic [3:0] hundreds_digit, tens_digit, ones_digit;

    assign small_value    = data_in[9:0];
    assign hundreds_value = small_value / 10'd100;
    assign tens_value     = (small_value / 10'd10) % 10'd10;
    assign ones_value     = small_value % 10'd10;
    assign hundreds_digit = (data_in <= 32'd999) ? hundreds_value[3:0] : 4'hF;
    assign tens_digit     = (data_in <= 32'd999) ? tens_value[3:0] : 4'hF;
    assign ones_digit     = (data_in <= 32'd999) ? ones_value[3:0] : 4'hF;

    seven_segment u_hundreds (.digit(hundreds_digit), .segments(segments_hundreds));
    seven_segment u_tens     (.digit(tens_digit),     .segments(segments_tens));
    seven_segment u_ones     (.digit(ones_digit),     .segments(segments_ones));
endmodule
