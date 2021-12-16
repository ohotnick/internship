#test script tcl

# RUN_SCRIPT_PARAMETERS
#set QSYS_SIMDIR ../Tse_1_sim
#текущий каталог
#set QSYS_SIMDIR ..
#set QSYS_SIMDIR "C:/Users/qver/Desktop/tst_script"
set QSYS_SIMDIR .
set dut_wave_do Tse_1_wave.do
set testbench_model_dir ./models

set TOP_LEVEL_NAME tb

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                   
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                 
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_eth_tse_fifoless_mac.v"        
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_clk_cntl.v"                
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_crc328checker.v"           
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_crc328generator.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_crc32ctl8.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_crc32galois8.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_gmii_io.v"                 
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_lb_read_cntl.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_lb_wrt_cntl.v"             
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_hashing.v"                 
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_host_control.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_host_control_small.v"      
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mac_control.v"             
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_register_map.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_register_map_small.v"      
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_counter_cntl.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_shared_mac_control.v"      
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_shared_register_map.v"     
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_counter_cntl.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_lfsr_10.v"                 
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_loopback_ff.v"             
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_altshifttaps.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_fifoless_mac_rx.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mac_rx.v"                  
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_fifoless_mac_tx.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mac_tx.v"                  
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_magic_detection.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mdio.v"                    
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mdio_clk_gen.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mdio_cntl.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_mdio.v"                
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mii_rx_if.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mii_tx_if.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_pipeline_base.v"           
  vlog -sv "$QSYS_SIMDIR/submodules/mentor/altera_tse_pipeline_stage.sv"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_dpram_16x32.v"             
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_dpram_8x32.v"              
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_quad_16x32.v"              
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_quad_8x32.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_fifoless_retransmit_cntl.v"
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_retransmit_cntl.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rgmii_in1.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rgmii_in4.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rgmii_module.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rgmii_out1.v"              
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rgmii_out4.v"              
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_ff.v"                   
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_min_ff.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_ff_cntrl.v"             
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_ff_cntrl_32.v"          
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_ff_cntrl_32_shift16.v"  
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_ff_length.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_rx_stat_extract.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_timing_adapter32.v"        
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_timing_adapter8.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_timing_adapter_fifo32.v"   
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_timing_adapter_fifo8.v"    
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_1geth.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_fifoless_1geth.v"      
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_w_fifo.v"              
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_w_fifo_10_100_1000.v"  
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_wo_fifo.v"             
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_wo_fifo_10_100_1000.v" 
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_mac_woff.v"                
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_top_gen_host.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_ff.v"                   
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_min_ff.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_ff_cntrl.v"             
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_ff_cntrl_32.v"          
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_ff_cntrl_32_shift16.v"  
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_ff_length.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_ff_read_cntl.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tx_stat_extract.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_false_path_marker.v"       
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_reset_synchronizer.v"      
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_clock_crosser.v"           
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_a_fifo_13.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_a_fifo_24.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_a_fifo_34.v"               
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_a_fifo_opt_1246.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_a_fifo_opt_14_44.v"        
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_a_fifo_opt_36_10.v"        
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_gray_cnt.v"                
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_sdpm_altsyncram.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_altsyncram_dpm_fifo.v"     
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_bin_cnt.v"                 
  vlog -sv "$QSYS_SIMDIR/submodules/mentor/altera_tse_ph_calculator.sv"          
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_sdpm_gen.v"                
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_dc_fifo.v"                 
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_ptp_inserter.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_avst_to_gmii_if.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_gmii_to_avst_if.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_ptp_1588_crc.v"            
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_ptp_1588_rx_top.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_ptp_1588_tx_top.v"         
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_timestamp_req_ctrl.v"      
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_tse_tsu.v"                     
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_eth_tse_channel_adapter.v"     
  vlog     "$QSYS_SIMDIR/submodules/mentor/altera_eth_tse_avalon_arbiter.v"      
  vlog     "$QSYS_SIMDIR/Tse_1.v"     

  vlog     gen_pack_TSE.sv  
}


# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  vsim -novopt -t ps -L work -L work_lib -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver $TOP_LEVEL_NAME
  #vsim -novopt $TOP_LEVEL_NAME

}


# Compile the design files in correct order
com

# Compile testbench
vlog -work work +incdir+$testbench_model_dir $testbench_model_dir/*.v
vlog -work work *.sv

# Elaborate top level design
elab_debug

do $dut_wave_do

# Run the simulation
run -all
#run 40000000