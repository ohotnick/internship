
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

#test line
add wave -noupdate -divider -height 40 {GEN INTERFACE} 
if [regexp {/tb/dut_gen/clk_i} [find signals /tb/dut_gen/clk_i]]                        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/clk_i}
if [regexp {/tb/dut_gen/srst_i} [find signals /tb/dut_gen/srst_i]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/srst_i}

if [regexp {/tb/dut_gen/gen_readdata_AvMM_M_i} [find signals /tb/dut_gen/gen_readdata_AvMM_M_i]]                      {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_readdata_AvMM_M_i}
if [regexp {/tb/dut_gen/gen_readdatavalid_AvMM_M_i} [find signals /tb/dut_gen/gen_readdatavalid_AvMM_M_i]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_readdatavalid_AvMM_M_i}
if [regexp {/tb/dut_gen/gen_waitrequest_AvMM_M_i} [find signals /tb/dut_gen/gen_waitrequest_AvMM_M_i]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_waitrequest_AvMM_M_i}
if [regexp {/tb/dut_gen/gen_address_AvMM_M_o} [find signals /tb/dut_gen/gen_address_AvMM_M_o]]                        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_address_AvMM_M_o}
if [regexp {/tb/dut_gen/gen_write_AvMM_M_o} [find signals /tb/dut_gen/gen_write_AvMM_M_o]]                            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_write_AvMM_M_o}
if [regexp {/tb/dut_gen/gen_writedata_AvMM_M_o} [find signals /tb/dut_gen/gen_writedata_AvMM_M_o]]                    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_writedata_AvMM_M_o}
if [regexp {/tb/dut_gen/gen_read_AvMM_M_o} [find signals /tb/dut_gen/gen_read_AvMM_M_o]]                              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut_gen/gen_read_AvMM_M_o}


add wave -noupdate -divider -height 40 {RECEIVE INTERFACE}
if [regexp {/tb/dut/tbi_rx_d} [find signals /tb/dut/tbi_rx_d]]              {add wave -noupdate -divider {  PMA TBI RX}}
if [regexp {/tb/dut/tbi_rx_clk} [find signals /tb/dut/tbi_rx_clk]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/tbi_rx_clk}
if [regexp {/tb/dut/tbi_rx_d} [find signals /tb/dut/tbi_rx_d]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/tbi_rx_d}

if [regexp {/tb/dut/tbi_rx_d_0} [find signals /tb/dut/tbi_rx_d_0]]              {add wave -noupdate -divider {  PMA TBI RX 0}}
if [regexp {/tb/dut/tbi_rx_clk_0} [find signals /tb/dut/tbi_rx_clk_0]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/tbi_rx_clk_0}
if [regexp {/tb/dut/tbi_rx_d_0} [find signals /tb/dut/tbi_rx_d_0]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/tbi_rx_d_0}



if [regexp {/tb/dut/rxp} [find signals /tb/dut/rxp]]                        {add wave -noupdate -divider {  PMA SERIAL RX}}
if [regexp {/tb/dut/ref_clk} [find signals /tb/dut/ref_clk]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ref_clk}
if [regexp {/tb/dut/rxp} [find signals /tb/dut/rxp]]                        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rxp}

if [regexp {/tb/dut/rxp_0} [find signals /tb/dut/rxp_0]]                        {add wave -noupdate -divider {  PMA SERIAL RX 0}}
if [regexp {/tb/dut/rxp_0} [find signals /tb/dut/rxp_0]]                        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rxp_0}



if [regexp {/tb/dut/gm_rx_err} [find signals /tb/dut/gm_rx_err]]            {add wave -noupdate -divider {  GMII RX}}
if [regexp {/tb/dut/gmii_rx_err} [find signals /tb/dut/gmii_rx_err]]        {add wave -noupdate -divider {  GMII RX}}
if [regexp {/tb/dut/rx_clk} [find signals /tb/dut/rx_clk]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clk}
if [regexp {/tb/dut/rx_clkena} [find signals /tb/dut/rx_clkena]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clkena}
if [regexp {/tb/dut/gm_rx_err} [find signals /tb/dut/gm_rx_err]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_rx_err}
if [regexp {/tb/dut/gm_rx_dv} [find signals /tb/dut/gm_rx_dv]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_rx_dv}
if [regexp {/tb/dut/gm_rx_d} [find signals /tb/dut/gm_rx_d]]                {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/gm_rx_d}
if [regexp {/tb/dut/gmii_rx_err} [find signals /tb/dut/gmii_rx_err]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gmii_rx_err}
if [regexp {/tb/dut/gmii_rx_dv} [find signals /tb/dut/gmii_rx_dv]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gmii_rx_dv}
if [regexp {/tb/dut/gmii_rx_d} [find signals /tb/dut/gmii_rx_d]]            {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/gmii_rx_d}

if [regexp {/tb/dut/gm_rx_err_0} [find signals /tb/dut/gm_rx_err_0]]            {add wave -noupdate -divider {  GMII RX 0}}
if [regexp {/tb/dut/gmii_rx_err_0} [find signals /tb/dut/gmii_rx_err_0]]        {add wave -noupdate -divider {  GMII RX 0}}
if [regexp {/tb/dut/rx_clk_0} [find signals /tb/dut/rx_clk_0]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clk_0}
if [regexp {/tb/dut/gm_rx_err_0} [find signals /tb/dut/gm_rx_err_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_rx_err_0}
if [regexp {/tb/dut/gm_rx_dv_0} [find signals /tb/dut/gm_rx_dv_0]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gm_rx_dv_0}
if [regexp {/tb/dut/gm_rx_d_0} [find signals /tb/dut/gm_rx_d_0]]                {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/gm_rx_d_0}
if [regexp {/tb/dut/gmii_rx_err_0} [find signals /tb/dut/gmii_rx_err_0]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gmii_rx_err_0}
if [regexp {/tb/dut/gmii_rx_dv_0} [find signals /tb/dut/gmii_rx_dv_0]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/gmii_rx_dv_0}
if [regexp {/tb/dut/gmii_rx_d_0} [find signals /tb/dut/gmii_rx_d_0]]            {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/gmii_rx_d_0}



if [regexp {/tb/dut/rgmii_in} [find signals /tb/dut/rgmii_in]]              {add wave -noupdate -divider {  RGMII RX}}
if [regexp {/tb/dut/rx_control} [find signals /tb/dut/rx_control]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_control}
if [regexp {/tb/dut/rgmii_in} [find signals /tb/dut/rgmii_in]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/rgmii_in}

if [regexp {/tb/dut/rgmii_in_0} [find signals /tb/dut/rgmii_in_0]]              {add wave -noupdate -divider {  RGMII RX 0}}
if [regexp {/tb/dut/rx_control_0} [find signals /tb/dut/rx_control_0]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_control_0}
if [regexp {/tb/dut/rgmii_in_0} [find signals /tb/dut/rgmii_in_0]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/rgmii_in_0}


if [regexp {/tb/dut/m_rx_d} [find signals /tb/dut/m_rx_d]]                  {add wave -noupdate -divider {  MII RX}}
if [regexp {/tb/dut/mii_rx_d} [find signals /tb/dut/mii_rx_d]]              {add wave -noupdate -divider {  MII RX}}
if [regexp {/tb/dut/rx_clk} [find signals /tb/dut/rx_clk]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clk}
if [regexp {/tb/dut/rx_clkena} [find signals /tb/dut/rx_clkena]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clkena}
if [regexp {/tb/dut/m_rx_err} [find signals /tb/dut/m_rx_err]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_err}
if [regexp {/tb/dut/m_rx_en} [find signals /tb/dut/m_rx_en]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_en}
if [regexp {/tb/dut/m_rx_d} [find signals /tb/dut/m_rx_d]]                  {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/m_rx_d}
if [regexp {/tb/dut/m_rx_crs} [find signals /tb/dut/m_rx_crs]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_crs}
if [regexp {/tb/dut/m_rx_col} [find signals /tb/dut/m_rx_col]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_col}
if [regexp {/tb/dut/mii_rx_err} [find signals /tb/dut/mii_rx_err]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_err}
if [regexp {/tb/dut/mii_rx_dv} [find signals /tb/dut/mii_rx_dv]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_dv}
if [regexp {/tb/dut/mii_rx_d} [find signals /tb/dut/mii_rx_d]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mii_rx_d}
if [regexp {/tb/dut/mii_rx_crs} [find signals /tb/dut/mii_rx_crs]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_crs}
if [regexp {/tb/dut/mii_rx_col} [find signals /tb/dut/mii_rx_col]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_col}

if [regexp {/tb/dut/m_rx_d_0} [find signals /tb/dut/m_rx_d_0]]                  {add wave -noupdate -divider {  MII RX 0}}
if [regexp {/tb/dut/mii_rx_d_0} [find signals /tb/dut/mii_rx_d_0]]              {add wave -noupdate -divider {  MII RX 0}}
if [regexp {/tb/dut/rx_clk_0} [find signals /tb/dut/rx_clk_0]]                  {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_clk_0}
if [regexp {/tb/dut/m_rx_err_0} [find signals /tb/dut/m_rx_err_0]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_err_0}
if [regexp {/tb/dut/m_rx_en_0} [find signals /tb/dut/m_rx_en_0]]                {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_en_0}
if [regexp {/tb/dut/m_rx_d_0} [find signals /tb/dut/m_rx_d_0]]                  {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/m_rx_d_0}
if [regexp {/tb/dut/m_rx_crs_0} [find signals /tb/dut/m_rx_crs_0]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_crs_0}
if [regexp {/tb/dut/m_rx_col_0} [find signals /tb/dut/m_rx_col_0]]              {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/m_rx_col_0}
if [regexp {/tb/dut/mii_rx_err_0} [find signals /tb/dut/mii_rx_err_0]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_err_0}
if [regexp {/tb/dut/mii_rx_dv_0} [find signals /tb/dut/mii_rx_dv_0]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_dv_0}
if [regexp {/tb/dut/mii_rx_d_0} [find signals /tb/dut/mii_rx_d_0]]              {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mii_rx_d_0}
if [regexp {/tb/dut/mii_rx_crs_0} [find signals /tb/dut/mii_rx_crs_0]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_crs_0}
if [regexp {/tb/dut/mii_rx_col_0} [find signals /tb/dut/mii_rx_col_0]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/mii_rx_col_0}


if [regexp {/tb/dut/ff_rx_data} [find signals /tb/dut/ff_rx_data]]          {add wave -noupdate -divider {  FIFO RX}}
if [regexp {/tb/dut/ff_rx_clk} [find signals /tb/dut/ff_rx_clk]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_clk}
if [regexp {/tb/dut/ff_rx_data} [find signals /tb/dut/ff_rx_data]]          {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/ff_rx_data}
if [regexp {/tb/dut/ff_rx_sop} [find signals /tb/dut/ff_rx_sop]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_sop}
if [regexp {/tb/dut/ff_rx_eop} [find signals /tb/dut/ff_rx_eop]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_eop}
if [regexp {/tb/dut/ff_rx_rdy} [find signals /tb/dut/ff_rx_rdy]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_rdy}
if [regexp {/tb/dut/ff_rx_dval} [find signals /tb/dut/ff_rx_dval]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_dval}
if [regexp {/tb/dut/ff_rx_dsav} [find signals /tb/dut/ff_rx_dsav]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_dsav}
if [regexp {/tb/dut/rx_frm_type} [find signals  /tb/dut/rx_frm_type]]       {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/rx_frm_type}
if [regexp {/tb/dut/rx_err_stat} [find signals /tb/dut/rx_err_stat]]        {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/rx_err_stat}
if [regexp {/tb/dut/rx_err} [find signals /tb/dut/rx_err]]                  {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/rx_err}
if [regexp {/tb/dut/ff_rx_mod} [find signals /tb/dut/ff_rx_mod]]            {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/ff_rx_mod}
if [regexp {/tb/dut/ff_rx_a_full} [find signals /tb/dut/ff_rx_a_full]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_a_full}
if [regexp {/tb/dut/ff_rx_a_empty} [find signals /tb/dut/ff_rx_a_empty]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_rx_a_empty}

if [regexp {/tb/dut/rx_afull_clk} [find signals /tb/dut/rx_afull_clk]]                  {add wave -noupdate -divider {  EXTERNAL AVALON ST RX FIFO STATUS}}
if [regexp {/tb/dut/rx_afull_clk} [find signals /tb/dut/rx_afull_clk]]                  {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/rx_afull_clk}
if [regexp {/tb/dut/rx_afull_channel} [find signals /tb/dut/rx_afull_channel]]            {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/rx_afull_channel}
if [regexp {/tb/dut/rx_afull_data} [find signals /tb/dut/rx_afull_data]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_afull_data}
if [regexp {/tb/dut/rx_afull_valid]} [find signals /tb/dut/rx_afull_valid]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/rx_afull_valid]}



add wave -noupdate -divider -height 40 {TRANSMIT INTERFACE}
if [regexp {/tb/dut/ff_tx_data} [find signals /tb/dut/ff_tx_data]]          {add wave -noupdate -divider {  FIFO TX}}
if [regexp {/tb/dut/ff_tx_clk} [find signals /tb/dut/ff_tx_clk]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_clk}
if [regexp {/tb/dut/ff_tx_data} [find signals /tb/dut/ff_tx_data]]          {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/ff_tx_data}
if [regexp {/tb/dut/ff_tx_sop} [find signals /tb/dut/ff_tx_sop]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_sop}
if [regexp {/tb/dut/ff_tx_eop} [find signals /tb/dut/ff_tx_eop]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_eop}
if [regexp {/tb/dut/ff_tx_rdy} [find signals /tb/dut/ff_tx_rdy]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_rdy}
if [regexp {/tb/dut/ff_tx_wren} [find signals /tb/dut/ff_tx_wren]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_wren}
if [regexp {/tb/dut/ff_tx_crc_fwd} [find signals /tb/dut/ff_tx_crc_fwd]]    {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_crc_fwd}
if [regexp {/tb/dut/ff_tx_err} [find signals /tb/dut/ff_tx_err]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_err}
if [regexp {/tb/dut/ff_tx_mod} [find signals /tb/dut/ff_tx_mod]]            {add wave -noupdate -format Literal -radix hexadecimal /tb/dut/ff_tx_mod}
if [regexp {/tb/dut/ff_tx_septy} [find signals /tb/dut/ff_tx_septy]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_septy}
if [regexp {/tb/dut/tx_ff_uflow} [find signals /tb/dut/tx_ff_uflow]]        {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/tx_ff_uflow}
if [regexp {/tb/dut/ff_tx_a_full} [find signals /tb/dut/ff_tx_a_full]]            {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_a_full}
if [regexp {/tb/dut/ff_tx_a_empty} [find signals /tb/dut/ff_tx_a_empty]]          {add wave -noupdate -format Logic -radix hexadecimal /tb/dut/ff_tx_a_empty}

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

