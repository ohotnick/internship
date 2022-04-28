`timescale 1 ns / 10 ps
module tb ;

parameter REG_ADDR_WIDTH = 8;
parameter DATA_ADD_VALUE = 32'h100000;

parameter DATA_WIDTH    = 32;
parameter ADDR_WIDTH    = 9;

//Register range
parameter FIRST_ADDR_REG_00   = 10'h0;
parameter MIDDLE_ADDR_REG_02  = 10'h2;
parameter LAST_ADDR_REG_03    = 10'h3;
//Empty range
parameter NEXT_AFTER_LAST_04  = 10'h4;
parameter BEFORE_FIRST_RAM_0E = 10'he;
//Ram range
parameter FIRST_RAM_00_GENERAL_10  = 10'h10;
parameter MID_RAM_F0_GENERAL_100   = 10'h100;
parameter LASR_RAM_16D_GENERAL_17D = 10'h17d; 
//Empty range
parameter NEXT_AFTER_LAST_17E  = 10'h17e;
parameter BEFORE_FIRST_TSE_1FF = 10'h1ff; 
//TSE register range
parameter FIRST_TSE_00_GENERAL_200 = 10'h200;
parameter NEXT_TSE_01_GENERAL_201  = 10'h201;
parameter NEXT_TSE_02_GENERAL_202  = 10'h202;

parameter INIT_TSE_WORD_01000000 = 32'h01000000;
//Test const
parameter PRINT_ALL_RX    = 1;
parameter NO_PRINT_ALL_RX = 0;

parameter MIN_PACK_SIZE = 11'h3e;   //62
//parameter MIN_PACK_SIZE = 11'h3c;
//parameter MAX_PACK_SIZE = 11'h50;
parameter MAX_PACK_SIZE = 11'h5dc;  //1500
//parameter SPEED_WORK    = 10'h1f4;
parameter SPEED_WORK    = 10'h320; //800

parameter VALUE_OF_PACK_5          = 32'h0000005;
parameter REGISTER_VALUE_PACK_0x01 = 1;
//parameter VALUE_OF_TIME_2          = 32'h0000002;
parameter VALUE_OF_TIME_2          = 32'h0000008;
parameter REGISTER_TIME_PACK_0x02  = 2;
//parameter VAL_RND_62_80_SPEED_500  = 32'h7d02803e;
parameter VAL_RND_62_80_SPEED_500  = {SPEED_WORK,MAX_PACK_SIZE,MIN_PACK_SIZE};
parameter REG_RAND_SPEED_PACK_0x03 = 3;
parameter START_TX_PACKTX_SIZE_80  = 32'h0000281;
parameter REG_CONTL_0x00           = 0;
parameter START_TX_SEC_RAND_SIZE   = 32'h000002f;
//TEST 1
parameter TEST_1_80_BYTE_CONST_PACK = 32'h0000281;
parameter TEST_1_NUMBER_PACK_5      = 32'h0000005;
//TEST 3
parameter GEN_VAL_PART_OF_SEC   = 32'h30d4;      //125Mhz 1/10000 sec


// ------------------

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
logic  waitrequest_gen_tse;

logic  [7:0]address_gen_tse;
logic  write_gen_tse;
logic  [31:0]writedata_gen_tse;
logic  read_gen_tse;

//Avalon-ST
logic [7:0] data_aval;
logic sop_aval;
logic eop_aval;
logic valid_aval;
logic ready_aval;

//GMII
logic gm_tx_rx_en_0;
logic gm_tx_rx_err_0;
logic [7:0]gm_tx_rx_d_0;

//Avalon-MM slave
logic [9:0]address_AvMM_S_i;
logic write_AvMM_S_i;
logic [31:0]writedata_AvMM_S_i;
logic read_AvMM_S_i;

logic [31:0]readdata_AvMM_S_o;
logic readdatavalid_AvMM_S_o;
logic waitrequest_AvMM_S_o;
   
logic [4:0]data_rx_error_0;
logic data_rx_valid_0;
logic data_rx_eop_0;
logic data_rx_sop_0;
logic [7:0]data_rx_data_0;

//Test flags
logic start_test_pack          = 0;
logic flag_print_all_rx_data   = 0;
logic flag_read_reg_contr_byte = 0;
//TEST 3
logic start_test_3_pack        = 0;
logic flag_start_time_count    = 0;
logic flag_test_time           = 0;
integer start_time_pack        = 0;
integer end_time_pack          = 0;
integer work_time_pack         = 0;
integer value_pack_TEST_3      = 0;
logic [31:0]array_of_size_rand_pack [(2**11)-1:0];
integer check_not_repeats      = 0;

always //125
   begin
   reg_clk <= 1'b 1;    
   #( 4 ); 
   reg_clk <= 1'b 0;    
   #( 4 ); 
   end
      
initial
  begin
    @( posedge reg_clk )
      reset <= 1'b1;      
    @( posedge reg_clk )
      reset <= 1'b0;
  end

logic [31:0]read_data_global; 
  
task send_MM ( logic [31:0]data_send_MM, logic [9:0]address_MM );

  @(posedge reg_clk)
    begin
      address_AvMM_S_i   = address_MM;
      writedata_AvMM_S_i = data_send_MM;
      write_AvMM_S_i     = 1;
    end

  forever
    begin
      @(posedge reg_clk);
      if( waitrequest_AvMM_S_o == 0 )
        begin
          write_AvMM_S_i         = 0;
          break;
        end
      
      
    end
    
  $display( "Send data_MM[%d] = %h, %d ns ", address_MM , data_send_MM,$time  );
  
endtask

task read_MM ( logic [31:0]data_read_MM, logic [9:0]address_MM );

  @(posedge reg_clk)
    begin
      address_AvMM_S_i   = address_MM;
      read_AvMM_S_i      = 1;
    end
    
  forever
    begin
      @(posedge reg_clk)
        begin
          if( waitrequest_AvMM_S_o == 0 )
            read_AvMM_S_i          = 0;
        
          if ( readdatavalid_AvMM_S_o == 1 )
            begin
              data_read_MM     = readdata_AvMM_S_o;
              read_data_global = readdata_AvMM_S_o;
              break;
            end
        end
    end
  
  $display( "Read data_MM[%d] = %h,  %d ns ", address_MM , data_read_MM ,$time  );
  
endtask

task Check_Aval_MM(logic [9:0]address_MM_check);
  
  logic [31:0]present_data;
  
  read_MM (present_data, address_MM_check);
  present_data     = read_data_global;
  read_data_global = read_data_global + DATA_ADD_VALUE;
  
  send_MM (read_data_global, address_MM_check);
  read_MM (present_data, address_MM_check);
  
  if(read_data_global == (present_data + DATA_ADD_VALUE))
    $display( "Check good adr = %h,  %d ns ", address_MM_check ,$time  );
  else
    begin
      if(read_data_global == 32'h404)
        $display( "Check good, not work range addr, adr = %h,  %d ns ", address_MM_check ,$time  );
      else if((address_MM_check == 10'h200)&&(read_data_global == 32'hd00))
        $display( "Check good, TSE ID, adr = %h TSE_adr = %h,  %d ns ", address_MM_check, address_MM_check - 10'h200 ,$time  );
      else
        $display( "Check err adr = %h,  %d ns ", address_MM_check ,$time  );
    end
    
  send_MM (0, address_MM_check);
  
endtask
 
logic     [DATA_WIDTH-1:0] ram_temp[(2**ADDR_WIDTH-1):0];

task Init_pack();

  logic   [31:0]data_ram_frame;
  logic   [9:0]address_ram_frame;
  integer i;
  
  $readmemh("raminit.txt", ram_temp);
  i = 0;
  forever
    begin
      $display( "vall of ram_temp[%d] %h  ",i,ram_temp[i] );
      address_ram_frame  = i + 16;
      data_ram_frame     = ram_temp[i];
      send_MM (data_ram_frame, address_ram_frame);
      i = i + 1;
      if(i == 390)
        break;
    end

  $display( "Success init frame,  %d ns ",$time  );

endtask

logic flag_test_Aval_ST_ready;
logic test_ready_ST;
  
initial
  begin
    
    logic [31:0]data_send_MM;
    logic [9:0]address_MM;
    
    logic [31:0]data_read_MM;
    logic [9:0]address_MM_read;
    
    logic [31:0]data_to_check;
    logic [31:0]data_take;
    
    flag_test_Aval_ST_ready = 0;
    
    $display( "Start check Avalon-MM  %d ns ",$time  );
    #50;
    $display( "Check Avalon-MM address 0-3  %d ns ",$time  );
    
    //Register range
    address_MM   = FIRST_ADDR_REG_00;                         //first addr reg
    Check_Aval_MM(address_MM);
    address_MM   = MIDDLE_ADDR_REG_02;                        //middle addr reg
    Check_Aval_MM(address_MM);
    address_MM   = LAST_ADDR_REG_03;                          //last addr reg
    Check_Aval_MM(address_MM);
    
    //Empty range
    address_MM   = NEXT_AFTER_LAST_04;                        //next after last addr reg
    Check_Aval_MM(address_MM);
    address_MM   = BEFORE_FIRST_RAM_0E;                       //before first addr ram
    Check_Aval_MM(address_MM);
    
    $display( "Check Avalon-MM address 10-17D  %d ns ",$time  );
    //Ram range
    address_MM   = FIRST_RAM_00_GENERAL_10;                   //init start ram val
    data_send_MM = 32'h0;
    send_MM (data_send_MM, address_MM);
    address_MM   = FIRST_RAM_00_GENERAL_10;                   //first addr ram
    Check_Aval_MM(address_MM);
    address_MM   = MID_RAM_F0_GENERAL_100;                    //init start ram val
    data_send_MM = 32'h0;
    send_MM (data_send_MM, address_MM);
    address_MM   = MID_RAM_F0_GENERAL_100;                    //some middle addr ram
    Check_Aval_MM(address_MM);
    address_MM   = LASR_RAM_16D_GENERAL_17D;                  //init start ram val
    data_send_MM = 32'h0;
    send_MM (data_send_MM, address_MM);
    address_MM   = LASR_RAM_16D_GENERAL_17D;                  //last addr ram
    Check_Aval_MM(address_MM);
    
    //Empty range
    address_MM   = NEXT_AFTER_LAST_17E;                       //next after last addr ram
    Check_Aval_MM(address_MM);
    address_MM   = BEFORE_FIRST_TSE_1FF;                      //before first addr TSE
    Check_Aval_MM(address_MM);
    
    $display( "Check Avalon-MM address 200,201,202  %d ns ",$time  );
    //TSE register range
    address_MM      = FIRST_TSE_00_GENERAL_200;               //first addr TSE  0x00
    Check_Aval_MM(address_MM);
    address_MM      = NEXT_TSE_01_GENERAL_201;                //next addr TSE   0x01
    Check_Aval_MM(address_MM);
    address_MM_read = NEXT_TSE_02_GENERAL_202;                //next addr TSE  0x02
    read_MM (data_read_MM, address_MM_read);
    
    //INIT TSE
    data_send_MM = INIT_TSE_WORD_01000000;
    address_MM   = 0;   
    send_MM (data_send_MM, address_MM);
    
    //INIT RAM
    Init_pack();
    
    //flag_print_all_rx_data = PRINT_ALL_RX;
    flag_print_all_rx_data = NO_PRINT_ALL_RX;
    
    address_MM_read   = 10'h202;                          //next addr TSE  0x02 read
    read_MM (data_read_MM, address_MM_read);
    
    data_send_MM = VALUE_OF_PACK_5;                         //Value of pack 
    address_MM   = REGISTER_VALUE_PACK_0x01;   
    send_MM (data_send_MM, address_MM);
    
    data_send_MM = VALUE_OF_TIME_2;                         //Work time
    address_MM   = REGISTER_TIME_PACK_0x02;   
    send_MM (data_send_MM, address_MM);
    
    data_send_MM = 32'hFA000000;                          // speed 1000
    address_MM   = REG_RAND_SPEED_PACK_0x03;   
    send_MM (data_send_MM, address_MM);
    
    #500;
    $display( " Start TX %d ns " ,$time  ); 
    start_test_pack = 1;
    
    data_send_MM = START_TX_PACKTX_SIZE_80;                             //start TX коллво пак 80 пакетов
    address_MM   = REG_CONTL_0x00;   
    send_MM (data_send_MM, address_MM);
    
    #5000;
    
    forever
      begin
        @(posedge reg_clk);
        if(flag_test_Aval_ST_ready == 0)
          break;
      end
    
    #500;
    data_send_MM = VAL_RND_62_80_SPEED_500;                //min 62, max 80, speed 500
    address_MM   = REG_RAND_SPEED_PACK_0x03;   
    send_MM (data_send_MM, address_MM);
    $display( " Send NEXT TX %d ns " ,$time  ); 
    start_test_3_pack = 1;
    
    data_send_MM = START_TX_SEC_RAND_SIZE;                             //start TX  секундах случ диап
    address_MM   = REG_CONTL_0x00;   
    send_MM (data_send_MM, address_MM);
    #(100000*(VALUE_OF_TIME_2+1));
    #40000;
    $stop;
  
  end

initial
  begin
    
    test_ready_ST     = 0;
    
    forever
      begin
        @( posedge reg_clk )
          test_ready_ST <= 1'b1;      
        @( posedge reg_clk )
          test_ready_ST <= 1'b0;
        @( posedge reg_clk )
          test_ready_ST <= 1'b0;
      end
    
  end

//Test Pack vs RAM 
bit [7:0] test_queue [$];
integer pack_size   = 0;
integer i_pack_size = 0;
integer i_ram_size  = 0;
logic pack_check    = 0;

//TEST 1
initial
  begin
  
  logic [7:0] result;
  logic [7:0] ref_result;
  integer value_pack = 0;
  
    forever
      begin
    
        @(posedge reg_clk);
        if(start_test_pack == 1)
          begin
            //$display( " Start test size pack,  %d ns " ,$time  );
            if(data_rx_valid_0 == 1)
              begin
                //$display( " DATA: data_rx_data_0 = %h, i_ram_size = %d,  %d ns ",data_rx_data_0, i_ram_size ,$time  );
                test_queue.push_back(data_rx_data_0);               
                
                if( data_rx_sop_0 == 1 )
                  pack_size = 1;
                else if(( data_rx_sop_0 == 0 ) && ( data_rx_eop_0 == 0 ))
                  pack_size = pack_size + 1;
                else if( data_rx_eop_0 == 1 )
                  begin
                    pack_size   = pack_size + 1;
                    i_pack_size = 0;
                    i_ram_size  = 0;
                    pack_check  = 0;
                    
                    //TEST 1. 1)const size pack. 2)5 pack
                    if(pack_size == TEST_1_80_BYTE_CONST_PACK[13:3])
                      begin
                        value_pack = value_pack + 1;
                        if(value_pack == TEST_1_NUMBER_PACK_5)
                          begin
                            $display( " TEST 1: Value send pack = %d,  %d ns ",value_pack ,$time  );
                            flag_read_reg_contr_byte = 1;
                          end
                      end
                    //END TEST 1
                    
                    if( flag_print_all_rx_data == PRINT_ALL_RX )
                      $display( " Size send pack = %d,  %d ns ",pack_size ,$time  );
                      forever
                        begin

                          if( i_pack_size%4 == 0 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][7:0];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 1 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][15:8];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 2 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][23:16];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 3 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][31:24];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                            
                          i_pack_size = i_pack_size + 1;
                          i_ram_size  = i_pack_size/4;
                          
                          if(i_pack_size >= pack_size)
                            begin
                              if( pack_check == 0 )
                                $display("Pack check good! Size = %d , %d ns", pack_size,$time  );
                              else if( pack_check == 0 )
                                $display("No pack check good!!! Size = %d , %d ns", pack_size,$time  );
                              break;
                            end
          
                        end
                  end
              end
          end
        else if(start_test_pack == 0)
          begin

            value_pack = 0;
            //END TEST 1
          end
      end 
  end

//TEST READY 
initial
  begin
  
  logic [7:0] result;
  logic [7:0] ref_result;
  integer value_pack = 0;
  
    forever
      begin
    
        @(posedge reg_clk);
        if(flag_test_Aval_ST_ready == 1)
          begin
            //$display( " Start test size pack,  %d ns " ,$time  );
            if((valid_aval == 1)&&(test_ready_ST == 1))
              begin
                //$display( " DATA: data_rx_data_0 = %h, i_ram_size = %d,  %d ns ",data_rx_data_0, i_ram_size ,$time  );
                test_queue.push_back(data_aval);            
                
                if( sop_aval == 1 )
                  pack_size = 1;
                else if(( sop_aval == 0 ) && ( eop_aval == 0 ))
                  pack_size = pack_size + 1;
                else if( eop_aval == 1 )
                  begin
                    pack_size   = pack_size + 1;
                    i_pack_size = 0;
                    i_ram_size  = 0;
                    pack_check  = 0;
                    
                    //TEST READY. 
                    if(pack_size == TEST_1_80_BYTE_CONST_PACK[13:3])
                      begin
                        value_pack = value_pack + 1;
                        if(value_pack == TEST_1_NUMBER_PACK_5)
                          begin
                            $display( " TEST READY: Value send pack = %d,  %d ns ",value_pack ,$time  );
                            flag_read_reg_contr_byte = 1;
                          end
                      end
                    //END TEST READY
                    
                    if( flag_print_all_rx_data == PRINT_ALL_RX )
                      $display( " Size send pack = %d,  %d ns ",pack_size ,$time  );
                      forever
                        begin

                          if( i_pack_size%4 == 0 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][7:0];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 1 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][15:8];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 2 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][23:16];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 3 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][31:24];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                            
                          i_pack_size = i_pack_size + 1;
                          i_ram_size  = i_pack_size/4;
                          
                          if(i_pack_size >= pack_size)
                            begin
                              if( pack_check == 0 )
                                $display("Pack check good! Size = %d , %d ns", pack_size,$time  );
                              else if( pack_check == 0 )
                                $display("No pack check good!!! Size = %d , %d ns", pack_size,$time  );
                              break;
                            end
          
                        end
                  end
              end
          end
        else if(flag_test_Aval_ST_ready == 0)
          begin
            //TEST READY
            value_pack = 0;
            //END TEST READY
          end
      end
  
  end
  
//TEST 1 and TEST READY 
initial
  begin
    
    
    forever
      begin
        
        @(posedge reg_clk);
        if( flag_read_reg_contr_byte == 1 )
          begin
            flag_read_reg_contr_byte = 0;
            read_MM ( 1, 0);
            
            if(start_test_pack == 1)
              begin
                if(( readdata_AvMM_S_o == 32'h0000280 )&&(pack_check == 0))
                  $display( " TEST 1: GOOD. End TX/RX.,  %d ns " ,$time  );
                else
                  $display( " TEST 1: ERR,  %d ns " ,$time  );
                start_test_pack          = 0;
                flag_test_Aval_ST_ready  = 1;
                send_MM (32'h0000281, 0);
              end
            else
              begin
                if(( readdata_AvMM_S_o == 32'h0000280 )&&(pack_check == 0))
                  $display( " TEST READY: GOOD. End TX.,  %d ns " ,$time  );
                else
                  $display( " TEST READY: ERR,  %d ns " ,$time  );
                flag_test_Aval_ST_ready  = 0;
              end
            
          end
      end
    
  end
 
  
//TEST 3
initial
  begin
  
  logic [7:0] result;
  logic [7:0] ref_result;
  integer i = 0; 
  
  //TEST 3
  integer value_pack = 0;
  value_pack_TEST_3  = 0;
  check_not_repeats  = 0;
  
  //clean array
  forever
    begin
      array_of_size_rand_pack[i] = 0;
      i= i + 1;
      if(i >= 1600)
        break;
    end
  
    forever
      begin
    
        @(posedge reg_clk);
        if(start_test_3_pack == 1)
          begin
            //$display( " Start test size pack,  %d ns " ,$time  );
            if(data_rx_valid_0 == 1)
              begin
                //$display( " DATA: data_rx_data_0 = %h, i_ram_size = %d,  %d ns ",data_rx_data_0, i_ram_size ,$time  );
                test_queue.push_back(data_rx_data_0); 
                work_time_pack = work_time_pack + 1;                
                
                if( data_rx_sop_0 == 1 )
                  begin
                    pack_size             = 1;
                    if(flag_start_time_count == 0)
                      begin
                        $display( " START COUNT TIME !!!!!!  %d ns " ,$time );
                        start_time_pack = $time;
                      end
                    flag_start_time_count = 1;
                  end
                else if(( data_rx_sop_0 == 0 ) && ( data_rx_eop_0 == 0 ))
                  pack_size = pack_size + 1;
                else if( data_rx_eop_0 == 1 )
                  begin
                    pack_size   = pack_size + 1;
                    i_pack_size = 0;
                    i_ram_size  = 0;
                    pack_check  = 0;
                    end_time_pack = $time;
                    value_pack_TEST_3 = value_pack_TEST_3 + 1;
                    
                    array_of_size_rand_pack[pack_size] = array_of_size_rand_pack[pack_size] + 1;
                    if((check_not_repeats == array_of_size_rand_pack[pack_size])||((check_not_repeats + 1) == array_of_size_rand_pack[pack_size]))
                      begin
                        check_not_repeats = check_not_repeats;
                        //$display( " !!check_not_repeats = check_not_repeats!! 1)array_of_size_rand_pack[pack_size] = %d   %d ns ",array_of_size_rand_pack[pack_size] ,$time );
                      end
                    else if(((check_not_repeats + 2) == array_of_size_rand_pack[pack_size]))
                      begin
                        check_not_repeats = array_of_size_rand_pack[pack_size] - 1;
                        //$display( " !!!check_not_repeats = array_of_size_rand_pack[pack_size] - 1!!! 1)array_of_size_rand_pack[pack_size] = %d   %d ns ",array_of_size_rand_pack[pack_size] ,$time );
                      end
                    else 
                      begin
                        //$display( " !!!!else!!!! 1)array_of_size_rand_pack[pack_size] = %d   %d ns ",array_of_size_rand_pack[pack_size] ,$time );
                        $error("repeat pack size");
                      end
                    
                    if( flag_print_all_rx_data == PRINT_ALL_RX )
                      $display( " Size send pack = %d,  %d ns ",pack_size ,$time  );
                      forever
                        begin

                          if( i_pack_size%4 == 0 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][7:0];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 1 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][15:8];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 2 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][23:16];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                          else if( i_pack_size%4 == 3 )
                            begin
                              result     = test_queue.pop_front( );
                              ref_result = ram_temp[i_ram_size][31:24];
                              if( result != ref_result )
                                begin
                                  pack_check = 1;
                                  $error("Data mismatch");
                                end
                              if( flag_print_all_rx_data == PRINT_ALL_RX )
                                $display( "1)Number of word = %d 2)result = %h 3)ref_result(ram) %h  ", i_pack_size ,result,ref_result );
                            end
                            
                          i_pack_size = i_pack_size + 1;
                          i_ram_size  = i_pack_size/4;
                          
                          if(i_pack_size >= pack_size)
                            begin
                              if( pack_check == 0 )
                                $display("Pack check good! Size = %d , %d ns", pack_size,$time  );
                              else if( pack_check == 0 )
                                $display("No pack check good!!! Size = %d , %d ns", pack_size,$time  );
                              break;
                            end
          
                        end
                  end
              end
          end
        else if(start_test_3_pack == 0)
          begin
            //TEST 3
            value_pack = 0;
            //END TEST 3
          end
      end
  
  end

logic [13:0] cout_one_sec;   //125Mhz 1/10000 sec
logic [31:0] count_time_work; 
 
initial
  begin
  
  integer i = 0;
  
  
    forever
      begin
        @(posedge reg_clk);
        if(flag_test_time == 1)
          begin
            flag_test_time <= 0;
            start_test_3_pack = 0;
            read_MM ( 1, 0);
            if(readdata_AvMM_S_o[0] == 0)
              $display("1)Start time RX = %d ns, 2)End time RX = %d ns, 3) Work time %d , %d ns", start_time_pack, end_time_pack, (end_time_pack - start_time_pack),$time  );
            else
              $error("NOT END TX");
            $display("REAL work speed: 1)Work time = %d ,2) Wait time = %d,3) Work in Mbyte %d, %d ns", (work_time_pack*8), (end_time_pack - start_time_pack - work_time_pack*8),((work_time_pack*8)*1000/(end_time_pack - start_time_pack)),$time  );
            $display("EXPECT work speed: 1)Work time = %d ,2) Wait time = %d,3) Work in Mbyte %d, %d ns", (work_time_pack*8 + value_pack_TEST_3*176), (end_time_pack - start_time_pack - work_time_pack*8 - value_pack_TEST_3*176),((work_time_pack*8 + value_pack_TEST_3*176)*1000/(end_time_pack - start_time_pack)),$time  );
            start_time_pack = 0;
            end_time_pack   = 0;
            work_time_pack  = 0;
            
            $display("Rand pack sizes! %d ns",$time  );
            //$display("80) number of packs = %d , %d ns",array_of_size_rand_pack[80],$time  );
            forever
              begin
                if(array_of_size_rand_pack[i] > 0)
                  $display("%d) number of packs = %d , %d ns",i,array_of_size_rand_pack[i],$time  );
                i= i + 1;
                if(i >= 1600)
                  break;
              end
            
          end
        else if( flag_start_time_count == 0 )
          begin
            cout_one_sec    <= 0;
            count_time_work <= 0;
          end
        else if( cout_one_sec >= GEN_VAL_PART_OF_SEC )
          begin
            cout_one_sec    <= 0;
            count_time_work <= count_time_work + 1;
            //if(count_time_work >= 32'h0000002)
            if(count_time_work >= VALUE_OF_TIME_2)
              begin
                flag_test_time        = 1;
                flag_start_time_count = 0;
              end
          end
        else if( flag_start_time_count == 1 )
          begin
            cout_one_sec <= cout_one_sec + 1;
          end
      end  
  end

// $<RTL_CORE_INSTANCE>
Tse_1 dut
(
   .gm_tx_en_0        ( gm_tx_rx_en_0 ),
   .gm_rx_err_0       ( gm_tx_rx_err_0 ),
   .gm_tx_err_0       ( gm_tx_rx_err_0 ),
   .gm_rx_dv_0        ( gm_tx_rx_en_0 ),
   .gm_tx_d_0         ( gm_tx_rx_d_0 ),
   .gm_rx_d_0         ( gm_tx_rx_d_0 ),
   .clk               (reg_clk),
   .mac_rx_clk_0      ( ),
   .rx_afull_valid    ( ),
   .rx_afull_data     ( ),
   .rx_afull_channel  ( ),
   .tx_clk_0          ( reg_clk ),
   .magic_wakeup_0    ( ),
   .xoff_gen_0        ( ),
   .tx_crc_fwd_0      ( 0 ),
   .magic_sleep_n_0   ( ),
   .xon_gen_0         ( ),
   .data_rx_eop_0     ( data_rx_eop_0 ),
   .data_rx_data_0    ( data_rx_data_0 ),
   .data_rx_valid_0   ( data_rx_valid_0 ),
   .data_rx_error_0   ( data_rx_error_0 ),
   .data_rx_sop_0     ( data_rx_sop_0 ),
   .data_rx_ready_0   ( 1 ),
   .pkt_class_valid_0 ( ),
   .pkt_class_data_0  ( ),
   .rx_clk_0          ( reg_clk ),
   .data_tx_error_0   ( 0 ),
   .data_tx_valid_0   ( valid_aval ),
   .data_tx_data_0    ( data_aval ),
   .data_tx_ready_0   ( ready_aval ),
   .data_tx_sop_0     ( sop_aval ),
   .data_tx_eop_0     ( eop_aval ),
   .waitrequest       (waitrequest_gen_tse),
   .address           (address_gen_tse),
   .writedata         (writedata_gen_tse),
   .write             (write_gen_tse),
   .read              (read_gen_tse),
   .readdata          (readdata_gen_tse),
   .mac_tx_clk_0      ( ),  //multiply driven
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
   .rx_afull_clk      (reg_clk)  //not tx
);

gen_pack_TSE dut_gen (

    .clk_i                  (reg_clk),
    .srst_i                 (reset),

//Avalon-MM Slave. Init gen
    .gen_address_AvMM_S_i       ( address_AvMM_S_i ),
    .gen_write_AvMM_S_i         ( write_AvMM_S_i ),
    .gen_writedata_AvMM_S_i     ( writedata_AvMM_S_i ),
    .gen_read_AvMM_S_i          ( read_AvMM_S_i ),

    .gen_readdata_AvMM_S_o      ( readdata_AvMM_S_o ),
    .gen_readdatavalid_AvMM_S_o ( readdatavalid_AvMM_S_o ),
    .gen_waitrequest_AvMM_S_o   ( waitrequest_AvMM_S_o ),

//Avalon-MM Master. Init TSE
    .gen_readdata_AvMM_M_i      (readdata_gen_tse),
    .gen_waitrequest_AvMM_M_i   (waitrequest_gen_tse),

    .gen_address_AvMM_M_o       (address_gen_tse),
    .gen_write_AvMM_M_o         (write_gen_tse),
    .gen_writedata_AvMM_M_o     (writedata_gen_tse),
    .gen_read_AvMM_M_o          (read_gen_tse),
    
//Avalon-ST Source
    .gen_ready_i                 ( (flag_test_Aval_ST_ready == 1) ? test_ready_ST : ready_aval ),

    .gen_data_o                  ( data_aval ),
    .gen_valid_o                 ( valid_aval ),
    .gen_startofpacket_o         ( sop_aval ),
    .gen_endofpacket_o           ( eop_aval )

);

 
endmodule // module tb
