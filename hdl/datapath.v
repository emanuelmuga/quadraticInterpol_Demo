module datapath #(
    parameter CONFIG_WIDTH  = 32,
    parameter WORD_LENGTH   = 16
)(
    input                                clk, 
    input                                rstn,
    input                                enable,
    input                                loadX0_sig,
    input                                loadX1_sig,
    input                                loadX2_sig,
    input                                shiftInput_sig,
    input                                loadCoeffs_sig,
    input                                loadP1_sig,
    input                                loadP2_sig,
    input                                selMulti_sig,
    input                                loadXi_sig,
    input                                selXi_sig,
    input                                loadGF_sig,
    input                                loadXi2m_sig,
    input                                selXi2m_sig,
    input                                loadXi2nd_sig,
    input                                selXi2nd_sig,
    input                                loadC0Q_sig,
    input                                selYt_sig,
    input                                loadYt_sig,
    input  signed [CONFIG_WIDTH-1:0]     invU,
    input  signed [CONFIG_WIDTH-1:0]     invU2,
    input  signed [WORD_LENGTH-1:-0]     dataIn,        
    output signed [WORD_LENGTH-1:-0]     dataOut 
);

localparam WL_M = WORD_LENGTH;
localparam QF_M = 13;
localparam QI_M = WL_M - QF_M;

localparam WL_P = 32, QF_P = 29, QI_P = WL_P - QF_P;

wire [WL_M-1:-0] m0_reg;
wire [WL_M-1:-0] m1_reg;
wire [WL_M-1:-0] m2_reg;

wire [WL_M-1:0] c0_w;
wire [WL_M-1:0] c0_reg;
wire [WL_M-1:0] c0Q_reg;

wire [WL_M-1:0] c1_w;
wire [WL_M-1:0] c1_reg;

wire [WL_M-1:0] c2_w;
wire [WL_M-1:0] c2_reg;

wire [WL_P-1:0] p1_w;
wire [WL_P-1:0] p1_reg;
wire [WL_P-1:0] p2_w;
wire [WL_P-1:0] p2_reg;

wire [WL_P-1:0] xi_reg;
wire [WL_P-1:0] GF_w;
wire [WL_P-1:0] GF_reg;
wire [WL_P-1:0] xi2nd_reg;
wire [WL_P-1:0] xi2main_reg;

wire [WL_M-1:0] xi2main_align; // fi point aling 
wire [WL_M-1:0] xi_align; // fi point aling 

wire [WL_M-1:0] xi2main_conv_w;

wire [WL_M-1:0] add3_w;

wire [WL_M-1:0] yt_w;

assign GF_w = p2_w <<< 1;


input_register#(
    .DATA_WIDTH ( WL_M )
)input_register_inst(
    .clk    ( clk         ),
    .rstn   ( rstn        ),
    .load0  ( loadX0_sig  ),
    .load1  ( loadX1_sig  ),
    .load2  ( loadX2_sig  ),
    .shift  ( shiftInput_sig),
    .dataIn ( dataIn      ),
    .m0     ( m0_reg      ),
    .m1     ( m1_reg      ),
    .m2     ( m2_reg      )
);

coefficient_math#(
    .WL ( WL_M )
)coefficient_math_inst(
    .mt0   ( m0_reg ),
    .mt1   ( m1_reg ),
    .mt2   ( m2_reg ),
    .ct0   ( c0_w   ),
    .ct1   ( c1_w   ),
    .ct2   ( c2_w   )
);

// Basicblock

register #(
    .DATA_WIDTH (WL_M)
) c0_register (
    .clk     (clk           ),
    .rstn    (rstn          ),
    .clrh    (1'b0          ),   
    .enh     (loadCoeffs_sig),
    .data_i  (c0_w          ),
    .data_o  (c0_reg        )
);

// Basicblock

register #(
    .DATA_WIDTH (WL_M)
) c1_register (
    .clk     (clk           ),
    .rstn    (rstn          ),
    .clrh    (1'b0          ),   
    .enh     (loadCoeffs_sig),
    .data_i  (c1_w          ),
    .data_o  (c1_reg        )
);

// Basicblock

register #(
    .DATA_WIDTH (WL_M)
) c2_register (
    .clk     (clk           ),
    .rstn    (rstn          ),
    .clrh    (1'b0          ),   
    .enh     (loadCoeffs_sig),
    .data_i  (c2_w          ),
    .data_o  (c2_reg        )
);

// Basicblock

register #(
    .DATA_WIDTH (WL_M)
) c0Q_register (
    .clk     (clk           ),
    .rstn    (rstn          ),
    .clrh    (1'b0          ),   
    .enh     (loadC0Q_sig   ),
    .data_i  (c0_reg        ),
    .data_o  (c0Q_reg       )
);

multi_mux#(
    .WL_A      ( WL_M  ),
    .QF_A      ( QF_M  ),
    .WL_B      ( WL_P  ),
    .QF_B      ( QF_P  ),
    .WL_OUT    ( WL_P  ),
    .QF_OUT    ( QF_P  )
)multi_mux_inst(
    .selector   ( selMulti_sig),
    .a1_in      ( c1_reg      ),
    .b1_in      ( invU        ),
    .a2_in      ( c2_reg      ),
    .b2_in      ( invU2       ),
    .multi_out1 ( p1_w        ),
    .multi_out2 ( p2_w        )
);

// Basicblock

register #(
    .DATA_WIDTH (WL_P)
) GF_register (
    .clk     (clk           ),
    .rstn    (rstn          ),
    .clrh    (1'b0          ),   
    .enh     (loadGF_sig    ),
    .data_i  (GF_w          ),
    .data_o  (GF_reg        )
);

// Basicblock

register #(
    .DATA_WIDTH (WL_P)
)P1_register (
    .clk     (clk           ),
    .rstn    (rstn          ),
    .clrh    (1'b0          ),   
    .enh     (loadP1_sig    ),
    .data_i  (p1_w          ),
    .data_o  (p1_reg        )
);

register #(
    .DATA_WIDTH (WL_P)
)P2_register (
    .clk     (clk           ),
    .rstn    (rstn          ),
    .clrh    (1'b0          ),   
    .enh     (loadP2_sig    ),
    .data_i  (p2_w          ),
    .data_o  (p2_reg        )
);

accumulator#(
    .WORD_LENGTH ( WL_P )
)xi_acc(
    .clk      ( clk       ),
    .rstn     ( rstn      ),
    .enable   ( enable    ),
    .selector ( selXi_sig ),
    .load     ( loadXi_sig),
    .a_in     ( p1_w      ),
    .b_in     ( p1_reg    ),
    .acc_out  ( xi_reg    )
);

accumulator#(
    .WORD_LENGTH ( WL_P )
)xi2nd_acc(
    .clk      ( clk          ),
    .rstn     ( rstn         ),
    .enable   ( enable       ),
    .selector ( selXi2nd_sig ),
    .load     ( loadXi2nd_sig),
    .a_in     ( p2_w         ),
    .b_in     ( GF_reg       ),
    .acc_out  ( xi2nd_reg    )
);

accumulator#(
    .WORD_LENGTH ( WL_P )
)xi2main_acc(
    .clk      ( clk          ),
    .rstn     ( rstn         ),
    .enable   ( enable       ),
    .selector ( selXi2m_sig  ),
    .load     ( loadXi2m_sig ),
    .a_in     ( p2_w         ),
    .b_in     ( xi2nd_reg    ),
    .acc_out  ( xi2main_reg  )
);


word_converter#(
    .QI_IN  ( QI_P ),
    .QF_IN  ( QF_P ),
    .QI_OUT ( QI_M ),
    .QF_OUT ( QF_M )
)xi2_main_converter(
    .data_i ( xi2main_reg  ),
    .data_o ( xi2main_align)
);

word_converter#(
    .QI_IN  ( QI_P ),
    .QF_IN  ( QF_P ),
    .QI_OUT ( QI_M ),
    .QF_OUT ( QF_M )
)xi_converter(
    .data_i ( xi_reg    ),
    .data_o ( xi_align  )
);

adder3#(
    .WL ( WL_M )
)u_adder3(
    .a_in    ( xi_align      ),
    .b_in    ( xi2main_align ),
    .c_in    ( c0_reg        ),
    .add_out ( add3_w        )
);


// Basicblock

muxNto1 #(
    .DATA_WIDTH   (WL_M),
    .SEL_WIDTH    ('d1)
)yt_mux(
    .sel_i    (selYt_sig),
    .data_i   ({ 
                add3_w, // sel:1
                c0_reg  // sel:0
               }),
    .data_o   (dataOut)
);

// Basicblock

// register #(
//     .DATA_WIDTH (WL_M)
// ) yt_register (
//     .clk     (clk           ),
//     .rstn    (rstn          ),
//     .clrh    (1'b0          ),   
//     .enh     (loadYt_sig    ),
//     .data_i  (yt_w          ),
//     .data_o  (dataOut       )
// );





endmodule