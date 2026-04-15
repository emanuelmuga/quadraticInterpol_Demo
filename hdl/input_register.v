module input_register#(
  parameter DATA_WIDTH = 32
)
(
  input  wire                     clk,
  input  wire                     rstn,
  input  wire                     load0,
  input  wire                     load1,
  input  wire                     load2,
  input  wire                     shift,
  input  wire [DATA_WIDTH-1:0]    dataIn,
  output reg  [DATA_WIDTH-1:0] m0, m1, m2

);

reg [DATA_WIDTH-1:0] m0_next, m1_next, m2_next;


always @(*) begin
    m0_next = m0;
    m1_next = m1;
    m2_next = m2;

    if(shift) begin
        m0_next = m1;
        m1_next = m2;
        m2_next = dataIn;
    end
    else if(load0) begin
        m0_next = dataIn;
    end
    else if(load1) begin
        m1_next = dataIn;
    end
    else if(load2) begin
        m2_next = dataIn;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        m0 <= {DATA_WIDTH{1'b0}};
        m1 <= {DATA_WIDTH{1'b0}};
        m2 <= {DATA_WIDTH{1'b0}};
    end
    else begin
        m0 <= m0_next;
        m1 <= m1_next;
        m2 <= m2_next;
    end
end


endmodule