
`timescale 1 ns / 10 ps


module tb ;



//  Core Settings 
//  WARNING: DO NOT MODIFY THESE PARAMETERS
//  -------------------------------
// $<RTL_PARAMETERS>
//parameter ENABLE_MAGIC_DETECT = 0;
//parameter ENABLE_MDIO = 0;
//parameter ENABLE_SUP_ADDR = 0;
//parameter CORE_VERSION = 3328;
//parameter MDIO_CLK_DIV = 40;
//parameter ENA_HASH = 0;
//parameter STAT_CNT_ENA = 1;
//parameter ENABLE_HD_LOGIC = 0;
//parameter REDUCED_INTERFACE_ENA = 0;
//parameter ENABLE_GMII_LOOPBACK = 0;
//parameter ENABLE_MAC_FLOW_CTRL = 0;
//parameter ENABLE_MAC_RX_VLAN = 0;
//parameter ENABLE_MAC_TX_VLAN = 0;
//parameter SYNCHRONIZER_DEPTH = 3;
//parameter ENABLE_EXTENDED_STAT_REG = 0;
//parameter ENABLE_MAC_TXADDR_SET = 1;
//parameter CRC32GENDELAY = 6;
//parameter CRC32S1L2_EXTERN = 0;
//parameter CRC32DWIDTH = 8;
//parameter CRC32CHECK16BIT = 0;
//parameter CUST_VERSION = 0;
//parameter RESET_LEVEL = 1;
//parameter USE_SYNC_RESET = 1;
//parameter TSTAMP_FP_WIDTH = 4;
//parameter MAX_CHANNELS = 1;
//parameter ENABLE_CLK_SHARING = 0;
//parameter ENABLE_SHIFT16 = 1;
//parameter ENABLE_MACLITE = 0;
//parameter MACLITE_GIGE = 0;
//parameter ENABLE_ENA = 0;
//parameter EG_ADDR = 8;
//parameter ING_ADDR = 8;
parameter REG_ADDR_WIDTH = 8;
//parameter RX_AFULL_CHANNEL_WIDTH = 1;

// END_OF_RTL_PARAMETERS


//  Register Interface
//  ------------------

logic     reg_clk;                        //  25MHz Host Interface Clock
logic     reg_rd;                         //  Register Read Strobe
logic     reg_wr;                         //  Register Write Strobe
logic     [REG_ADDR_WIDTH - 1:0] reg_addr;                 //  Register Address
logic     [31:0] reg_data_in;             //  Write Data for Host Bus
logic     [31:0] reg_data_out;            //  Read Data to Host Bus
logic     reg_busy;                       //  Interface Busy
logic     reg_busy_reg;                   //  Interface Busy
logic     magic_sleep_n;                     //  Enable Sleep Mode
logic     reg_wakeup;                     //  Wake Up Request

logic  reset;

logic  [31:0]readdata_gen_tse;
logic  readdatavalid_gen_tse;
logic  waitrequest_gen_tse;

logic  [7:0]address_gen_tse;
logic  write_gen_tse;
logic  [31:0]writedata_gen_tse;
logic  read_gen_tse;

//  Clocks
//  ------

//  initial 
//    forever 
 //       #100 reg_clk=!reg_clk;
		
always 
   //begin : process_26
   begin
   reg_clk <= 1'b 1;    
   #( 10 ); 
   reg_clk <= 1'b 0;    
   #( 10 ); 
   end
		
initial
  begin
    @( posedge reg_clk )
      reset <= 1'b1;	  
    @( posedge reg_clk )
      reset <= 1'b0;
  end
  
initial
  begin
    reg_rd      <= 0;
	reg_wr      <= 0;
	reg_data_in <= 32'h2008;
	
	#( 50 )
	  reg_wr   <= 1'h 1;
	  reg_addr <= 8'h 2;
	@( negedge waitrequest_gen_tse )
	 begin
	  reg_wr   <= 1'h 0;
	  
	//#( 50 )
	  reg_rd   <= 1'h 1;
	  reg_addr <= 8'h 2;
	  end
	@( negedge waitrequest_gen_tse )
	  reg_rd   <= 1'h 0;
	  
	  
  end
  
 

 
// $<RTL_CORE_INSTANCE>
Tse_1 dut
(
   .gm_tx_en_0        ( ),
   .gm_rx_err_0       ( ),
   .gm_tx_err_0       ( ),
   .gm_rx_dv_0        ( ),
   .gm_tx_d_0         ( ),
   .gm_rx_d_0         ( ),
   .clk               (reg_clk),
   .mac_rx_clk_0      ( ),
   .rx_afull_valid    ( ),
   .rx_afull_data     ( ),
   .rx_afull_channel  ( ),
   .tx_clk_0          ( ),
   .magic_wakeup_0    ( ),
   .xoff_gen_0        ( ),
   .tx_crc_fwd_0      ( ),
   .magic_sleep_n_0   ( ),
   .xon_gen_0         ( ),
   .data_rx_eop_0     ( ),
   .data_rx_data_0    ( ),
   .data_rx_valid_0   ( ),
   .data_rx_error_0   ( ),
   .data_rx_sop_0     ( ),
   .data_rx_ready_0   ( ),
   .pkt_class_valid_0 ( ),
   .pkt_class_data_0  ( ),
   .rx_clk_0          ( ),
   .data_tx_error_0   ( ),
   .data_tx_valid_0   ( ),
   .data_tx_data_0    ( ),
   .data_tx_ready_0   ( ),
   .data_tx_sop_0     ( ),
   .data_tx_eop_0     ( ),
   .waitrequest       (waitrequest_gen_tse),
   .address           (address_gen_tse),
//      .address           (reg_addr),                        	//test
   .writedata         (writedata_gen_tse),
//      .writedata         (reg_data_in),						//test
   .write             (write_gen_tse),
//      .write             (reg_wr),							//test
   .read              (read_gen_tse),
//      .read              (reg_rd),							//test
   .readdata          (readdata_gen_tse),
   .mac_tx_clk_0      ( ),
   .m_rx_err_0        ( ),
   .m_rx_en_0         ( ),
   .m_tx_err_0        ( ),
   .m_tx_d_0          ( ),
   .m_rx_d_0          ( ),
   .m_tx_en_0         ( ),
   .eth_mode_0        ( ),
   .set_10_0          ( ),
   .ena_10_0          ( ),
   .set_1000_0        ( ),
   .reset             (reset),
   .rx_afull_clk      ( )
);

gen_pack_TSE dut_gen (

    .clk_i                  (reg_clk),
	.srst_i                 (reset),

//Avalon-MM Slave. Init gen
    .gen_address_AvMM_S_i       (),
    .gen_write_AvMM_S_i         ( ),
    .gen_writedata_AvMM_S_i     ( ),
    .gen_read_AvMM_S_i          ( ),

    .gen_readdata_AvMM_S_o      ( ),
    .gen_readdatavalid_AvMM_S_o ( ),
    .gen_waitrequest_AvMM_S_o   ( ),

//Avalon-MM Master. Init TSE
    .gen_readdata_AvMM_M_i      (readdata_gen_tse),
    .gen_readdatavalid_AvMM_M_i (readdatavalid_gen_tse),
    .gen_waitrequest_AvMM_M_i   (waitrequest_gen_tse),

    .gen_address_AvMM_M_o       (address_gen_tse),
    .gen_write_AvMM_M_o         (write_gen_tse),
    .gen_writedata_AvMM_M_o     (writedata_gen_tse),
    .gen_read_AvMM_M_o          (read_gen_tse)

);

 
endmodule // module tb
