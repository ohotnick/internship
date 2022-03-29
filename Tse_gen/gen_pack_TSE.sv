module gen_pack_TSE (
input clk_i,
input srst_i,

//Avalon-MM Slave. Init gen
input [9:0]gen_address_AvMM_S_i,
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
struct{
  logic [31:0]control;
  logic [31:0]count_pack_work;
  logic [31:0]time_work;
  logic [31:0]rand_val_speed;
  } gen_reg;

//Avalon-MM Slave
parameter ADDR_REG      = 10'h3;
parameter ADDR_RAM_1    = 10'h10;
parameter ADDR_RAM_2    = 10'h17D;
parameter ADDR_TSE_1    = 10'h200;
parameter ADDR_TSE_2    = 10'h2E3;
parameter VAL_NOT_FOUND = 32'h404;
parameter INIT_BIT      = 24;
parameter START_S_BIT   = 0;
parameter SIZE_PACK_BIT = 1;
parameter PACK_OR_SEC   = 2;

parameter DATA_WIDTH    = 32;
parameter ADDR_WIDTH    = 9;  

parameter TSE_REG_ADR_COMCONF   = 8'h2;
parameter TSE_REG_VAL_RESET     = 32'h2008;      //0)Tx=0, 1)Rx=0, 3)ETH_SPEED=1, 13)SW_RESET=1
parameter TSE_REG_VAL_RESET_COR = 32'h8;         //0)Tx=0, 1)Rx=0, 3)ETH_SPEED=1, 13)SW_RESET=1
parameter TSE_REG_VAL_2_COMCONF = 32'h900001b;   //0,1,3,4,24,27

parameter GEN_VAL_PART_OF_SEC   = 32'h30d4;      //125Mhz 1/10000 sec

parameter RANGE_1024  = 11'h400;    //1024
parameter RANGE_512   = 11'h200;    //512
parameter RANGE_256   = 11'h100;    //256
parameter RANGE_128   = 11'h80;     //128
parameter RANGE_64    = 11'h40;     //64
parameter RANGE_32    = 11'h20;     //32
parameter RANGE_16    = 11'h10;     //16
parameter RANGE_8     = 11'h8;      //8
parameter RANGE_4     = 11'h4;      //4
parameter RANGE_2     = 11'h2;      //2
parameter QUEUE_VAL_0 = 2'h0; 
parameter QUEUE_VAL_1 = 2'h1;
parameter QUEUE_VAL_2 = 2'h2;
parameter QUEUE_VAL_3 = 2'h3;

//Avalon-MM gen Slave
logic [31:0]gen_readdata_AvMM_S_o_tv;
logic gen_readdatavalid_AvMM_S_o_tv;
logic gen_waitrequest_AvMM_S_o_tv;

//Avalon-MM Master
logic [7:0]gen_address_AvMM_M_o_tv;
logic gen_write_AvMM_M_o_tv;
logic [31:0]gen_writedata_AvMM_M_o_tv;
logic gen_read_AvMM_M_o_tv;

logic we_tv;
logic [(ADDR_WIDTH-1):0] r_w_addr_tv;
logic [(ADDR_WIDTH-1):0] r_w_addr_tv_ST;
logic [(DATA_WIDTH-1):0] q_tv;

simple_ram     #(
            .DATA_WIDTH (DATA_WIDTH),
            .ADDR_WIDTH (ADDR_WIDTH)
        )     simple_ram_ex (
                .clk        (clk_i),
                .we         (we_tv),
                .data       (gen_writedata_AvMM_S_i),
                .r_w_addr   ((gen_reg.control[START_S_BIT] == 1) ? r_w_addr_tv_ST : r_w_addr_tv ),
                
                .q          (q_tv)
                );


typedef enum logic [2:0] {IDLE         = 3'b000,
                          WORK_REG     = 3'b001,
                          WORK_RAM     = 3'b010,
                          TSE_RW       = 3'b011,
                          INIT_TSE_ST  = 3'b100,
                          INIT_TSE_RD  = 3'b101,
                          INIT_TSE_WR  = 3'b110,
                          INIT_TSE_CHK = 3'b111,
                          XXX      = 'x    } state_e_MM;                    
                          
state_e_MM state_MM, next_MM;
                          
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      state_MM <= IDLE;
    else
      state_MM <= next_MM;
  end
  
logic [31:0]flagTest_ram;
assign flagTest_ram = gen_reg.control; 
  
always_comb
  begin
    next_MM = XXX;
    case (state_MM)
      IDLE:         if( gen_reg.control[INIT_BIT] == 1 )
                      next_MM = INIT_TSE_ST;
                    else if(( gen_address_AvMM_S_i <= ADDR_REG )&&((gen_write_AvMM_S_i == 1)||(gen_read_AvMM_S_i == 1)))
                      next_MM = WORK_REG;
                    else if((( ADDR_RAM_1 <= gen_address_AvMM_S_i )&&(gen_address_AvMM_S_i <= ADDR_RAM_2))&&((gen_write_AvMM_S_i == 1)||(gen_read_AvMM_S_i == 1)))
                      next_MM = WORK_RAM;
                    else if((( ADDR_TSE_1 <= gen_address_AvMM_S_i )&&( gen_address_AvMM_S_i <= ADDR_TSE_2 ))&&((gen_write_AvMM_S_i == 1)||(gen_read_AvMM_S_i == 1)))
                      next_MM = TSE_RW;
                    else
                      next_MM = IDLE;
                      
      WORK_REG:     if( gen_waitrequest_AvMM_S_o_tv == 0 )
                      next_MM = IDLE;
                    else
                      next_MM = WORK_REG;
                      
      WORK_RAM:     if( gen_waitrequest_AvMM_S_o_tv == 0 )
                      next_MM = IDLE;
                    else
                      next_MM = WORK_RAM;
                      
      TSE_RW  :     if( gen_waitrequest_AvMM_S_o_tv == 0 )
                      next_MM = IDLE;
                    else
                      next_MM = TSE_RW;
      INIT_TSE_ST : if( gen_waitrequest_AvMM_M_i == 0 )
                      next_MM = INIT_TSE_RD;
                    else
                      next_MM = INIT_TSE_ST;
      INIT_TSE_RD : if( gen_waitrequest_AvMM_M_i == 0 )
                      if( gen_readdata_AvMM_M_i == TSE_REG_VAL_RESET_COR )
                        next_MM = INIT_TSE_WR;
                      else
                        next_MM = INIT_TSE_RD;
                    else
                      next_MM = INIT_TSE_RD;
      INIT_TSE_WR : if( gen_waitrequest_AvMM_M_i == 0 )
                      next_MM = INIT_TSE_CHK;
                    else
                      next_MM = INIT_TSE_WR;
      INIT_TSE_CHK: if( gen_waitrequest_AvMM_M_i == 0 )
                      next_MM = IDLE;
                    else
                      next_MM = INIT_TSE_CHK;
      
      default:    next_MM = XXX;
    endcase
  end
  
always_ff @(posedge clk_i)
  begin
    if(srst_i)
      begin
        gen_readdata_AvMM_S_o_tv      <= 0;
        gen_readdatavalid_AvMM_S_o_tv <= 0; 
        gen_waitrequest_AvMM_S_o_tv   <= 1;
        gen_reg.control               <= 0;
        gen_reg.count_pack_work       <= 0;
        gen_reg.time_work             <= 0;
        gen_reg.rand_val_speed        <= 0;
        
        we_tv                         <= 0;
        r_w_addr_tv                   <= 0;
      end
    else
      begin
        gen_readdatavalid_AvMM_S_o_tv <= 0; 
        gen_waitrequest_AvMM_S_o_tv   <= 1;
        gen_readdata_AvMM_S_o_tv      <= 0;
            
        we_tv                         <= 0;
        
        gen_write_AvMM_M_o_tv         <= 0;
        gen_read_AvMM_M_o_tv          <= 0;
        
        case (next_MM)
          IDLE:     begin
          
                      if( gen_reg.control[INIT_BIT] == 0 )
                        begin
                          if(( gen_write_AvMM_S_i == 1 ) && (gen_waitrequest_AvMM_S_o_tv != 0))
                            begin
                              gen_waitrequest_AvMM_S_o_tv <= 0;
                            end
                          if(( gen_read_AvMM_S_i == 1 )&&( gen_readdatavalid_AvMM_S_o_tv != 1 ))
                            begin
                              gen_waitrequest_AvMM_S_o_tv   <= 0;
                              gen_readdata_AvMM_S_o_tv      <= VAL_NOT_FOUND;
                              gen_readdatavalid_AvMM_S_o_tv <= 1;
                            end
                        end
                        
                      if( gen_waitrequest_AvMM_M_i == 0 )
                        begin
                          gen_read_AvMM_M_o_tv      <= 0;
                          if( gen_readdata_AvMM_M_i == TSE_REG_VAL_2_COMCONF )
                            gen_reg.control[INIT_BIT] <= 0;
                        end
                      
                    end
          WORK_REG: begin
          
                      if( gen_write_AvMM_S_i == 1 )
                        begin
                          gen_waitrequest_AvMM_S_o_tv <= 0;
                          if( gen_address_AvMM_S_i == 0 )
                            gen_reg.control         <= gen_writedata_AvMM_S_i;
                          else if( gen_address_AvMM_S_i == 10'h1 )
                            gen_reg.count_pack_work <= gen_writedata_AvMM_S_i;
                          else if( gen_address_AvMM_S_i == 10'h2 )
                            gen_reg.time_work       <= gen_writedata_AvMM_S_i;
                          else if( gen_address_AvMM_S_i == 10'h3 )
                            gen_reg.rand_val_speed  <= gen_writedata_AvMM_S_i;
                        end
                      if( gen_read_AvMM_S_i == 1 )
                        begin
                          gen_waitrequest_AvMM_S_o_tv <= 0;
                          if( gen_address_AvMM_S_i == 0 )
                            begin
                              gen_readdata_AvMM_S_o_tv      <= gen_reg.control;
                              gen_readdatavalid_AvMM_S_o_tv <= 1;
                            end
                          else if( gen_address_AvMM_S_i == 10'h1 )
                            begin
                              gen_readdata_AvMM_S_o_tv      <= gen_reg.count_pack_work;
                              gen_readdatavalid_AvMM_S_o_tv <= 1;
                            end
                          else if( gen_address_AvMM_S_i == 10'h2 )
                            begin
                              gen_readdata_AvMM_S_o_tv      <= gen_reg.time_work;
                              gen_readdatavalid_AvMM_S_o_tv <= 1;
                            end
                          else if( gen_address_AvMM_S_i == 10'h3 )
                            begin
                              gen_readdata_AvMM_S_o_tv      <= gen_reg.rand_val_speed;
                              gen_readdatavalid_AvMM_S_o_tv <= 1;
                            end
                        end
                      
                    end
          WORK_RAM: begin
          
                      if( gen_reg.control[START_S_BIT] == 0 )
                        begin
                          if( gen_write_AvMM_S_i == 1 )
                            begin
                              gen_waitrequest_AvMM_S_o_tv <= 0;
                              r_w_addr_tv                 <= ( gen_address_AvMM_S_i[8:0] - ADDR_RAM_1[8:0]);
                              we_tv                       <= 1;
                            end
                          if( gen_read_AvMM_S_i == 1 )
                            begin
                              r_w_addr_tv <= ( gen_address_AvMM_S_i[8:0] - ADDR_RAM_1[8:0]);
                              if(r_w_addr_tv == ( gen_address_AvMM_S_i[8:0] - ADDR_RAM_1[8:0]))
                                begin
                                  gen_waitrequest_AvMM_S_o_tv   <= 0;
                                  gen_readdata_AvMM_S_o_tv      <= q_tv;
                                  gen_readdatavalid_AvMM_S_o_tv <= 1;
                                end
                            end
                        end
                      else
                        gen_waitrequest_AvMM_S_o_tv <= 1;
                    
                    end
          TSE_RW  : begin
                    
                      if( gen_read_AvMM_S_i == 1 )
                        begin
                          gen_address_AvMM_M_o_tv <= ( gen_address_AvMM_S_i[7:0] - ADDR_TSE_1[7:0]);
                          gen_read_AvMM_M_o_tv    <= 1;
                          if( gen_waitrequest_AvMM_M_i == 0 )
                            begin
                              gen_waitrequest_AvMM_S_o_tv   <= 0;
                              gen_readdata_AvMM_S_o_tv      <= gen_readdata_AvMM_M_i;
                              gen_readdatavalid_AvMM_S_o_tv <= 1;
                              gen_read_AvMM_M_o_tv          <= 0;
                            end
                        end
                      if( gen_write_AvMM_S_i == 1 )
                        begin
                          gen_address_AvMM_M_o_tv   <= ( gen_address_AvMM_S_i[7:0] - ADDR_TSE_1[7:0]);
                          gen_writedata_AvMM_M_o_tv <= gen_writedata_AvMM_S_i;
                          gen_write_AvMM_M_o_tv     <= 1;
                          if( gen_waitrequest_AvMM_M_i == 0 )
                            begin
                              gen_waitrequest_AvMM_S_o_tv <= 0;
                              gen_write_AvMM_M_o_tv       <= 0;
                            end
                        end

                    end
        INIT_TSE_ST:begin
                      
                      gen_address_AvMM_M_o_tv   <= TSE_REG_ADR_COMCONF;
                      gen_writedata_AvMM_M_o_tv <= TSE_REG_VAL_RESET;   
                      gen_write_AvMM_M_o_tv     <= 1;
                      
                    end
        INIT_TSE_RD:begin
                      
                      gen_address_AvMM_M_o_tv   <= TSE_REG_ADR_COMCONF;
                      gen_read_AvMM_M_o_tv      <= 1;
                      
                    end
        INIT_TSE_WR:begin
                      
                      gen_address_AvMM_M_o_tv   <= TSE_REG_ADR_COMCONF;
                      gen_writedata_AvMM_M_o_tv <= TSE_REG_VAL_2_COMCONF;   //0,1,3,4,24,27
                      gen_write_AvMM_M_o_tv     <= 1;
                      
                    end
      INIT_TSE_CHK: begin
                      
                      gen_address_AvMM_M_o_tv   <= TSE_REG_ADR_COMCONF;
                      gen_read_AvMM_M_o_tv      <= 1;
                      
                    end
       default:     begin
                      
                      gen_address_AvMM_M_o_tv   <= 'x;
                      
                    end
        endcase
      end //else @ff
  end

//Avalon-ST Source
logic [7:0]gen_data_o_tv;
logic gen_valid_o_tv;
logic gen_startofpacket_o_tv;
logic gen_endofpacket_o_tv;

logic [31:0]temp_val_data_tx;
logic [1:0]count_32to8;
logic [10:0]size_tv;
logic [10:0]count_end_tx;
logic [10:0]size_pack;
logic [31:0]count_pack_work;
logic flag_startwork_tx;

logic [13:0] cout_one_sec;   //125Mhz 1/10000 sec
logic [31:0] count_time_work;

logic [9:0]work_speed;
logic [9:0]wait_speed;
logic [9:0]wait_speed_const;
logic [10:0]count_work_speed;

logic [10:0]rand_range;
logic flag_range_1_ready;
logic flag_range_2_ready;
logic flag_range_3_ready;
logic [10:0]rand_range_1;
logic [9:0]rand_range_2;
logic [9:0]rand_range_3;
logic flag_next_rand_size;
logic [10:0]rand_range_1_count;
logic [9:0]rand_range_2_count;
logic [9:0]rand_range_3_count;
logic [1:0]range_queue;
logic [10:0]value_rnd_1;
logic [9:0]value_rnd_2;
logic [9:0]value_rnd_3;





// автомат

typedef enum logic [1:0] {IDLE_ST = 2'b00,
                          SOP     = 2'b01,
                          SEND    = 2'b10,
                          EOP     = 2'b11,
                          XXX_ST  = 'x    } state_e_ST;
                          
                          
state_e_ST state_ST, next_ST;
                          
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      state_ST <= IDLE_ST;
    else
      state_ST <= next_ST;
  end
  
always_comb
  begin
    next_ST = XXX_ST;
    case (state_ST)
      IDLE_ST:      if((gen_reg.control[START_S_BIT] == 1 )&&(count_work_speed == 0))
                      next_ST = SOP;
                    else
                      next_ST = IDLE_ST;

      SOP:          if(( gen_ready_i == 1 )&&(gen_startofpacket_o_tv == 1)&&(gen_reg.control[START_S_BIT] != 0))
                      next_ST = SEND;
                    else if(r_w_addr_tv_ST == 5)
                      next_ST = IDLE_ST;
                    else
                      next_ST = SOP;

      SEND:         if(( gen_ready_i == 1 )&&((count_end_tx + 1 ) == size_pack))
                      next_ST = EOP;
                    else
                      next_ST = SEND;
                      
      EOP:          if(count_work_speed > 0)
                      next_ST = IDLE_ST;
                    else if((flag_startwork_tx == 1)&&( gen_ready_i == 1 ))
                      next_ST = SOP;
                    else if( gen_ready_i == 1 )
                      next_ST = IDLE_ST;
                    else
                      next_ST = EOP;
      
      default:    next_ST = XXX_ST;
    endcase
  end

always_ff @(posedge clk_i)
  begin
    if(srst_i)
      begin
        gen_data_o_tv          <= 0;
        gen_valid_o_tv         <= 0;
        gen_startofpacket_o_tv <= 0;
        gen_endofpacket_o_tv   <= 0;
        
        r_w_addr_tv_ST   <= 0;
        count_32to8      <= 0;
        temp_val_data_tx <= 0;
        size_tv          <= 0;
        count_end_tx     <= 0;
        count_pack_work  <= 0;
        flag_startwork_tx <= 0;
      end
    else
      begin
        gen_startofpacket_o_tv <= 0;
        case (next_ST)
          IDLE_ST:  begin
                      
                      r_w_addr_tv_ST         <= 1;
                      gen_data_o_tv          <= 0;
                      gen_valid_o_tv         <= 0;
                      gen_endofpacket_o_tv   <= 0;
                      
                      count_32to8          <= 0;
                      size_tv              <= 0;
                      count_end_tx         <= 0;
                      if(gen_reg.control[START_S_BIT] == 0)
                        count_pack_work      <= 0;
                      
                    end
          SOP:      begin
                      
                      if( gen_reg.control[START_S_BIT] == 1 )
                        r_w_addr_tv_ST <= 0;
                      else
                        r_w_addr_tv_ST <= 5;
                        
                      if(r_w_addr_tv_ST == 0)
                        count_end_tx <= 1;
                      if(count_end_tx == 1)
                        begin
                          temp_val_data_tx       <= q_tv;
                          gen_data_o_tv          <= q_tv[7:0];
                          gen_valid_o_tv         <= 1;
                          gen_startofpacket_o_tv <= 1;
                          count_32to8            <= 1;
                          size_tv                <= 0;
                        end
                      else if(gen_reg.control[START_S_BIT] == 0)
                        flag_startwork_tx <= 0;
                      else if(flag_startwork_tx == 1)
                        begin
                          count_end_tx           <= 1;
                          temp_val_data_tx       <= q_tv;
                          gen_data_o_tv          <= q_tv[7:0];
                          gen_valid_o_tv         <= 1;
                          gen_startofpacket_o_tv <= 1;
                          count_32to8            <= 1;
                          size_tv                <= 0;
                        end
                      
                      gen_endofpacket_o_tv   <= 0;
                      
                    end
          SEND:     begin
          
                      gen_valid_o_tv <= 1;
                      
                      if(gen_ready_i == 1)
                        begin
                          if( count_32to8 == 0)
                            gen_data_o_tv <= temp_val_data_tx[7:0];
                          else if( count_32to8 == 1)
                            begin
                              gen_data_o_tv <= temp_val_data_tx[15:8];
                              r_w_addr_tv_ST   <= (size_tv + 1);
                            end
                          else if( count_32to8 == 2)
                            gen_data_o_tv <= temp_val_data_tx[23:16];
                          else if( count_32to8 == 3)
                            gen_data_o_tv <= temp_val_data_tx[32:24];
                            
                          count_end_tx <= count_end_tx + 1;
                          count_32to8  <= count_32to8 + 1;
                          if( count_32to8 == 3 )
                            begin
                              size_tv          <= size_tv + 1;
                              temp_val_data_tx <= q_tv;
                            end
                            
                          if(( count_end_tx + 2 ) == size_pack )
                            r_w_addr_tv_ST   <= 0;

                        end
                        
                      if(( count_end_tx + 2 ) == size_pack )
                          begin
                            if( gen_reg.control[PACK_OR_SEC] == 0 )
                              begin
                                count_pack_work <= count_pack_work + 1;
                                if((count_pack_work + 1) >= gen_reg.count_pack_work)
                                  begin
                                    gen_reg.control[START_S_BIT] <= 0;
                                  end
                              end
                            else if(( count_time_work >= gen_reg.time_work) && ( gen_reg.control[PACK_OR_SEC] == 1 ))
                              begin
                                gen_reg.control[START_S_BIT] <= 0;
                              end
                              
                          end
                    
                    end
          EOP:      begin
                      
                      gen_valid_o_tv <= 1;
                      
                      if(gen_ready_i == 1)
                        begin
                          if( count_32to8 == 0)
                            gen_data_o_tv <= temp_val_data_tx[7:0];
                          else if( count_32to8 == 1)
                            begin
                              gen_data_o_tv <= temp_val_data_tx[15:8];
                            end
                          else if( count_32to8 == 2)
                            gen_data_o_tv <= temp_val_data_tx[23:16];
                          else if( count_32to8 == 3)
                            gen_data_o_tv <= temp_val_data_tx[32:24];
                            
                          count_end_tx <= count_end_tx + 1;
                          count_32to8  <= count_32to8 + 1;
                          if( count_32to8 == 3 )
                            begin
                              size_tv          <= size_tv + 1;
                              temp_val_data_tx <= q_tv;
                            end
                            
                          r_w_addr_tv_ST   <= 0;
                            
                          if((count_end_tx + 1 )  == size_pack)
                            gen_endofpacket_o_tv <= 1;
                            
                          flag_startwork_tx <= 1;

                        end

                    end
        endcase
      end //else @ff
  end

//time_work                           
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
        cout_one_sec    <= 0;
        count_time_work <= 0;
      end
    else
      begin
      
        if( gen_reg.control[START_S_BIT] == 0 )
          begin
            cout_one_sec    <= 0;
            count_time_work <= 0;
          end
        else if( cout_one_sec >= GEN_VAL_PART_OF_SEC )
          begin
            cout_one_sec    <= 0;
            count_time_work <= count_time_work + 1;
          end
        else if( gen_reg.control[START_S_BIT] == 1 )
          begin
            cout_one_sec <= cout_one_sec + 1;
          end
        
      end
  end                             

//speed
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
        work_speed       <= 0;
        wait_speed       <= 0;
        wait_speed_const <= 0;
        count_work_speed <= 0;
      end
    else
      begin
      
        wait_speed_const <= 1000 - gen_reg.rand_val_speed[31:22];
      
        if(gen_valid_o_tv == 1)
          begin
            if( (work_speed + 1) < gen_reg.rand_val_speed[31:22] )
              work_speed <= work_speed + 1;
            else if( gen_reg.rand_val_speed[31:22] < 1000 )
              begin
                work_speed       <= 0;
                count_work_speed <= count_work_speed + 1;
              end
          end
        else if((gen_valid_o_tv == 0)&&(gen_reg.control[START_S_BIT] == 1)&&(count_work_speed > 0))
          begin
            if((wait_speed + 1) < wait_speed_const)
              wait_speed <= wait_speed + 1;
            else 
              begin
                count_work_speed <= count_work_speed - 1;
                wait_speed       <= 0;
              end
          end
          
      end
  end
  
//size of pack and rand size
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
        size_pack           <= 62;
        flag_next_rand_size <= 0;
        range_queue         <= 0;
        rand_range_1_count  <= 0;
        rand_range_2_count  <= 0;
        rand_range_3_count  <= 0;
        value_rnd_1         <= 0;
        value_rnd_2         <= 0;
        value_rnd_3         <= 0;
      end
    else
      begin
        if( gen_reg.control[SIZE_PACK_BIT] == 0 )
          if( gen_reg.control[13:3] >= 62 )
            size_pack <= gen_reg.control[13:3];              
          else
            size_pack <= 62;
        else if((rand_range == 0)&&(gen_reg.control[SIZE_PACK_BIT] == 1))
          size_pack <= 62;
          
          
        if((flag_range_1_ready == 1)&&(flag_range_2_ready == 1)&&(flag_range_3_ready == 1)&&(flag_next_rand_size == 0)&&(next_ST != EOP))
          begin
            
            range_queue         <= range_queue + 1;
            flag_next_rand_size <= 1;
            
            if(( ((range_queue == QUEUE_VAL_3)||(range_queue == QUEUE_VAL_1))|| 
                 ((range_queue == QUEUE_VAL_2)&&(rand_range_2_count >= rand_range_2))||
                 ((range_queue == QUEUE_VAL_0)&&(rand_range_3_count >= rand_range_3)) 
                ) &&(rand_range_1_count < rand_range_1))
              begin
                rand_range_1_count <= rand_range_1_count + 1;
                value_rnd_1        <= (value_rnd_1 << 2) + value_rnd_1 + 1;   
                size_pack          <= value_rnd_1 + gen_reg.rand_val_speed[10:0];
              end
              
            else if(( ( range_queue == QUEUE_VAL_2 )||
                      ((range_queue == QUEUE_VAL_3)||(range_queue == QUEUE_VAL_1))||
                      ((range_queue == QUEUE_VAL_0)&&(rand_range_3_count >= rand_range_3))
                     ) &&(rand_range_2_count < rand_range_2))
              begin
                rand_range_2_count <= rand_range_2_count + 1;
                value_rnd_2        <= (value_rnd_2 << 2) + value_rnd_2 + 1;
                size_pack          <= value_rnd_2 + gen_reg.rand_val_speed[10:0] + rand_range_1;
              end
              
            else if(rand_range_3_count < rand_range_3)
              begin
                rand_range_3_count <= rand_range_3_count + 1;
                value_rnd_3        <= value_rnd_3 + 1;
                size_pack          <= value_rnd_3 + gen_reg.rand_val_speed[10:0] + rand_range_1 + rand_range_2;
              end
            
          end
          
        if((flag_next_rand_size == 1)&&(next_ST == EOP))
          begin
            
            flag_next_rand_size <= 0;
            
            if((rand_range_1_count >= rand_range_1)&&
               (rand_range_2_count >= rand_range_2)&&
               (rand_range_3_count >= rand_range_3)   )
              begin
                  rand_range_1_count  <= 0;
                  rand_range_2_count  <= 0;
                  rand_range_3_count  <= 0;
                  value_rnd_1         <= 0;
                  value_rnd_2         <= 0;
                  value_rnd_3         <= 0;
              end
              
            if     (rand_range_1 == RANGE_1024)    //1024
              value_rnd_1 <= value_rnd_1[9:0];
            else if(rand_range_1 == RANGE_512)    //512
              value_rnd_1 <= value_rnd_1[8:0];
            else if(rand_range_1 == RANGE_256)    //256
              value_rnd_1 <= value_rnd_1[7:0];
            else if(rand_range_1 == RANGE_128)    //128
              value_rnd_1 <= value_rnd_1[6:0];
            else if(rand_range_1 == RANGE_64)     //64
              value_rnd_1 <= value_rnd_1[5:0];
            else if(rand_range_1 == RANGE_32)     //32
              value_rnd_1 <= value_rnd_1[4:0];
            else if(rand_range_1 == RANGE_16)     //16
              value_rnd_1 <= value_rnd_1[3:0];
            else if(rand_range_1 == RANGE_8)      //8
              value_rnd_1 <= value_rnd_1[2:0];
            else if(rand_range_1 == RANGE_4)      //4
              value_rnd_1 <= value_rnd_1[1:0];
            else if(rand_range_1 == RANGE_2)      //2
              value_rnd_1 <= value_rnd_1[0];
                        
            if     (rand_range_2 == RANGE_512)    //512
              value_rnd_2 <= value_rnd_2[8:0];
            else if(rand_range_2 == RANGE_256)    //256
              value_rnd_2 <= value_rnd_2[7:0];
            else if(rand_range_2 == RANGE_128)    //128
              value_rnd_2 <= value_rnd_2[6:0];
            else if(rand_range_2 == RANGE_64)     //64
              value_rnd_2 <= value_rnd_2[5:0];
            else if(rand_range_2 == RANGE_32)     //32
              value_rnd_2 <= value_rnd_2[4:0];
            else if(rand_range_2 == RANGE_16)     //16
              value_rnd_2 <= value_rnd_2[3:0];
            else if(rand_range_2 == RANGE_8)      //8
             value_rnd_2 <= value_rnd_2[2:0];
            else if(rand_range_2 == RANGE_4)      //4
              value_rnd_2 <= value_rnd_2[1:0];
            else if(rand_range_2 == RANGE_2)      //2
              value_rnd_2 <= value_rnd_2[0];
            
          end
        
      end
  end

//define range 1, range 2, range 3
always_ff @( posedge clk_i )
  begin
    if(srst_i)
      begin
        flag_range_1_ready <= 0;
        flag_range_2_ready <= 0;
        flag_range_3_ready <= 0;
        rand_range_1       <= 0;
        rand_range_2       <= 0;
        rand_range_3       <= 0;
        rand_range         <= 0;
        
      end
    else
      begin
         
        if((gen_reg.control[START_S_BIT] == 1)&&(gen_reg.control[SIZE_PACK_BIT] == 1))
          rand_range <= gen_reg.rand_val_speed[21:11] - gen_reg.rand_val_speed[10:0] + 1;
        else
          begin
            flag_range_1_ready <= 0;
            flag_range_2_ready <= 0;
            flag_range_3_ready <= 0;
            rand_range         <= 0;
          end
          
        if(rand_range != 0)
          begin
          
            if(flag_range_1_ready == 0)
              begin
                if(rand_range > RANGE_1024)    //1024
                  begin
                    rand_range_1        <= RANGE_1024;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_512)    //512
                  begin
                    rand_range_1        <= RANGE_512;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_256)    //256
                  begin
                    rand_range_1        <= RANGE_256;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_128)    //128
                  begin
                    rand_range_1        <= RANGE_128;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_64)    //64
                  begin
                    rand_range_1        <= RANGE_64;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_32)    //32
                  begin
                    rand_range_1        <= RANGE_32;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_16)    //16
                  begin
                    rand_range_1        <= RANGE_16;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_8)    //8
                  begin
                    rand_range_1        <= RANGE_8;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_4)    //4
                  begin
                    rand_range_1        <= RANGE_4;
                    flag_range_1_ready  <= 1;
                  end
                else if(rand_range > RANGE_2)    //2
                  begin
                    rand_range_1        <= RANGE_2;
                    flag_range_1_ready  <= 1;
                  end
                else
                  begin
                    rand_range_1        <= 0;
                    flag_range_1_ready  <= 1;
                  end
              end
            else if(flag_range_2_ready == 0)
              begin
                if((rand_range - rand_range_1) > RANGE_512)    //512
                  begin
                    rand_range_2       <= RANGE_512;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_256)    //256
                  begin
                    rand_range_2       <= RANGE_256;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_128)    //128
                  begin
                    rand_range_2       <= RANGE_128;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_64)    //64
                  begin
                    rand_range_2       <= RANGE_64;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_32)    //32
                  begin
                    rand_range_2       <= RANGE_32;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_16)    //16
                  begin
                    rand_range_2       <= RANGE_16;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_8)    //8
                  begin
                    rand_range_2       <= RANGE_8;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_4)    //4
                  begin
                    rand_range_2       <= RANGE_4;
                    flag_range_2_ready <= 1;
                  end
                else if((rand_range - rand_range_1) > RANGE_2)    //2
                  begin
                    rand_range_2       <= RANGE_2;
                    flag_range_2_ready <= 1;
                  end
                else
                  begin
                    rand_range_2        <= 0;
                    flag_range_2_ready  <= 1;
                  end
              end
            else if(flag_range_3_ready == 0)             
              begin
                rand_range_3        <= rand_range - rand_range_1 - rand_range_2;
                flag_range_3_ready  <= 1;
              end
             
          end                     //end flag_start_size = 1 work
        
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