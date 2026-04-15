module coefficient_math #(
    parameter WL  = 16
)(
    input  wire signed [WL-1:0] mt0,
    input  wire signed [WL-1:0] mt1,
    input  wire signed [WL-1:0] mt2,
    output wire signed [WL-1:0] ct0,
    output wire signed [WL-1:0] ct1,
    output wire signed [WL-1:0] ct2
);


wire signed [WL:0] mt2_plus_mt0_div2; // (m2 + m0)/2


wire signed [WL:0]    sum; 
wire signed [WL+1:0]  sub2;
wire signed [WL+2:0]  sub3;

wire signed [WL+1:0]  twoTimes_mt1;
wire signed [WL+2:0]  twoTimes_mt1_sub_m0;

//----------------------- C0 --------------------------//

assign ct0 = mt0;

//----------------------- (M2 + M0)/2 --------------------------//


assign sum = mt0 + mt2;

assign mt2_plus_mt0_div2 = sum >> 1;


//----------------------- C2 = (M2 + M0)/2 - m1 -----------------------//

assign sub2 = mt2_plus_mt0_div2 - mt1;

assign ct2 = sub2[WL-1:0];

//----------------------- Ct1 = 2*mt1 - mt0 - (Mt2 + Mt)/2 ------------------------//


assign twoTimes_mt1 = mt1 <<< 1;

assign sub3 = twoTimes_mt1 - mt0 - mt2_plus_mt0_div2;

assign ct1 = sub3[WL-1:0];


endmodule