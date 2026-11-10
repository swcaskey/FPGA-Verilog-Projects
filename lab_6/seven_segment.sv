// DE2-115: segments[0]=a (top), ..., segments[6]=g (middle).
// Vector order [6:0] is {g,f,e,d,c,b,a}; zero turns a segment ON.
module seven_segment (
    input  logic [3:0] digit,
    output logic [6:0] segments
);
    always_comb begin
        case (digit)
            4'd0: segments = 7'b1000000;
            4'd1: segments = 7'b1111001;
            4'd2: segments = 7'b0100100;
            4'd3: segments = 7'b0110000;
            4'd4: segments = 7'b0011001;
            4'd5: segments = 7'b0010010;
            4'd6: segments = 7'b0000010;
            4'd7: segments = 7'b1111000;
            4'd8: segments = 7'b0000000;
            4'd9: segments = 7'b0010000;
            default: segments = 7'b0111111; // dash
        endcase
    end
endmodule
