module counter(
    input   wire            sys_clk     ,
    input   wire            sys_rst     ,
    input   wire    [12:0]  data1       ,
    input   wire    [12:0]  data2       ,
    
    output  reg             cnt100_flag ,//modi
    output  reg     [7:0]   totalpark
);

parameter   TOTALPARK = 8'd10;
parameter   CNT100_MAX = 26'd4_999_999;//modi

reg     [1:0]   entercount;
reg     [1:0]   outcount;
reg             enterflag;
reg             outflag;

reg     [26:0]  cnt_100ms;


initial
    begin
        totalpark = TOTALPARK;
    end
    
 
always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)
        cnt_100ms <= 27'd0;
    else    if(cnt_100ms == CNT100_MAX)
        cnt_100ms <= 27'd0;
    else    
        cnt_100ms <= cnt_100ms + 27'd1;
        
        
always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)
        cnt100_flag <= 1'b0;
    else    if(cnt_100ms == CNT100_MAX)
        cnt100_flag <= 1'b1;
    else
        cnt100_flag <= 1'b0;



 
always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)
        enterflag <= 1'b0;
    else    if(data1 < 13'd60)
        enterflag <= 1'b1;
    else    if(data1 >= 13'd60)
        enterflag <= 1'b0;
    else
        enterflag <= enterflag;
        
        
        
        
always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)  
        outflag <= 1'b0;
    else    if(data2 < 13'd60)
        outflag <= 1'b1;
    else    if(data2 >= 13'd60)
        outflag <= 1'b0;
    else
        outflag <= outflag;
        
        
  
 
always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)
        entercount <= 2'd0;
    else    if( (data1 >= 13'd60) && (enterflag == 1'b1) )
        entercount <= 2'd1;
    else    
        entercount <= 2'd0;
  
  
        
always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)
        outcount <= 2'd0;
    else    if( (data2 >= 13'd60) && (outflag == 1'b1) )
        outcount <= 2'd1;
    else
        outcount <= 2'd0;
        
        
always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)
        totalpark <= TOTALPARK;
    else    if(totalpark == 8'd0)
        totalpark <= totalpark + outcount;
    else
        totalpark <= (totalpark + outcount) - entercount;
  


endmodule  