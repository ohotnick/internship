
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider -height 40 {TESTBENCH INTERFACE}
if [regexp {/tb/reset} [find signals /tb/reset]]                            {add wave -noupdate -format Logic -radix hexadecimal /tb/reset}
if [regexp {/tb/reset_model} [find signals /tb/reset_model]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/reset_model}
if [regexp {/tb/reset_mdio} [find signals /tb/reset_mdio]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/reset_mdio}
if [regexp {/tb/state} [find signals /tb/state]]                            {add wave -noupdate -format Literal -radix unsigned /tb/state}
if [regexp {/tb/nextstate} [find signals /tb/nextstate]]                    {add wave -noupdate -format Literal -radix unsigned /tb/nextstate}
if [regexp {/tb/sim_start} [find signals /tb/sim_start]]                    {add wave -noupdate -format Logic -radix hexadecimal /tb/sim_start}
if [regexp {/tb/sim_stop} [find signals /tb/sim_stop]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/sim_stop}
if [regexp {/tb/frm_gen_ena_gmii} [find signals /tb/frm_gen_ena_gmii]]      {add wave -noupdate -format Logic /tb/frm_gen_ena_gmii}
if [regexp {/tb/frm_gen_ena_mii} [find signals /tb/frm_gen_ena_mii]]        {add wave -noupdate -format Logic /tb/frm_gen_ena_mii}
if [regexp {/tb/rxframe_cnt} [find signals /tb/rxframe_cnt]]                {add wave -noupdate -format Literal -radix unsigned /tb/rxframe_cnt}
if [regexp {/tb/rx_frm_cnt} [find signals /tb/rx_frm_cnt]]                  {add wave -noupdate -format Literal -radix unsigned /tb/rx_frm_cnt}
if [regexp {/tb/rxsim_done} [find signals /tb/rxsim_done]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/rxsim_done}
if [regexp {/tb/txframe_cnt} [find signals /tb/txframe_cnt]]                {add wave -noupdate -format Literal -radix unsigned /tb/txframe_cnt}
if [regexp {/tb/tx_frm_cnt} [find signals /tb/tx_frm_cnt]]                  {add wave -noupdate -format Literal -radix unsigned /tb/tx_frm_cnt}
if [regexp {/tb/txsim_done} [find signals /tb/txsim_done]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/txsim_done}


add wave -noupdate -divider -height 40 {CONTROL INTERFACE}  
if [regexp {/tb/dut/reset} [find signals /tb/dut/reset]]                    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reset}
if [regexp {/tb/dut/reset_reg_clk} [find signals /tb/dut/reset_reg_clk]]    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reset_reg_clk}
if [regexp {/tb/dut/reset_tx_clk} [find signals /tb/dut/reset_tx_clk]]      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reset_tx_clk}
if [regexp {/tb/dut/reset_rx_clk} [find signals /tb/dut/reset_rx_clk]]      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reset_rx_clk}
if [regexp {/tb/dut/clk} [find signals /tb/dut/clk]]                        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/clk}
if [regexp {/tb/dut/address} [find signals /tb/dut/address]]                {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/address}
if [regexp {/tb/dut/readdata} [find signals /tb/dut/readdata]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/readdata}
if [regexp {/tb/dut/read} [find signals /tb/dut/read]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/read}
if [regexp {/tb/dut/writedata} [find signals /tb/dut/writedata]]            {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/writedata}
if [regexp {/tb/dut/write} [find signals /tb/dut/write]]                    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/write}
if [regexp {/tb/dut/waitrequest} [find signals /tb/dut/waitrequest]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/waitrequest}
if [regexp {/tb/dut/reg_clk} [find signals /tb/dut/reg_clk]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reg_clk}
if [regexp {/tb/dut/reg_addr} [find signals /tb/dut/reg_addr]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/reg_addr}
if [regexp {/tb/dut/reg_data_in} [find signals /tb/dut/reg_data_in]]        {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/reg_data_in}
if [regexp {/tb/dut/reg_rd} [find signals /tb/dut/reg_rd]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reg_rd}
if [regexp {/tb/dut/reg_data_out} [find signals /tb/dut/reg_data_out]]      {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/reg_data_out}
if [regexp {/tb/dut/reg_wr} [find signals /tb/dut/reg_wr]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reg_wr}
if [regexp {/tb/dut/reg_busy} [find signals /tb/dut/reg_busy]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/reg_busy}

if [regexp {/tb/dut_gen/flagTest_ram} [find signals /tb/dut_gen/flagTest_ram]]   {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/flagTest_ram}

#test line
add wave -noupdate -divider -height 40 {GEN INTERFACE} 
add wave -noupdate -divider -height 40 {AVALON-MM M} 
if [regexp {/tb/dut_gen/clk_i} [find signals /tb/dut_gen/clk_i]]                        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/clk_i}
if [regexp {/tb/dut_gen/next_MM} [find signals /tb/dut_gen/next_MM]]                 {add wave -noupdate -format Logic  /tb/dut_gen/next_MM}
if [regexp {/tb/dut_gen/srst_i} [find signals /tb/dut_gen/srst_i]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/srst_i}

if [regexp {/tb/dut_gen/gen_readdata_AvMM_M_i} [find signals /tb/dut_gen/gen_readdata_AvMM_M_i]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_readdata_AvMM_M_i}
if [regexp {/tb/dut_gen/gen_readdatavalid_AvMM_M_i} [find signals /tb/dut_gen/gen_readdatavalid_AvMM_M_i]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_readdatavalid_AvMM_M_i}
if [regexp {/tb/dut_gen/gen_waitrequest_AvMM_M_i} [find signals /tb/dut_gen/gen_waitrequest_AvMM_M_i]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_waitrequest_AvMM_M_i}
if [regexp {/tb/dut_gen/gen_address_AvMM_M_o} [find signals /tb/dut_gen/gen_address_AvMM_M_o]]                        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_address_AvMM_M_o}
if [regexp {/tb/dut_gen/gen_write_AvMM_M_o} [find signals /tb/dut_gen/gen_write_AvMM_M_o]]                            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_write_AvMM_M_o}
if [regexp {/tb/dut_gen/gen_writedata_AvMM_M_o} [find signals /tb/dut_gen/gen_writedata_AvMM_M_o]]                    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_writedata_AvMM_M_o}
if [regexp {/tb/dut_gen/gen_read_AvMM_M_o} [find signals /tb/dut_gen/gen_read_AvMM_M_o]]                              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_read_AvMM_M_o}

add wave -noupdate -divider -height 40 {AVALON-MM S}
if [regexp {/tb/dut_gen/gen_address_AvMM_S_i} [find signals /tb/dut_gen/gen_address_AvMM_S_i]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_address_AvMM_S_i}
if [regexp {/tb/dut_gen/gen_write_AvMM_S_i} [find signals /tb/dut_gen/gen_write_AvMM_S_i]]                          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_write_AvMM_S_i}
if [regexp {/tb/dut_gen/gen_writedata_AvMM_S_i} [find signals /tb/dut_gen/gen_writedata_AvMM_S_i]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_writedata_AvMM_S_i}
if [regexp {/tb/dut_gen/gen_read_AvMM_S_i} [find signals /tb/dut_gen/gen_read_AvMM_S_i]]                            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_read_AvMM_S_i}

if [regexp {/tb/dut_gen/gen_readdata_AvMM_S_o} [find signals /tb/dut_gen/gen_readdata_AvMM_S_o]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_readdata_AvMM_S_o}
if [regexp {/tb/dut_gen/gen_readdatavalid_AvMM_S_o} [find signals /tb/dut_gen/gen_readdatavalid_AvMM_S_o]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_readdatavalid_AvMM_S_o}
if [regexp {/tb/dut_gen/gen_waitrequest_AvMM_S_o} [find signals /tb/dut_gen/gen_waitrequest_AvMM_S_o]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_waitrequest_AvMM_S_o}


add wave -noupdate -divider -height 40 {TRANSMIT INTERFACE}
if [regexp {/tb/dut/tx_clk_0} [find signals /tb/dut/tx_clk_0]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/tx_clk_0}
if [regexp {/tb/dut_gen/next_ST} [find signals /tb/dut_gen/next_ST]]                 {add wave -noupdate -format Logic  /tb/dut_gen/next_ST}
if [regexp {/tb/dut/data_tx_data_0} [find signals /tb/dut/data_tx_data_0]]          {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/data_tx_data_0}
if [regexp {/tb/dut/data_tx_sop_0} [find signals /tb/dut/data_tx_sop_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_tx_sop_0}
if [regexp {/tb/dut/data_tx_eop_0} [find signals /tb/dut/data_tx_eop_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_tx_eop_0}
if [regexp {/tb/dut/data_tx_ready_0} [find signals /tb/dut/data_tx_ready_0]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_tx_ready_0}
if [regexp {/tb/dut_gen/gen_ready_i} [find signals /tb/dut_gen/gen_ready_i]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_ready_i}
if [regexp {/tb/dut/data_tx_valid_0} [find signals /tb/dut/data_tx_valid_0]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_tx_valid_0}
if [regexp {/tb/dut/data_tx_error_0} [find signals /tb/dut/data_tx_error_0]]         {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_tx_error_0}

add wave -noupdate -divider -height 40 {GMII TX INTERFACE}
if [regexp {/tb/dut/tx_clk_0} [find signals /tb/dut/tx_clk_0]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/tx_clk_0}
if [regexp {/tb/dut/gm_tx_err_0} [find signals /tb/dut/gm_tx_err_0]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_tx_err_0}
if [regexp {/tb/dut/gm_tx_en_0} [find signals /tb/dut/gm_tx_en_0]]                  {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/gm_tx_en_0}
if [regexp {/tb/dut/gm_tx_d_0} [find signals /tb/dut/gm_tx_d_0]]                    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_tx_d_0}

add wave -noupdate -divider -height 40 {GMII RX INTERFACE}
if [regexp {/tb/dut/tx_clk_0} [find signals /tb/dut/tx_clk_0]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/tx_clk_0}
if [regexp {/tb/dut/gm_rx_err_0} [find signals /tb/dut/gm_rx_err_0]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_rx_err_0}
if [regexp {/tb/dut/gm_rx_dv_0} [find signals /tb/dut/gm_rx_dv_0]]                  {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/gm_rx_dv_0}
if [regexp {/tb/dut/gm_rx_d_0} [find signals /tb/dut/gm_rx_d_0]]                    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_rx_d_0}

add wave -noupdate -divider -height 40 {RECEIVE INTERFACE}
if [regexp {/tb/dut/rx_clk_0} [find signals /tb/dut/rx_clk_0]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clk_0}
if [regexp {/tb/dut/data_rx_data_0} [find signals /tb/dut/data_rx_data_0]]          {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/data_rx_data_0}
if [regexp {/tb/dut/data_rx_sop_0} [find signals /tb/dut/data_rx_sop_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_rx_sop_0}
if [regexp {/tb/dut/data_rx_eop_0} [find signals /tb/dut/data_rx_eop_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_rx_eop_0}
if [regexp {/tb/dut/data_rx_ready_0} [find signals /tb/dut/data_rx_ready_0]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_rx_ready_0}
if [regexp {/tb/dut/data_rx_valid_0} [find signals /tb/dut/data_rx_valid_0]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_rx_valid_0}
if [regexp {/tb/dut/data_rx_error_0} [find signals /tb/dut/data_rx_error_0]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_rx_error_0}

add wave -noupdate -divider -height 40 {RAND}
if [regexp {/tb/dut/rx_clk_0} [find signals /tb/dut/rx_clk_0]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clk_0}
if [regexp {/tb/dut/data_tx_data_0} [find signals /tb/dut/data_tx_data_0]]          {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/data_tx_data_0}
if [regexp {/tb/dut/data_tx_sop_0} [find signals /tb/dut/data_tx_sop_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_tx_sop_0}
if [regexp {/tb/dut/data_tx_eop_0} [find signals /tb/dut/data_tx_eop_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/data_tx_eop_0}
if [regexp {/tb/dut_gen/flag_SOP} [find signals /tb/dut_gen/flag_SOP]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/flag_SOP}
if [regexp {/tb/dut_gen/count_queue} [find signals /tb/dut_gen/count_queue]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/count_queue}
if [regexp {/tb/dut_gen/value_rnd_1} [find signals /tb/dut_gen/value_rnd_1]]        {add wave -noupdate -format Logic -radix decimal /tb/dut_gen/value_rnd_1}
if [regexp {/tb/dut_gen/value_rnd_2} [find signals /tb/dut_gen/value_rnd_2]]        {add wave -noupdate -format Logic -radix decimal /tb/dut_gen/value_rnd_2}
if [regexp {/tb/dut_gen/value_rnd_3} [find signals /tb/dut_gen/value_rnd_3]]        {add wave -noupdate -format Logic -radix decimal /tb/dut_gen/value_rnd_3}
if [regexp {/tb/dut_gen/rand_range_1_count} [find signals /tb/dut_gen/rand_range_1_count]]    {add wave -noupdate -format Logic -radix decimal /tb/dut_gen/rand_range_1_count}
if [regexp {/tb/dut_gen/rand_range_2_count} [find signals /tb/dut_gen/rand_range_2_count]]    {add wave -noupdate -format Logic -radix decimal /tb/dut_gen/rand_range_2_count}
if [regexp {/tb/dut_gen/rand_range_3_count} [find signals /tb/dut_gen/rand_range_3_count]]    {add wave -noupdate -format Logic -radix decimal /tb/dut_gen/rand_range_3_count}
if [regexp {/tb/dut_gen/size_pack} [find signals /tb/dut_gen/size_pack]]          {add wave -noupdate -format Logic -radix decimal /tb/dut_gen/size_pack}


add wave -noupdate -divider -height 40 {ALL WIRE}
add wave -r *



TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 201
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ps} {20 us}

