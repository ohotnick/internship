module gen_pack_TSE (
input clk_i,
input clk_tx_i,
input srst_i,

//Avalon-MM Slave. Init gen
input [8:0]gen_address_AvMM_S_i,
input gen_write_AvMM_S_i,
input [31:0]gen_writedata_AvMM_S_i,
input gen_read_AvMM_S_i,

output [31:0]gen_readdata_AvMM_S_o,
output gen_readdatavalid_AvMM_S_o,
output gen_waitrequest_AvMM_S_o,

//Avalon-MM Master. Init TSE
input [31:0]gen_readdata_AvMM_M_i,
input gen_waitrequest_AvMM_M_i,

output [7:0]gen_address_AvMM_M_o,
output gen_write_AvMM_M_o,
output [31:0]gen_writedata_AvMM_M_o,
output gen_read_AvMM_M_o,

//Avalon-ST Source
input  gen_ready_i,

output [7:0]gen_data_o,
output gen_valid_o,
output gen_startofpacket_o,
output gen_endofpacket_o

);

//Avalon-MM
logic [31:0] bank_reg[511:0];       //bank_reg

//Avalon-MM gen Slave
logic [31:0]gen_readdata_AvMM_S_o_tv;
logic gen_readdatavalid_AvMM_S_o_tv;
logic gen_waitrequest_AvMM_S_o_tv;

//Avalon-MM Slave
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
        gen_readdata_AvMM_S_o_tv      <= 0;
        gen_readdatavalid_AvMM_S_o_tv <= 0;
        gen_waitrequest_AvMM_S_o_tv   <= 0;
      end
    else
      begin

		if( gen_waitrequest_AvMM_S_o_tv == 0 )
		  begin
		    if( gen_write_AvMM_S_i == 1 )
		      begin
		        bank_reg [gen_address_AvMM_S_i]  <= gen_writedata_AvMM_S_i;
		      end
		
		    if( gen_read_AvMM_S_i == 1 )
		      begin
		        gen_readdatavalid_AvMM_S_o_tv <= 1;
		        gen_readdata_AvMM_S_o_tv      <= bank_reg [gen_address_AvMM_S_i];
		      end
		  end

		if(( gen_read_AvMM_S_i == 0 ) && ( gen_readdatavalid_AvMM_S_o_tv == 1 ))
		  gen_readdatavalid_AvMM_S_o_tv <= 0;
		
          
      end
  end  
  
//Avalon-MM Master
logic [7:0]gen_address_AvMM_M_o_tv;
logic gen_write_AvMM_M_o_tv;
logic [31:0]gen_writedata_AvMM_M_o_tv;
logic gen_read_AvMM_M_o_tv;

logic flag_init_TSE;
logic flag_read_TSE;
logic flag_write_TSE;
logic flagMM_1;
logic flagMM_2;
logic flagMM_3;
logic [31:0]flagTest_ram;

logic flag_start_TSE;
logic flag_start_read_TSE;
logic flag_start_write_TSE;

//Avalon-MM Master
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
	    gen_address_AvMM_M_o_tv   <= 0;
        gen_write_AvMM_M_o_tv     <= 0;
        gen_writedata_AvMM_M_o_tv <= 0;
        gen_read_AvMM_M_o_tv      <= 0;
		
		flag_init_TSE  <= 0;
		flag_read_TSE  <= 0;
		flag_write_TSE <= 0;
		flagMM_1       <= 0;
		flagMM_2       <= 0;
		flagMM_3       <= 0;

      end
    else
      begin

        if( flag_start_TSE == 1 )
		  flag_init_TSE <= 1;
		else if( (flag_start_read_TSE == 1 ) & ( flag_write_TSE == 0 ))
		  flag_read_TSE <= 1;
		else if( flag_start_write_TSE == 1 )
		  flag_write_TSE <= 1;

		if( flag_init_TSE == 1 )                         //SW_RESET and Itit TSE reg
		  begin
		    if( flagMM_1 == 0 )                          //stop Tx/Rx, Reset
		      begin
			    gen_address_AvMM_M_o_tv   <= 8'h2;
				gen_writedata_AvMM_M_o_tv <= 32'h2008;   //0)Tx=0, 1)Rx=0, 3)ETH_SPEED=1, 13)SW_RESET=1
				gen_write_AvMM_M_o_tv     <= 1;
				
				bank_reg[0][24] <= 0;
				
				if( gen_waitrequest_AvMM_M_i == 0 )
				  begin
				    flagMM_1 <= 1;
					gen_write_AvMM_M_o_tv     <= 0;
				  end
			  end
			else if( flagMM_2 == 0 )                     //Read
			  begin
			    gen_write_AvMM_M_o_tv     <= 0;
				
				gen_address_AvMM_M_o_tv   <= 8'h2;
				gen_read_AvMM_M_o_tv      <= 1;
				if( gen_waitrequest_AvMM_M_i == 0 )
				  begin
					gen_read_AvMM_M_o_tv  <= 0;
					if( gen_readdata_AvMM_M_i == 32'h2008 )
                      flagMM_2   <= 1;
				    else
				      begin
				    	flagMM_1 <= 0;
		                flagMM_2 <= 0;
				      end
				  end
			  end
			else if( flagMM_3 == 0 )                     //start
			  begin
			    gen_address_AvMM_M_o_tv   <= 8'h2;
				//gen_writedata_AvMM_M_o_tv <= 32'b100111011;   //0)Tx=0, 1)Rx=0, 3)ETH_SPEED=1 4)PROMIS_EN=1 5)PAD_EN = 1 8)PAUSE_IGNORE = 1
				gen_writedata_AvMM_M_o_tv <= 32'h900001b;   //0,1,3,4,24,27
				gen_write_AvMM_M_o_tv     <= 1;
				if( gen_waitrequest_AvMM_M_i == 0 )
				  begin
				    flagMM_3 <= 1;
				    gen_write_AvMM_M_o_tv <= 0;
					end
			  end
			else                     //Read check
			  begin
			    gen_write_AvMM_M_o_tv     <= 0;
				
				gen_address_AvMM_M_o_tv   <= 8'h2;
				gen_read_AvMM_M_o_tv      <= 1;
				if( gen_waitrequest_AvMM_M_i == 0 )
				  begin
					gen_read_AvMM_M_o_tv  <= 0;
					
					if( gen_readdata_AvMM_M_i == 32'h900001b )
				      begin
					    flag_init_TSE <= 0;
					    flagMM_1      <= 0;
		                flagMM_2      <= 0;
		                flagMM_3      <= 0;
				      end
				    else
				      begin
					    flagMM_3 <= 0;
				      end
					
				  end
			  end

		  end    //end flag_init_TSE	
		  
        else if( flag_read_TSE == 1 )
		  begin
		    gen_address_AvMM_M_o_tv     <= bank_reg[0][21:14];
		    gen_read_AvMM_M_o_tv        <= 1;
			gen_waitrequest_AvMM_S_o_tv <= 1;
			bank_reg[0][22]             <= 0;
			if( gen_waitrequest_AvMM_M_i == 0 )
			  begin
			    gen_waitrequest_AvMM_S_o_tv <= 0;
				gen_read_AvMM_M_o_tv        <= 0;
				bank_reg[1]                 <= gen_readdata_AvMM_M_i;
				flag_read_TSE               <= 0;
			  end
		  end     // end read
		else if( flag_write_TSE == 1 )
		  begin
		    gen_address_AvMM_M_o_tv     <= bank_reg[0][21:14];
			gen_writedata_AvMM_M_o_tv   <= bank_reg[1];
			gen_write_AvMM_M_o_tv       <= 1;
			gen_waitrequest_AvMM_S_o_tv <= 1;
			bank_reg[0][23]             <= 0;
			if( gen_waitrequest_AvMM_M_i == 0 )
			  begin
			    gen_waitrequest_AvMM_S_o_tv <= 0;
			    flag_write_TSE              <= 0;
			    gen_write_AvMM_M_o_tv       <= 0;
			  end
		  end
		  
      end
  end
  
  
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
        flag_start_TSE       <= 0;
        flag_start_read_TSE  <= 0;
		flag_start_write_TSE <= 0;
		bank_reg[0]          <= 0;
		bank_reg[1]          <= 0;
		
		flagTest_ram         <= 0;
      end
    else
      begin
        
		if ( bank_reg[0][24] == 1 )
          flag_start_TSE <= 1;
		if ( bank_reg[0][24] == 0 )
          flag_start_TSE <= 0;
		
		if ( bank_reg[0][22] == 0 )
              flag_start_read_TSE <= 0;
		if ( bank_reg[0][23] == 0 )
              flag_start_write_TSE <= 0;
			
		if ( bank_reg[0][22] == 1 )
          flag_start_read_TSE <= 1;
		    
		if ( bank_reg[0][23] == 1 )
          flag_start_write_TSE <= 1;  
		  
		flagTest_ram <= bank_reg[0];
          
      end
  end

//Avalon-ST Source
logic [7:0]gen_data_o_tv;
logic gen_valid_o_tv;
logic gen_startofpacket_o_tv;
logic gen_endofpacket_o_tv;

logic flag_start_TX;
logic flag_SOP;
logic [1:0]count_32to8;
logic [10:0]size_tv;
logic [10:0]count_end_tx;
   
//Avalon-ST Source
always_ff @( posedge clk_tx_i )
  begin
    if(srst_i)
      begin
        gen_data_o_tv          <= 0;
		gen_valid_o_tv         <= 0;
		gen_startofpacket_o_tv <= 0;
		gen_endofpacket_o_tv   <= 0;
		
		count_32to8   <= 0;
		flag_start_TX <= 0;
		size_tv       <= 5;
		count_end_tx  <= 0;
		flag_SOP      <= 0;
      end
    else
      begin
	    if( flag_start_TX == 1 )
		  begin
            
			if( flag_SOP == 0 )
			  begin
			    gen_startofpacket_o_tv <= 1;
				gen_valid_o_tv         <= 1;
				flag_SOP               <= 1;
				gen_data_o_tv          <= bank_reg[5][7:0];
				
				count_32to8 <= count_32to8 + 1;
			      if( count_32to8 == 3 )
			        size_tv <= size_tv + 1;
		      end
			if( flag_SOP == 1 )
			  if( gen_ready_i == 1 )
			    begin
			      gen_startofpacket_o_tv <= 0;
				  
				  if( count_32to8 == 0)
				    gen_data_o_tv <= bank_reg[size_tv][7:0];
				  else if( count_32to8 == 1)
				    gen_data_o_tv <= bank_reg[size_tv][15:8];
				  else if( count_32to8 == 2)
				    gen_data_o_tv <= bank_reg[size_tv][23:16];
				  else if( count_32to8 == 3)
				    gen_data_o_tv <= bank_reg[size_tv][32:24];
				  
				  count_32to8  <= count_32to8 + 1;
				  count_end_tx <= count_end_tx + 1;
			      if( count_32to8 == 3 )
			        size_tv <= size_tv + 1;
				end
			if( count_end_tx == 74 )
			  begin
			    gen_endofpacket_o_tv <= 1;
				flag_start_TX        <= 0;
				bank_reg[0][0]       <= 0;
				flag_SOP             <= 0;
				count_32to8          <= 0;
				size_tv              <= 5;
				count_end_tx         <= 0;
		      end
		    
		  end
		else
		  begin
		    
		    if ( bank_reg[0][0] == 1 )
              flag_start_TX <= 1;
		  
		    if( gen_ready_i == 1 )
			  begin
			    gen_endofpacket_o_tv <= 0;
				gen_valid_o_tv       <= 0;
			  end
		  end
		  
        
		  
		  
	  end
	end

  
assign gen_readdata_AvMM_S_o      = gen_readdata_AvMM_S_o_tv;
assign gen_readdatavalid_AvMM_S_o = gen_readdatavalid_AvMM_S_o_tv;
assign gen_waitrequest_AvMM_S_o   = gen_waitrequest_AvMM_S_o_tv;

assign gen_address_AvMM_M_o   = gen_address_AvMM_M_o_tv;
assign gen_write_AvMM_M_o     = gen_write_AvMM_M_o_tv;
assign gen_writedata_AvMM_M_o = gen_writedata_AvMM_M_o_tv;
assign gen_read_AvMM_M_o      = gen_read_AvMM_M_o_tv;

assign gen_data_o          = gen_data_o_tv;
assign gen_valid_o         = gen_valid_o_tv;
assign gen_startofpacket_o = gen_startofpacket_o_tv;
assign gen_endofpacket_o   = gen_endofpacket_o_tv;

////------
endmodule