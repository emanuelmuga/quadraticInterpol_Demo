`timescale 1ns/10ps
`define CYCLE  (20) //ns -> 50 MHz (Macro to define clock cycle duration, it must be created before including the simulation library)

`define SAVEPATH "../../quadraticInterpol_Demo/sw/test_data/"
`define DATA_FILE "data_in.dat" 
`define CONFIG_FILE "config.dat" 
`define RESULT_FILE "data_result.dat"

// `define DEBUG_MODE 1

module intpol2_tb();

            //----------------------------------------------------------
            //.......MANDATORY TB PARAMETERS............................
            //----------------------------------------------------------
localparam	DATA_WIDTH    = 'd32, // AIP BITWIDTH
            //------------------------------------------------------------
            //..................CONFIG VALUES.............................
            //------------------------------------------------------------ 
            // Config values defined in the CSV file          
            STATUS   = 5'd30,//Mandatory config
            IP_ID    = 5'd31,//Mandatory config
            MDATAIN  = 5'd0, 
            MDATAOUT = 5'd2,
            CCONFIG  = 5'd4,
            //------------------------------------------------------------
            //..................PARAMETERS DEFINED BY THE USER............
            //------------------------------------------------------------
            CONFIG_WIDTH   = 'd32, // CONFIG WIDTH           
            DATAPATH_WIDTH = 'd16, // DATAPATH WIDTH 
            MEMIN_DEPTH    = 'd2000, // MEMIN DEPTH 
            MEMOUT_DEPTH   = 'd64000, 
            MAX_INTERP     = 32;



  reg clk;
  reg rst_a;
  reg en_s;

  int idx;
  int file_handle;
  string file_name;

  reg [DATA_WIDTH-1:0] tb_data;
  logic [31:0] dataTemp [];
  logic [31:0] wordTemp [];
  logic [31:0] statusTemp;

  logic [DATAPATH_WIDTH-1:0] dataPathTemp [];


  logic start;
  logic enable;
  logic busy_o;
  logic done_o;
  logic wrEn_o;
  logic [CONFIG_WIDTH-1:0] invU_i;
  logic [CONFIG_WIDTH-1:0] invU2_i;
  logic [DATAPATH_WIDTH-1:0] dataIn;
  logic [ceilLog2(MAX_INTERP)-1:0] interpFactor_i;
  logic [ceilLog2(MEMIN_DEPTH)-1:0] signalLen_i;
  logic [ceilLog2(MEMIN_DEPTH)-1:0] addrMemIn;
  logic [ceilLog2(MEMOUT_DEPTH)-1:0] addrMemOut;
  logic [DATAPATH_WIDTH-1:0] dataOut;

  logic [ceilLog2(MEMOUT_DEPTH)-1:0] interpLen;
 
  //DUT instance
  intpol2_core#(
      .CONFIG_WIDTH     ( CONFIG_WIDTH   ),
      .DATAPATH_WIDTH   ( DATAPATH_WIDTH ),
      .MEMIN_DEPTH      ( MEMIN_DEPTH    ),
      .MEMOUT_DEPTH     ( MEMOUT_DEPTH   ),
      .MAX_INTERP       ( MAX_INTERP     )
  )DUT(
      .clk              ( clk              ),
      .rstn             ( rst_a            ),
      .enable           ( en_s             ),
      .start            ( start            ),
      .dataIn           ( dataIn           ),
      .signalLen_i      ( signalLen_i      ),
      .interpFactor_i   ( interpFactor_i   ),
      .invU_i           ( invU_i           ),
      .invU2_i          ( invU2_i          ),
      .wrEn_o           ( wrEn_o           ),
      .addrMemIn        ( addrMemIn        ),
      .addrMemOut       ( addrMemOut       ),
      .dataOut          ( dataOut          ),
      .busy_o           ( busy_o           ),
      .done_o           ( done_o           )
  );

simple_dual_port_ram_single_clk#(
    .DATA_WIDTH     ( DATAPATH_WIDTH        ),
    .ADDR_WIDTH     ( ceilLog2(MEMIN_DEPTH) )
)MEM_IN(
    .Write_clock__i ( clk),
    .Write_enable_i (  ),
    .Write_addres_i (  ),
    .Read_address_i ( addrMemIn ),
    .data_input___i (     ),
    .data_output__o  ( dataIn  )
);

simple_dual_port_ram_single_clk#(
    .DATA_WIDTH     ( DATAPATH_WIDTH        ),
    .ADDR_WIDTH     ( ceilLog2(MEMOUT_DEPTH) )
)MEM_OUT(
    .Write_clock__i ( clk       ),
    .Write_enable_i ( wrEn_o    ),
    .Write_addres_i ( addrMemOut ),
    .Read_address_i (   ),
    .data_input___i ( dataOut ),
    .data_output__o (   )
);

initial begin
    clk <= 0;
    forever #(`CYCLE/2) clk = ~clk;
end

initial begin
    $timeformat(-9, 0, "ns", 16);

    //-----------------------------------------------------
    //Time-0 initialization
    //All inputs are assigned with nonblocking assignements to avoid time-0 race conditions 
    rst_a <= 0;
    en_s <= 0;
    start <= 0;
    //---------------------------------------------------

    // Wait for global reset to finish
    #(`CYCLE*0.8);
    rst_a = 1'b1;
    en_s = 1'b1;
    #(`CYCLE);

    // CONFIGURE IP
    dataTemp = new[5];
    $readmemh($sformatf({`SAVEPATH,`CONFIG_FILE}), dataTemp); 
    
    signalLen_i = dataTemp[0][ceilLog2(MEMIN_DEPTH)-1:0];
    interpFactor_i = dataTemp[1][ceilLog2(MAX_INTERP)-1:0];
    invU_i = dataTemp[2][CONFIG_WIDTH-1:0];
    invU2_i = dataTemp[3][CONFIG_WIDTH-1:0];
    interpLen = dataTemp[4][ceilLog2(MEMOUT_DEPTH)-1:0];

    $display($time, " << Starting the Simulation, interpFactor: %0d, result_size data: %0d>>", interpFactor_i, interpLen);
    
    // dataTemp = new [64];
    // for (int idx = 0; idx < 64; idx++) begin
    //     dataTemp[idx] = $urandom;
    // end
    // #(`CYCLE);

    // WRITE MEM IN
    // dataPathTemp = new[signalLen_i];
    // $readmemh($sformatf({`SAVEPATH,`CONFIG_FILE}), dataPathTemp); 
    $readmemh($sformatf({`SAVEPATH,`DATA_FILE}), MEM_IN.RAM_Structure); 

    #(`CYCLE);
    $display("%t | TEST - Start", $time);
    start = 1'b1;
    #(`CYCLE);
    start = 1'b0;

    $display("--------------------------------------------------");

    #(`CYCLE);
    wait(done_o);

    // dataTemp = new [interpLen];
    // $display("%t | TEST - Read Mem 0", $time);
    // for (idx = 0; idx < interpLen; idx++) begin
    //     addrMemOut = idx;
    //     #(`CYCLE);
    //     dataTemp[idx] = dataOut;
    //     $display("%t | TEST - Read Mem %0d: %4x", $time, idx, dataTemp[idx]);
    // end

    $writememh({`SAVEPATH, `RESULT_FILE}, MEM_OUT.RAM_Structure);
    
    #(50*`CYCLE);
    $stop;

    // file_name = $sformatf({`SAVEPATH, `RESULT_FILE});
    // file_handle = $fopen(file_name, "w");
    // if (file_handle == 0) begin
    //     $display("ERROR: Cannot open file %s", file_name);
    //     $stop;
    // end
    // $display("[%0t] Opened new file: %s", $time, file_name);

    // dataTemp = new [interpLen];
    // $display("%t | TEST - Read Mem Out", $time);

    // if (file_handle != 0) begin
    //     $fclose(file_handle);
    //     $display("[%0t] Closed file: %s ", $time, file_name);
    // end

end

  task automatic waitDone;
    input logic done_bit;
    begin
      do begin
        `ifdef DEBUG_MODE
        $display("%t | TEST - Get status", $time);
        `endif
        #2;
      end
      while (!(done_bit));  
      $display("%t | TEST - Bit detected!", $time);
    end
  endtask // waitDone

function integer ceilLog2;
    input integer data;
    integer i, result;
        begin
        result = 1; 
            for (i = 0; 2**i < data; i = i + 1)
            result = i + 1; 
            ceilLog2 = result;
        end 
endfunction


endmodule