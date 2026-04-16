onerror {resume}
radix define fixed#14#decimal#signed -fixed -fraction 14 -signed -base signed -precision 6
radix define fixed#29#decimal -fixed -fraction 29 -base signed -precision 6
radix define fixed#29#decimal#signed -fixed -fraction 29 -signed -base signed -precision 6
quietly WaveActivateNextPane {} 0
add wave -noupdate /intpol2_tb/clk
add wave -noupdate /intpol2_tb/rst_a
add wave -noupdate /intpol2_tb/en_s
add wave -noupdate -expand -group IPCORE /intpol2_tb/start
add wave -noupdate -expand -group IPCORE /intpol2_tb/busy_o
add wave -noupdate -expand -group IPCORE /intpol2_tb/done_o
add wave -noupdate -expand -group IPCORE -radix unsigned /intpol2_tb/signalLen_i
add wave -noupdate -expand -group IPCORE /intpol2_tb/interpFactor_i
add wave -noupdate -expand -group IPCORE -radix unsigned /intpol2_tb/interpLen
add wave -noupdate -expand -group IPCORE -radix fixed#29#decimal /intpol2_tb/invU_i
add wave -noupdate -expand -group IPCORE -radix fixed#29#decimal /intpol2_tb/invU2_i
add wave -noupdate -expand -group IPCORE -radix fixed#14#decimal#signed /intpol2_tb/dataIn
add wave -noupdate -expand -group IPCORE /intpol2_tb/addrMemIn
add wave -noupdate -expand -group IPCORE /intpol2_tb/wrEn_o
add wave -noupdate -expand -group IPCORE -radix unsigned /intpol2_tb/addrMemOut
add wave -noupdate /intpol2_tb/dataOut
add wave -noupdate -group FSM -radix unsigned /intpol2_tb/DUT/FSM/state_reg
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/compFactor_flag
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/compSignal_flag
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/clear_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadX0_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadX1_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadX2_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/shiftInput_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadCoeffs_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadP1_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadP2_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/selMulti_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadXi_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/selXi_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadGF_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadXi2m_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/selXi2m_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadXi2nd_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/selXi2nd_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadC0Q_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/selYt_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/loadYt_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/wrEn_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/incAddrMemIn_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/incAddrMemOut_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/interpCntEn_sig
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/done
add wave -noupdate -group FSM /intpol2_tb/DUT/FSM/busy
add wave -noupdate -group INTERP_CNT /intpol2_tb/DUT/interp_cnt_inst/enh
add wave -noupdate -group INTERP_CNT /intpol2_tb/DUT/interp_cnt_inst/hit_o
add wave -noupdate -group INTERP_CNT /intpol2_tb/DUT/interp_cnt_inst/max_cnt_i
add wave -noupdate -group INTERP_CNT /intpol2_tb/DUT/interp_cnt_inst/cnt_o
add wave -noupdate -expand -group MEMIN_CNT /intpol2_tb/DUT/addrMemIn_inst/clrh
add wave -noupdate -expand -group MEMIN_CNT /intpol2_tb/DUT/addrMemIn_inst/enh
add wave -noupdate -expand -group MEMIN_CNT /intpol2_tb/DUT/addrMemIn_inst/hit_o
add wave -noupdate -expand -group MEMIN_CNT -radix unsigned /intpol2_tb/DUT/addrMemIn_inst/max_cnt_i
add wave -noupdate -expand -group MEMIN_CNT -radix unsigned /intpol2_tb/DUT/addrMemIn_inst/cnt_o
add wave -noupdate -group MEMOUT_OUT /intpol2_tb/DUT/addrMemOut_inst/clrh
add wave -noupdate -group MEMOUT_OUT /intpol2_tb/DUT/addrMemOut_inst/enh
add wave -noupdate -group MEMOUT_OUT /intpol2_tb/DUT/addrMemOut_inst/hit_o
add wave -noupdate -group MEMOUT_OUT -radix unsigned /intpol2_tb/DUT/addrMemOut_inst/max_cnt_i
add wave -noupdate -group MEMOUT_OUT -radix unsigned /intpol2_tb/DUT/addrMemOut_inst/cnt_o
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/m0_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/m1_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/m2_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/c0_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/c0Q_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/c1_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/c2_reg
add wave -noupdate -expand -group DATAPATH /intpol2_tb/DUT/DATA_PATH/p1_reg
add wave -noupdate -expand -group DATAPATH /intpol2_tb/DUT/DATA_PATH/p2_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#29#decimal#signed /intpol2_tb/DUT/DATA_PATH/xi_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#29#decimal#signed /intpol2_tb/DUT/DATA_PATH/GF_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#29#decimal#signed /intpol2_tb/DUT/DATA_PATH/xi2nd_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#29#decimal#signed /intpol2_tb/DUT/DATA_PATH/xi2main_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/c0_reg
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/add3_w
add wave -noupdate -expand -group DATAPATH /intpol2_tb/DUT/DATA_PATH/yt_mux/sel_i
add wave -noupdate -expand -group DATAPATH -radix fixed#14#decimal#signed /intpol2_tb/DUT/DATA_PATH/yt_mux/data_o
add wave -noupdate /intpol2_tb/wrEn_o
add wave -noupdate -format Analog-Step -height 88 -max 0.95239300000000016 -min -0.94775399999999999 /intpol2_tb/dataOut
add wave -noupdate -format Analog-Step -height 88 -max 0.9493410000000001 -min -0.94775399999999999 -radix fixed#14#decimal#signed /intpol2_tb/dataIn
add wave -noupdate -expand -group {acc main} /intpol2_tb/DUT/DATA_PATH/xi2main_acc/selector
add wave -noupdate -expand -group {acc main} /intpol2_tb/DUT/DATA_PATH/xi2main_acc/load
add wave -noupdate -expand -group {acc main} /intpol2_tb/DUT/DATA_PATH/xi2main_acc/a_in
add wave -noupdate -expand -group {acc main} /intpol2_tb/DUT/DATA_PATH/xi2main_acc/b_in
add wave -noupdate -expand -group {acc main} /intpol2_tb/DUT/DATA_PATH/xi2main_acc/acc_out
add wave -noupdate -expand -group {acc main} /intpol2_tb/DUT/DATA_PATH/xi2main_acc/sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {278093 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {144214 ps} {448448 ps}
