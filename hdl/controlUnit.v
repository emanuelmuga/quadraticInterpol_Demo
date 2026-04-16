module controlUnit(
    input                               clk, 
    input                               rstn, 
    input                               start,
    input                               enable,
    input                               compFactor_flag,
    input                               compSignal_flag,
    output reg                          clear_sig,
    output reg                          loadX0_sig,  
    output reg                          loadX1_sig,  
    output reg                          loadX2_sig,  
    output reg                          shiftInput_sig,  
    output reg                          loadCoeffs_sig,
    output reg                          loadP1_sig,
    output reg                          loadP2_sig,
    output reg                          selMulti_sig,
    output reg                          loadXi_sig,
    output reg                          selXi_sig,
    output reg                          loadGF_sig,
    output reg                          loadXi2m_sig,
    output reg                          selXi2m_sig,
    output reg                          loadXi2nd_sig,
    output reg                          selXi2nd_sig,
    output reg                          loadC0Q_sig,
    output reg                          selYt_sig,
    output reg                          loadYt_sig,         
    output reg                          wrEn_sig,  
    output reg                          incAddrMemIn_sig,                                   
    output reg                          incAddrMemOut_sig,                                   
    output reg                          interpCntEn_sig,
    output reg                          done,
    output reg                          busy
);

    // Symbolic states declaration
    localparam STATUS_WIDTH = ceilLog2(13);    

	localparam [STATUS_WIDTH-1:0]   IDLE = 'd0, 
                                    S1   = 'd1,
                                    READ_MEMIN = 'd2,
                                    S2   = 'd3, 
                                    S3   = 'd4, 
                                    S4   = 'd5, 
                                    S5   = 'd6, 
                                    S6   = 'd7, 
                                    S7   = 'd8, 
                                    S8   = 'd9, 
                                    S9  = 'd10, 
                                    S10  = 'd11, 
                                    S11  = 'd12, 
                                    S12  = 'd13,
                                    XX   ={STATUS_WIDTH{1'bx}};

    // Boolean states
    localparam TRUE  = 1'b1;
    localparam FALSE = 1'b0;

    // registers declaration
    reg [STATUS_WIDTH:0] state_next, state_reg;
    wire busy_next;

    // assign outputs
    assign busy_next = (state_reg != S1) ? TRUE : FALSE;
 
    //##############################################################//

    //(1) State register
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            state_reg    <= S1;
            busy         <= FALSE;
        
        end	
        else begin
            state_reg   <= state_next;
            busy        <= busy_next;
        end
    end

    //(2) Combinational next state logic 
    always @(*) begin
        state_next = XX;
        case(state_reg)
            IDLE: 
                begin
                    if(start) begin     
                        state_next = S1;              
                    end   
                    else 
                        state_next = IDLE;              
                end
            S1: state_next = READ_MEMIN;              

            READ_MEMIN: state_next = S2;   
  
            S2: state_next = S3;              
             
            S3: state_next = S4;

            S4: state_next = S5;  

            S5: state_next = S6;             

            S6: state_next = S7;             

            S7: state_next = S8;

            S8: state_next = S9;

            S9: state_next = S10;

            S10: 
                begin
                    if(compFactor_flag && !compSignal_flag) 
                        state_next = S11;    
                    else if(compFactor_flag && compSignal_flag)
                        state_next = S12;
                    else
                        state_next = S10;              
                end

            S11: state_next = S5;       

            S12:  state_next = IDLE;            

            default: state_next = XX;            
        endcase
    end

    //(3) Registered output logic (Moore outputs)
    always @(posedge clk or negedge rstn)begin
        if(!rstn)begin
            clear_sig         <= FALSE;
            wrEn_sig          <= FALSE;
            loadX0_sig        <= FALSE;
            loadX1_sig        <= FALSE;
            loadX2_sig        <= FALSE;
            shiftInput_sig    <= FALSE;
            loadCoeffs_sig    <= FALSE;
            loadP1_sig        <= FALSE;
            loadP2_sig        <= FALSE;
            selMulti_sig      <= FALSE;
            loadXi_sig        <= FALSE;
            loadGF_sig        <= FALSE;
            loadXi2m_sig      <= FALSE;
            loadXi2nd_sig     <= FALSE;
            loadC0Q_sig       <= FALSE;
            selYt_sig         <= FALSE;
            loadYt_sig        <= FALSE;
            selXi2m_sig       <= FALSE;
            selXi_sig         <= FALSE;
            selXi2nd_sig      <= FALSE;
            interpCntEn_sig   <= FALSE;
            incAddrMemIn_sig  <= FALSE;
            incAddrMemOut_sig <= FALSE;
            done              <= FALSE;

        end
        else begin
            clear_sig         <= FALSE;
            wrEn_sig          <= FALSE;
            loadX0_sig        <= FALSE;
            loadX1_sig        <= FALSE;
            loadX2_sig        <= FALSE;
            shiftInput_sig    <= FALSE;
            loadCoeffs_sig    <= FALSE;
            loadP1_sig        <= FALSE;
            loadP2_sig        <= FALSE;
            selMulti_sig      <= FALSE;
            loadXi_sig        <= FALSE;
            loadGF_sig        <= FALSE;
            loadXi2m_sig      <= FALSE;
            loadXi2nd_sig     <= FALSE;
            loadC0Q_sig       <= FALSE;
            selYt_sig         <= FALSE;
            loadYt_sig        <= FALSE;
            selXi2m_sig       <= FALSE;
            selXi_sig         <= FALSE;
            selXi2nd_sig      <= FALSE;
            interpCntEn_sig   <= FALSE;
            incAddrMemIn_sig  <= FALSE;
            incAddrMemOut_sig <= FALSE;
            done              <= FALSE;

            case(state_next)
                IDLE: ;              

                S1: clear_sig <= TRUE;  

                READ_MEMIN: incAddrMemIn_sig  <= TRUE;

                S2: 
                    begin
                        loadX0_sig <= TRUE;
                        incAddrMemIn_sig  <= TRUE;
                    end

                S3: 
                    begin 
                        loadX1_sig <= TRUE;
                        incAddrMemIn_sig  <= TRUE;
                    end

                S4: 
                    begin
                        loadX2_sig <= TRUE;
                    end

                S5: loadCoeffs_sig <= TRUE;

                S6: 
                    begin
                        loadP2_sig   <= TRUE;
                        selMulti_sig <= TRUE;
                    end

                S7: loadP1_sig   <= TRUE;

                S8: 
                    begin
                        loadGF_sig   <= TRUE;
                        loadXi2m_sig <= TRUE;
                        loadXi2nd_sig<= TRUE;
                        loadXi_sig   <= TRUE;
                    end

                S9: 
                    begin
                        wrEn_sig <= TRUE;
                        incAddrMemOut_sig <= TRUE;
                        interpCntEn_sig   <= TRUE;
                    end

                S10:
                    begin
                        selYt_sig    <= TRUE;
                        loadGF_sig   <= TRUE;
                        loadXi2m_sig <= TRUE;
                        loadXi2nd_sig<= TRUE;
                        loadXi_sig   <= TRUE;
                        selXi_sig    <= TRUE;
                        selXi2nd_sig <= TRUE;
                        selXi2m_sig  <= TRUE;
                        wrEn_sig     <= TRUE;
                        interpCntEn_sig   <= TRUE;
                        incAddrMemOut_sig <= TRUE;
                    end  

                S11: 
                    begin
                        incAddrMemIn_sig  <= TRUE;
                        shiftInput_sig    <= TRUE;
                    end

                S12: done <= TRUE; 
            endcase
        end
    end

    //##############################################################//

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
