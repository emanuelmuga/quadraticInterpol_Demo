module adder3 #(
    parameter WL  = 16
)(
    input  signed [WL-1:0]  a_in,
    input  signed [WL-1:0]  b_in,
    input  signed [WL-1:0]  c_in,
    output signed [WL-1:0] add_out
);

    localparam SUM_WL  = WL + 2; 

    wire signed [SUM_WL-1:0] sum = a_in + b_in + c_in;

    assign add_out = sum[WL-1:0];

endmodule