module multi_mux#(
    parameter   WL_A    =  16,
    parameter   QF_A    =  14,
    parameter   WL_B    =  32,
    parameter   QF_B    =  29,
    parameter   WL_OUT  =  32,
    parameter   QF_OUT  =  29
)(
    input                         selector,
    input       signed [WL_A-1:0   ] a1_in,
    input       signed [WL_B-1:0   ] b1_in,
    input       signed [WL_A-1:0   ] a2_in,
    input       signed [WL_B-1:0   ] b2_in,
    output wire signed [WL_OUT-1:0] multi_out1,
    output wire signed [WL_OUT-1:0] multi_out2
);

localparam MULT_WL  = WL_A + WL_B;

localparam FRAC    = QF_A + QF_B;
localparam SHIFT   = FRAC - QF_OUT;

wire signed [WL_A-1:0] A_mux;
wire signed [WL_B-1:0] B_mux;

wire signed [MULT_WL-1:0] multi;

assign A_mux = selector ? a2_in : a1_in;

assign B_mux = selector ? b2_in : b1_in;

assign multi = A_mux * B_mux;

assign multi_out1 = multi >>> SHIFT;
assign multi_out2 = multi >>> SHIFT;

endmodule