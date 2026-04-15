module shifter_adder#(
    parameter	WL  = 16
)(
    input       signed [WL-1:0]  a_in,
    input       signed [WL-1:0]  b_out,
    output wire signed [WL:0]    add_div_out
);


    wire signed [WL:0] sum; 

    assign sum = a_in + b_out;

    assign add_div_out = sum >> 1;


endmodule