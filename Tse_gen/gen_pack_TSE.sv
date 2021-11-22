module gen_pack_TSE (
input clk_i,
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
input gen_readdatavalid_AvMM_M_i,
input gen_waitrequest_AvMM_M_i,

output [7:0]gen_address_AvMM_M_o,
output gen_write_AvMM_M_o,
output [31:0]gen_writedata_AvMM_M_o,
output gen_read_AvMM_M_o

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
logic flagMM_1;
logic flagMM_2;
logic flagMM_3;
logic flagMM_4;
logic flagMM_5;

//Avalon-MM Master
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
	    gen_address_AvMM_M_o_tv   <= 0;
        gen_write_AvMM_M_o_tv     <= 0;
        gen_writedata_AvMM_M_o_tv <= 0;
        gen_read_AvMM_M_o_tv      <= 0;
		
		flag_init_TSE <= 0;
		flagMM_1      <= 0;
		flagMM_2      <= 0;
		flagMM_3      <= 0;
		flagMM_4      <= 0;
		flagMM_5      <= 0;
      end
    else
      begin

		if( flag_init_TSE <= 0 )
		  begin
		    if( flagMM_1 == 0 )                          //stop Tx/Rx, Reset
		      begin
			    gen_address_AvMM_M_o_tv   <= 8'h2;
				gen_writedata_AvMM_M_o_tv <= 32'h2008;   //0)Tx=0, 1)Rx=0, 3)ETH_SPEED=1, 13)SW_RESET=1
				gen_write_AvMM_M_o_tv     <= 1;
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
				    flagMM_2 <= 1;
					gen_read_AvMM_M_o_tv      <= 0;
				  end
			  end
			else if( flagMM_3 == 0 )
			  begin
			    gen_read_AvMM_M_o_tv      <= 0;
				
				if( gen_readdatavalid_AvMM_M_i == 1 )
				  if( gen_readdata_AvMM_M_i == 32'h2008 )
                    flagMM_3   <= 1;
				  else
				    begin
					  flagMM_1 <= 0;
		              flagMM_2 <= 0;
					end
			  end
			else if( flagMM_4 == 0 )                     //start
			  begin
			    gen_address_AvMM_M_o_tv   <= 8'h2;
				gen_writedata_AvMM_M_o_tv <= 32'b1011;   //0)Tx=0, 1)Rx=0, 3)ETH_SPEED=1
				gen_write_AvMM_M_o_tv     <= 1;
				if( gen_waitrequest_AvMM_M_i == 0 )
				  flagMM_4 <= 1;
			  end
			else if( flagMM_5 == 0 )                     //Read check
			  begin
			    gen_write_AvMM_M_o_tv     <= 0;
				
				gen_address_AvMM_M_o_tv   <= 8'h2;
				gen_read_AvMM_M_o_tv      <= 1;
				if( gen_waitrequest_AvMM_M_i == 0 )
				  flagMM_5 <= 1;
			  end
			else
			  begin
			    gen_read_AvMM_M_o_tv      <= 0;
				
				if( gen_readdatavalid_AvMM_M_i == 1 )
				  if( gen_readdata_AvMM_M_i == 32'b1011 )
				    begin
					  flag_init_TSE <= 1;
					  flagMM_1      <= 0;
		              flagMM_2      <= 0;
		              flagMM_3      <= 0;
		              flagMM_4      <= 0;
		              flagMM_5      <= 0;
					end
				  else
				    begin
					  flagMM_4 <= 0;
		              flagMM_5 <= 0;
					end
			  end
		  end    //end flag_init_TSE	
          
      end
  end

  
assign gen_readdata_AvMM_S_o      = gen_readdata_AvMM_S_o_tv;
assign gen_readdatavalid_AvMM_S_o = gen_readdatavalid_AvMM_S_o_tv;
assign gen_waitrequest_AvMM_S_o   = gen_waitrequest_AvMM_S_o_tv;

assign gen_address_AvMM_M_o   = gen_address_AvMM_M_o_tv;
assign gen_write_AvMM_M_o     = gen_write_AvMM_M_o_tv;
assign gen_writedata_AvMM_M_o = gen_writedata_AvMM_M_o_tv;
assign gen_read_AvMM_M_o      = gen_read_AvMM_M_o_tv;

////------
endmodule