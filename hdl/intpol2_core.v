/*
==============================================================================================
    Programer     : Emanuel Murillo García
    Contact       : emanuel.murillo@cinvestav.mx
                    emanuel.muga13@gmail.com

    Module Name   : intpol2_core (TOP), Interpolador Cuadratico Diseño IV Dual datapath (IQ) Macro. 
    Type          : Verilog module
    
    Description   : Obtine los valores interpolados entre tres datos de entrada, M0, M1, M2.
                    Utilizando solo un multiplicador con pipeline.
                    Realiza la aproximación con: y = p0 + p1*xi + p2*(xi)^2. Donde pi son los
                    coeficientes calculados "On-the-fly" y xi el factor de interpolación.
-----------------------------------------------------------------------------------------------                    
    Clocks        : posedge "clk"
    Reset         : Async negedge "rstn"
    Parameters    :

                    NAME                          Comments                             
                    -------------------------------------------------------------
                    DATAPATH_WIDTH                Tamaño de palabra
                    CONFIG_WIDTH                  Tamaño de palabra del config
                    DUAL_DATAPATH                 Instancia dos datapath para IQ
                    FRAC_BITS                     No. bits parte frac. 
                    -------------------------------------------------------------
    config_i    :   interpFactor = config_i[0][7:0];    
                    opMode       = config_i[0][8];      1'b0: NORMAL; 1'b1; BYPASS; 
                    iX           = config_i[1][31:0];   Factor de interpolacion  
                    iX2          = config_i[2][31:0];   Factor de interpolacion^2          
                                        
                    -------------------------------------------------------------
    status_IPcore :  status_IPcore[0] = busy;
                     status_IPcore[1] = stop_empty;
                     status_IPcore[2] = stop_Afull;
                    -------------------------------------------------------------
    int_IPCore    :  int_IPCore[0] = done;                
-------------------------------------------------------------------------------------------------
    Version        : 2.0
    Date           : 21 Sep   2022
    Last update    : 14 April 2026
=================================================================================================            
*/

module intpol2_core #(                     
    parameter   CONFIG_WIDTH     = 'd32,
    parameter   DATAPATH_WIDTH   = 'd16,
    parameter   MEMIN_DEPTH      = 'd2000,
    parameter   MEMOUT_DEPTH     = 'd64000,
    parameter   MAX_INTERP       = 32       
)(     
    input  wire                             clk,
    input  wire                             rstn,
    input  wire                             enable,
    input  wire                             start,          
    input  wire [DATAPATH_WIDTH-1:0]        dataIn,
    input  wire [ceilLog2(MEMIN_DEPTH)-1:0] signalLen_i,
    input  wire [ceilLog2(MAX_INTERP)-1:0]  interpFactor_i,
    input  wire [CONFIG_WIDTH-1:0]          invU_i,  
    input  wire [CONFIG_WIDTH-1:0]          invU2_i, 
    output wire                             wrEn_o,
    output wire [ceilLog2(MEMIN_DEPTH)-1:0] addrMemIn,
    output wire [ceilLog2(MEMOUT_DEPTH)-1:0]addrMemOut,
    output wire [DATAPATH_WIDTH-1:0]        dataOut,
    output wire                             busy_o,
    output wire                             done_o
);


// control signals
wire clear_sig;
wire interpCntEn_sig;
wire incAddrMemIn_sig;
wire incAddrMemOut_sig;
wire loadX0_sig;
wire loadX1_sig;
wire loadX2_sig;
wire loadCoeffs_sig;
wire shiftInput_sig;
wire loadP1_sig;
wire loadP2_sig;
wire selMulti_sig;
wire loadXi_sig;
wire selXi_sig;
wire loadGF_sig;
wire loadXi2m_sig;
wire selXi2m_sig;
wire loadXi2nd_sig;
wire selXi2nd_sig;
wire loadC0Q_sig;
wire selYt_sig;
wire loadYt_sig;

// flags
wire compFactor_flag;
wire compSignal_flag;
wire addrMemOut_flag;

// data signals
wire [ceilLog2(MAX_INTERP)-1:0] interpCnt_val;
wire [ceilLog2(MEMIN_DEPTH)-1:0] signalLen_w;

// assigns
assign signalLen_w = signalLen_i - 'd3; 


//##############################################################//

datapath#(
    .CONFIG_WIDTH  ( CONFIG_WIDTH ),
    .WORD_LENGTH       ( DATAPATH_WIDTH   )
)DATA_PATH(
    .clk             ( clk             ),
    .rstn            ( rstn            ),
    .enable          ( enable          ),
    .loadX0_sig      ( loadX0_sig      ),
    .loadX1_sig      ( loadX1_sig      ),
    .loadX2_sig      ( loadX2_sig      ),
    .shiftInput_sig  ( shiftInput_sig  ),
    .loadCoeffs_sig  ( loadCoeffs_sig  ),
    .loadP1_sig      ( loadP1_sig      ),
    .loadP2_sig      ( loadP2_sig      ),
    .selMulti_sig    ( selMulti_sig    ),
    .loadXi_sig      ( loadXi_sig      ),
    .selXi_sig       ( selXi_sig       ),
    .loadGF_sig      ( loadGF_sig      ),
    .loadXi2m_sig    ( loadXi2m_sig    ), 
    .selXi2m_sig     ( selXi2m_sig     ),
    .loadXi2nd_sig   ( loadXi2nd_sig   ),
    .selXi2nd_sig    ( selXi2nd_sig    ),
    .loadC0Q_sig     ( loadC0Q_sig     ),
    .selYt_sig       ( selYt_sig       ),
    .loadYt_sig      ( loadYt_sig      ),
    .invU            ( invU_i          ),
    .invU2           ( invU2_i         ),
    .dataIn          ( dataIn          ),
    .dataOut         ( dataOut         )
);

controlUnit FSM(
    .clk              ( clk              ),
    .rstn             ( rstn             ),
    .enable           ( enable           ),
    .clear_sig        ( clear_sig        ),
    .start            ( start            ),
    .compFactor_flag  ( compFactor_flag  ),
    .compSignal_flag  ( compSignal_flag  ),
    .incAddrMemIn_sig ( incAddrMemIn_sig ),
    .incAddrMemOut_sig( incAddrMemOut_sig),
    .interpCntEn_sig  ( interpCntEn_sig  ),
    .loadX0_sig       ( loadX0_sig       ),
    .loadX1_sig       ( loadX1_sig       ),
    .loadX2_sig       ( loadX2_sig       ),
    .shiftInput_sig   ( shiftInput_sig   ),
    .loadCoeffs_sig   ( loadCoeffs_sig   ),
    .loadP1_sig       ( loadP1_sig       ),
    .loadP2_sig       ( loadP2_sig       ),
    .selMulti_sig     ( selMulti_sig     ),
    .loadXi_sig       ( loadXi_sig       ),
    .selXi_sig        ( selXi_sig        ),
    .loadGF_sig       ( loadGF_sig       ),
    .loadXi2m_sig     ( loadXi2m_sig     ),
    .selXi2m_sig      ( selXi2m_sig      ),
    .loadXi2nd_sig    ( loadXi2nd_sig    ),
    .selXi2nd_sig     ( selXi2nd_sig     ),
    .loadC0Q_sig      ( loadC0Q_sig      ),
    .selYt_sig        ( selYt_sig        ),
    .loadYt_sig       ( loadYt_sig       ),
    .wrEn_sig         ( wrEn_o           ),
    .done             ( done_o           ),
    .busy             ( busy_o           )
);



upCounter #(
    .CNT_MOD    (MAX_INTERP)
) interp_cnt_inst  (
    .clk         (clk),
    .rstn        (rstn),
    .clrh        (clear_sig),
    .enh         (interpCntEn_sig),
    .hit_o       (compFactor_flag),
    .max_cnt_i   (interpFactor_i-'d1),
    .cnt_o       (interpCnt_val)
);

upCounter #(
    .CNT_MOD    (MEMIN_DEPTH)
) addrMemIn_inst  (
    .clk         (clk),
    .rstn        (rstn),
    .clrh        (clear_sig),
    .enh         (incAddrMemIn_sig),
    .hit_o       (compSignal_flag),
    .max_cnt_i   (signalLen_w),
    .cnt_o       (addrMemIn)
);


upCounter #(
    .CNT_MOD    (MEMOUT_DEPTH)
) addrMemOut_inst  (
    .clk         (clk),
    .rstn        (rstn),
    .clrh        (clear_sig),
    .enh         (incAddrMemOut_sig),
    .hit_o       (addrMemOut_flag),
    .max_cnt_i   (MEMOUT_DEPTH),
    .cnt_o       (addrMemOut)
);


// -----------------------------------------------------------------------------------

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