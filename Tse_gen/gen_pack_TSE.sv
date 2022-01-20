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
				bank_reg[0][24]           <= 0;
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
					    flagMM_3        <= 0;
						bank_reg[0][24] <= 1;
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
		bank_reg[2]          <= 0;
		bank_reg[3]          <= 0;
		
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
		//flagTest_ram <= cout_one_sec;
          
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
logic [10:0]size_frame;
logic [31:0]count_pack_work;

logic [13:0] cout_one_sec;   //125Mhz 1/10000 sec
logic [31:0] count_time_work;

logic flag_work_speed;
logic [9:0]work_speed;
logic [9:0]wait_speed;
logic [9:0]wait_speed_const;
logic [10:0]count_work_speed;

logic flag_start_size;
logic [1:0]count_rnd_start;
logic flag_count1;
logic flag_count2;
logic flag_count3;
logic [10:0]count_rnd_1;
logic [9:0]count_rnd_2;
logic [9:0]count_rnd_3;
logic [10:0]count_rnd_1_a;
logic [9:0]count_rnd_2_a;
logic [9:0]count_rnd_3_a;
logic [10:0]rand_range;
logic [1:0]count_queue;

logic [10:0]value_rnd_1;
logic [9:0]value_rnd_2;
logic [9:0]value_rnd_3;
   
//Avalon-ST Source
always_ff @( posedge clk_tx_i )
  begin
    if(srst_i)
      begin
        gen_data_o_tv          <= 0;
		gen_valid_o_tv         <= 0;
		gen_startofpacket_o_tv <= 0;
		gen_endofpacket_o_tv   <= 0;
		
		count_32to8     <= 0;
		flag_start_TX   <= 0;
		size_tv         <= 5;
		count_end_tx    <= 0;
		flag_SOP        <= 0;
		count_pack_work <= 0;
		
		flag_work_speed  <= 0;
		work_speed       <= 0;
		count_work_speed <= 0;
		wait_speed       <= 0;
		wait_speed_const <= 0;
		
		count_queue      <= 1;
		value_rnd_1      <= 0;
		value_rnd_2      <= 0;
		value_rnd_3      <= 0;
		count_rnd_1_a    <= 0;
		count_rnd_2_a    <= 0;
		count_rnd_3_a    <= 0;
      end
    else
      begin
	    if(( flag_start_TX == 1 ) && ( flag_work_speed == 0 ))
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
				
				//rnd
                if(flag_count3 == 1)				
				  count_queue <= count_queue + 1;         
				
				if( bank_reg[0][1] == 1 )
				  if((((count_queue == 2'h3)||(count_queue == 2'h1))||((count_queue == 2'h2)&&(count_rnd_2_a >= count_rnd_2))||((count_queue == 2'h0)&&(count_rnd_3_a >= count_rnd_3)))&&(count_rnd_1_a < count_rnd_1))
					  begin
					    count_rnd_1_a <= count_rnd_1_a + 1;
						value_rnd_1   <= (value_rnd_1 << 2) + value_rnd_1 + 1;
						
						size_frame    <= value_rnd_1 + bank_reg[4][10:0];
					  end
					else if(((count_queue == 2'h2)||((count_queue == 2'h3)||(count_queue == 2'h1))||((count_queue == 2'h0)&&(count_rnd_3_a >= count_rnd_3)))&&(count_rnd_2_a < count_rnd_2))
					  begin
					    count_rnd_2_a <= count_rnd_2_a + 1;
						value_rnd_2   <= (value_rnd_2 << 2) + value_rnd_2 + 1;
						
						size_frame    <= value_rnd_2 + bank_reg[4][10:0] + count_rnd_1;
					  end
					else if(count_rnd_3_a < count_rnd_3)
					  begin
					    count_rnd_3_a <= count_rnd_3_a + 1;
						value_rnd_3   <= value_rnd_3 + 1;
						
						size_frame    <= value_rnd_3 + bank_reg[4][10:0] + count_rnd_1 + count_rnd_2;
					  end
					  //назначаем я прошлого расчета в 0 SOP
				  //rnd end
		      end
			if( flag_SOP == 1 )
			  if( gen_ready_i == 1 )
			    begin
				
				  //rnd
				  if((count_rnd_1_a >= count_rnd_1)&&(count_rnd_2_a >= count_rnd_2)&&(count_rnd_2_a >= count_rnd_2))
					  begin
					    if(count_rnd_1 != 0)
						  count_rnd_1_a <= 0;
						if(count_rnd_2 != 0)
						  count_rnd_2_a <= 0;
						if(count_rnd_3 != 0)
						  begin
						    count_rnd_3_a <= 0;
							value_rnd_3   <= 0;
						  end
					  end
				  else
				    begin
					  //value_rnd_1 <= value_rnd_1[4:0];
					  //value_rnd_2 <= value_rnd_2[4:0];
					  
					  if(count_rnd_1 == 11'h400)    //1024
                        value_rnd_1 <= value_rnd_1[9:0];
				      else if(count_rnd_1 == 11'h200)    //512
                        value_rnd_1 <= value_rnd_1[8:0];
				      else if(count_rnd_1 == 11'h100)    //256
                        value_rnd_1 <= value_rnd_1[7:0];
				      else if(count_rnd_1 == 11'h80)    //128
                        value_rnd_1 <= value_rnd_1[6:0];
				      else if(count_rnd_1 == 11'h40)    //64
				        value_rnd_1 <= value_rnd_1[5:0];
				      else if(count_rnd_1 == 11'h20)    //32
				        value_rnd_1 <= value_rnd_1[4:0];
				      else if(count_rnd_1 == 11'h10)    //16
				        value_rnd_1 <= value_rnd_1[3:0];
				      else if(count_rnd_1 == 11'h8)    //8
				        value_rnd_1 <= value_rnd_1[2:0];
				      else if(count_rnd_1 == 11'h4)   //4
				        value_rnd_1 <= value_rnd_1[1:0];
				      else if(count_rnd_1 == 11'h2)    //2
				        value_rnd_1 <= value_rnd_1[0];
						
					 if(count_rnd_2 == 11'h200)    //512
                        value_rnd_2 <= value_rnd_2[8:0];
				      else if(count_rnd_2 == 11'h100)    //256
                        value_rnd_2 <= value_rnd_2[7:0];
				      else if(count_rnd_2 == 11'h80)    //128
                        value_rnd_2 <= value_rnd_2[6:0];
				      else if(count_rnd_2 == 11'h40)    //64
				        value_rnd_2 <= value_rnd_2[5:0];
				      else if(count_rnd_2 == 11'h20)    //32
				        value_rnd_2 <= value_rnd_2[4:0];
				      else if(count_rnd_2 == 11'h10)    //16
				        value_rnd_2 <= value_rnd_2[3:0];
				      else if(count_rnd_2 == 11'h8)    //8
				        value_rnd_2 <= value_rnd_2[2:0];
				      else if(count_rnd_2 == 11'h4)   //4
				        value_rnd_2 <= value_rnd_2[1:0];
				      else if(count_rnd_2 == 11'h2)    //2
				        value_rnd_2 <= value_rnd_2[0];
					  
					end
				   //rnd end
				
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
			if(( count_end_tx == size_frame ) && ( gen_endofpacket_o_tv == 0 ))
			  begin
			    gen_endofpacket_o_tv <= 1;
				count_32to8          <= 0;
				size_tv              <= 5;
				count_end_tx         <= 0;
				if(( bank_reg[0][2] == 0 ) && ( bank_reg[2] != 0)) 
				  count_pack_work      <= count_pack_work + 1;
				
				if(( (count_pack_work + 1) >= bank_reg[2]) && ( bank_reg[0][2] == 0 ))
				  begin
				    bank_reg[0][0]       <= 0;
				    flag_start_TX        <= 0;
				    count_pack_work      <= 0;
					flag_SOP             <= 0;
				  end
				else if(( count_time_work >= bank_reg[3]) && ( bank_reg[0][2] == 1 ))
				  begin
				    bank_reg[0][0]       <= 0;
				    flag_start_TX        <= 0;
				    count_pack_work      <= 0;
					flag_SOP             <= 0;
				  end
				  
		      end
			else if(( gen_endofpacket_o_tv == 1 ))
			  begin
			    if( gen_ready_i == 1 )
			      begin
			        gen_endofpacket_o_tv <= 0;
			    	gen_valid_o_tv       <= 0;
					flag_SOP             <= 0;
					
					if( count_work_speed != 0 )
					  begin
					    flag_work_speed <= 1;
					  end
					
			      end
			  end
		    
			if((( count_pack_work == bank_reg[2]) && ( bank_reg[0][2] == 0 )) || (( count_time_work >= bank_reg[3]) && ( bank_reg[0][2] == 1 )))
			  begin
			    count_work_speed     <= 0;
			    work_speed           <= 0;
			  end
			else
			  begin
				if( (work_speed + 1) < bank_reg[4][31:22] )
				  work_speed <= work_speed + 1;
				else if( bank_reg[4][31:22] < 1000 )
				  begin
					work_speed       <= 0;
					count_work_speed <= count_work_speed + 1;
				  end
			  end
			
		  end
		else
		  begin
		    
		    if ( bank_reg[0][0] == 1 )
			  begin
                flag_start_TX   <= 1;

			  end
		  
		    if( gen_ready_i == 1 )
			  begin
			    gen_endofpacket_o_tv <= 0;
				gen_valid_o_tv       <= 0;
			  end
			  
			wait_speed_const <= 1000 - bank_reg[4][31:22];
			  
			if(( flag_work_speed == 1 )&&( flag_start_TX == 1 ))              //count wait
			  begin
			    
			    if( (wait_speed + 1) < wait_speed_const )
			      wait_speed <= wait_speed + 1;
			    else 
			      begin
				    count_work_speed <= count_work_speed - 1;
					wait_speed       <= 0;
					if( (count_work_speed - 1) == 0 )
					  begin
						flag_work_speed <= 0;
					  end
			      end
			  end
			else if(( flag_work_speed == 1 )&&( flag_start_TX == 0 ))
			  flag_work_speed <= 0;
			  
		  end //else
		  
	  end
	end
	
always_ff @( posedge clk_tx_i )
  begin
    if(srst_i)
      begin
        size_frame      <= 60;
		flag_start_size <= 0;
		count_rnd_start <= 0;
		flag_count1     <= 0;
		flag_count2     <= 0;
		flag_count3     <= 0;
		count_rnd_1     <= 0;
		count_rnd_2     <= 0;
		count_rnd_3     <= 0;
		rand_range      <= 0;
		
      end
    else
      begin
		
	    count_rnd_start <= count_rnd_start + 1;
	  
		if (( bank_reg[0][0] == 1 ) && ( flag_start_size == 0 ))
		  begin
		  
		    if( bank_reg[0][1] == 0 )
              if( bank_reg[0][13:3] != 0 )
			    size_frame <= bank_reg[0][13:3];			  
			  else
			    size_frame <= 60;
			else if( bank_reg[0][1] == 1 )                                     //start value
			  if(( bank_reg[4][10:0] != 0 ) && ( bank_reg[4][21:11] != 0 ))
			    begin
				  if(count_rnd_start == 0)
				    size_frame <= bank_reg[4][10:0];
				  else if(count_rnd_start == 1)
				    size_frame <= bank_reg[4][21:11];
				end
			  else
			    size_frame <= 60;
				
			flag_start_size <= 1;
			
			rand_range <= bank_reg[4][21:11] - bank_reg[4][10:0] + 1;
		  end
		  
		if( flag_start_size == 1 )
		  begin
		  
		    if(flag_count1 == 0)
              begin
			    if(rand_range > 11'h400)    //1024
				  begin
				    count_rnd_1 <= 11'h400;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h200)    //512
				  begin
				    count_rnd_1 <= 11'h200;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h100)    //256
				  begin
				    count_rnd_1 <= 11'h100;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h80)    //128
				  begin
				    count_rnd_1 <= 11'h80;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h40)    //64
				  begin
				    count_rnd_1 <= 11'h40;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h20)    //32
				  begin
				    count_rnd_1 <= 11'h20;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h10)    //16
				  begin
				    count_rnd_1 <= 11'h10;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h8)    //8
				  begin
				    count_rnd_1 <= 11'h8;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h4)    //4
				  begin
				    count_rnd_1 <= 11'h4;
					flag_count1 <= 1;
				  end
				else if(rand_range > 11'h2)    //2
				  begin
				    count_rnd_1 <= 11'h2;
					flag_count1 <= 1;
				  end
				else
				  begin
				    count_rnd_1 <= 0;
					flag_count1 <= 1;
				  end
			  end
			else if(flag_count2 == 0)
			  begin
                if((rand_range - count_rnd_1) > 11'h200)    //512
				  begin
				    count_rnd_2 <= 11'h200;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h100)    //256
				  begin
				    count_rnd_2 <= 11'h100;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h80)    //128
				  begin
				    count_rnd_2 <= 11'h80;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h40)    //64
				  begin
				    count_rnd_2 <= 11'h40;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h20)    //32
				  begin
				    count_rnd_2 <= 11'h20;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h10)    //16
				  begin
				    count_rnd_2 <= 11'h10;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h8)    //8
				  begin
				    count_rnd_2 <= 11'h8;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h4)    //4
				  begin
				    count_rnd_2 <= 11'h4;
					flag_count2 <= 1;
				  end
				else if((rand_range - count_rnd_1) > 11'h2)    //2
				  begin
				    count_rnd_2 <= 11'h2;
					flag_count2 <= 1;
				  end
				else
				  begin
				    count_rnd_2 <= 0;
					flag_count2 <= 1;
				  end
              end
            else if(flag_count3 == 0)			  
			  begin
			    count_rnd_3 <= rand_range - count_rnd_1 - count_rnd_2;
			    flag_count3 <= 1;
			  end
			 
		  end                     //end flag_start_size = 1 work
		
		
		if(( bank_reg[0][0] == 0 ) && ( flag_start_size == 1 ))
		  begin
		    flag_start_size <= 0;
			flag_count1     <= 0;
			flag_count2     <= 0;
			flag_count3     <= 0;
		  end
		
      end
  end
  
always_ff @( posedge clk_tx_i )
  begin
    if(srst_i)
      begin
        cout_one_sec    <= 0;
		count_time_work <= 0;
      end
    else
      begin
	  
	    if( flag_start_TX == 0 )
		  begin
		    cout_one_sec    <= 0;
			count_time_work <= 0;
	      end
		else if( cout_one_sec >= 32'h30d4 )
		  begin
		    cout_one_sec    <= 0;
			count_time_work <= count_time_work + 1;
	      end
		else if( flag_start_TX == 1 )
		  begin
		    cout_one_sec <= cout_one_sec + 1;
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