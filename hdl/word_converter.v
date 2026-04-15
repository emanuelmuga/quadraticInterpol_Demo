module word_converter #(
    parameter QI_IN  = 3,
    parameter QF_IN  = 13,
    parameter QI_OUT = 14,
    parameter QF_OUT = 26
)(
    input  signed [(QI_IN+QF_IN)-1:0] data_i,
    output signed [(QI_OUT+QF_OUT)-1:0] data_o
);

localparam TOTAL_WL_IN = QI_IN + QF_IN;
localparam TOTAL_WL_OUT = QI_OUT + QF_OUT;
localparam SHIFT_BITS = QF_OUT - QF_IN;

wire signed [TOTAL_WL_OUT-1:0] extended_val;

generate
    if (SHIFT_BITS > 0) begin
        assign extended_val = {{(TOTAL_WL_OUT - TOTAL_WL_IN){data_i[TOTAL_WL_IN-1]}}, data_i} << SHIFT_BITS;
    end 
    else if (SHIFT_BITS < 0) begin
        assign extended_val = {{(TOTAL_WL_IN - TOTAL_WL_OUT){data_i[TOTAL_WL_IN-1]}}, data_i} >>> -SHIFT_BITS;
    end 
    else begin
        assign extended_val = {{(TOTAL_WL_OUT - TOTAL_WL_IN){data_i[TOTAL_WL_IN-1]}}, data_i};
    end
endgenerate

assign data_o = extended_val;

endmodule