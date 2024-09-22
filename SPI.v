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
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0) 
        SPI_CS <= 1'b1;
    else    if(SPI_start == 1'b1)
        SPI_CS <= 1'b0;
    else    if(real_endflag == 1'b1)
        SPI_CS <= 1'b1;
    else
        SPI_CS <= SPI_CS;


//Send_bit
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
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        endflag <= 1'b0;
    else    if(send_bit_cnt == 4'd0 && cnt == 2'd3)
        endflag <= 1'b1;
    else
        endflag <= 1'b0;

//real_endflag
always @(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        real_endflag <= 1'b0;
    else    if(endflag == 1'b1)
        real_endflag <= 1'b1;
    else  
        real_endflag <= 1'b0;
        
        
        
        
endmodule










