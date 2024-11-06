module  SPI(
    input   wire            sys_clk     ,
    input   wire            sys_rst     ,
    input   wire            SPI_start   ,
    input   wire    [7:0]   send_data   ,

    output  reg             SPI_CS      ,
    output  reg             SPI_MOSI    ,
    output  reg             SPI_CLK     
      
);



reg     [7:0]   keep_data   ;
reg     [1:0]   cnt         ;
reg     [3:0]   send_bit_cnt;
reg             endflag     ;
reg             real_endflag;



//Keep_data
//when received SPI start signal, save the data in senddata to Keeddata until one SPI communication is finished 
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        keep_data <= 8'd0;
    
    else    if(SPI_start == 1'b1)
        keep_data <= send_data;
    else    if(send_bit_cnt == 4'd7 && cnt == 2'd0)
        keep_data <= 8'd0;
    else
        keep_data <= keep_data;
        


//cnt
//counter for generate 12.5 MHz SCK
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        cnt <= 2'd0;
        
    else    if(SPI_CS == 1'b0 && cnt == 2'd3)
        cnt <= 2'd0;
    else    if(SPI_CS == 1'b0)
        cnt <= cnt + 2'd1;
    else    
        cnt <= 2'd0;
        
//SPI_CLK
//based on the counter "cnt", generated a frequency division by four.
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)  
        SPI_CLK <= 1'b0;
    else    if(cnt == 2'd0 && SPI_CS == 1'b0)
        SPI_CLK <= 1'b0;
    else    if(cnt == 2'd2 && SPI_CS == 1'b0)
        SPI_CLK <= 1'b1;
    else    if(SPI_CS == 1'b1)
        SPI_CLK <= 1'b0;
    else
        SPI_CLK <= SPI_CLK;
        
        
//SPI_CS
//when received the SPI start signal, SPI CS will pull down to 0, after received a real endflag, the CS signal will back to 1
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0) 
        SPI_CS <= 1'b1;
    else    if(SPI_start == 1'b1)
        SPI_CS <= 1'b0;
    else    if(real_endflag == 1'b1)
        SPI_CS <= 1'b1;
    else
        SPI_CS <= SPI_CS;


//Send_bit cnt
//send bit cnt for MOSI, when CS is low, the sendbit cnt will add 1 each time when cnt = 0. once sendbit cnt reached the maximum 7, it will back to 0 and start the loop
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        send_bit_cnt <= 4'd0;
    else    if( (SPI_CS == 1'b0) && (cnt == 2'd0) && (send_bit_cnt == 4'd7) )
        send_bit_cnt <= 4'd0;
    else    if( (SPI_CS == 1'b0) && (cnt == 2'd0) )
        send_bit_cnt <= send_bit_cnt + 4'd1;
    else    if(SPI_CS == 1'd1)
        send_bit_cnt <= 4'd0;
    else    
        send_bit_cnt <= send_bit_cnt;
        
   
//MOSI
//put the data from keepdata to mosi bit by bit, from MSB to LSB
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        SPI_MOSI <= 1'd0;
    else    if(SPI_CS == 1'b0 && cnt == 2'd0)
        SPI_MOSI <= keep_data[7 - send_bit_cnt];
    else    if(SPI_CS == 1'b1)
        SPI_MOSI <= 1'b0;
    else
        SPI_MOSI <= SPI_MOSI;
        
//endflag
//When a transmission is complete, endflag will generate a pulse
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        endflag <= 1'b0;
    else    if(send_bit_cnt == 4'd0 && cnt == 2'd3)
        endflag <= 1'b1;
    else
        endflag <= 1'b0;

//real_endflag
//real endflag is same as endflag but with 1 system clock period delay, it is the flag for SPI CS, when received this flag, SPI CS should be back to 1, and finished the transmission
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        real_endflag <= 1'b0;
    else    if(endflag == 1'b1)
        real_endflag <= 1'b1;
    else  
        real_endflag <= 1'b0;
        
        
        
        
endmodule










