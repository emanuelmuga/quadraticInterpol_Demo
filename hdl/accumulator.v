module accumulator#(
    parameter  WORD_LENGTH    = 16         
)(
    input       clk, rstn, enable,
    input       selector, load, 
    input       signed [WORD_LENGTH-1:0]  a_in,
    input       signed [WORD_LENGTH-1:0]  b_in,
    output reg  signed [WORD_LENGTH-1:0]  acc_out
);


wire signed [WORD_LENGTH:0]   sum;
wire signed [WORD_LENGTH-1:0] acc_next;

assign sum = acc_out + b_in;

assign acc_next = (selector) ? sum[WORD_LENGTH-1:0] : a_in;

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        acc_out <= {WORD_LENGTH{1'b0}};
    else begin
        if(enable) begin
            if(load) begin
                acc_out <= acc_next; 
            end
        end 
    end
end

	

endmodule 