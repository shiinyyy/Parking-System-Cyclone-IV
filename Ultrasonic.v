/*module Ultrasonic
#(
	parameter	CNT100_MAX = 26'd4_999_9999,
	parameter	CNT20_MAX = 10'd999
)
(
	input	wire			sys_clk,
	input	wire			sys_rst,
	input	wire			echo,
	
	output	reg			trig,
	output	reg	[19:0]	data
);


reg		[26:0]		cnt_100ms;
reg		[10:0]		cnt_20us;
reg					cnt100_flag;
reg					cnt20adding_flag;

reg					echo1;
reg					echo2;
reg		[31:0]		time_sum;

reg				    echo_flag;



always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		cnt_100ms <= 27'd0;
	else	if(cnt_100ms == CNT100_MAX)
		cnt_100ms <= 27'd0;
	else
		cnt_100ms <= cnt_100ms + 27'd1;
		
		

always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		cnt100_flag <= 1'b0;
	else	if(cnt_100ms == CNT100_MAX)
		cnt100_flag <= 1'b1;
	else
		cnt100_flag <= 1'b0;
		
		
		
always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		cnt20adding_flag <= 1'b0;
	else	if(cnt_20us == CNT20_MAX)
		cnt20adding_flag <= 1'b0;
	else	if(cnt100_flag == 1'b1)
		cnt20adding_flag <= 1'b1;
	else	
		cnt20adding_flag <= cnt20adding_flag;
		
		
		

always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		cnt_20us <= 11'd0;
	else	if(cnt_20us == CNT20_MAX)
		cnt_20us <= 11'd0;
	else	if(cnt20adding_flag == 1'b1)
		cnt_20us <= cnt_20us + 11'd1;
	else
		cnt_20us <= 11'd0;



always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		trig <= 1'b0;
	
	else	if(cnt_20us == CNT20_MAX)
		trig <= 1'b0;
	else	if(cnt100_flag == 1'b1)
		trig <= 1'b1;
	else
		trig <= trig;
		


always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		echo1 <= 1'b0;
	else
		echo1 <= echo;
		

always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		echo2 <= 1'b0;
	else
		echo2 <= echo1;
		
		
		

always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		time_sum <= 32'd0;
	
	else	if(echo2 == 1'b0)
		time_sum <= 32'd0;
	else	if(echo2 == 1'b1)
		time_sum <= time_sum + 32'd1;
	else	
		time_sum <= time_sum;
		
        
        
always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
        echo_flag <= 1'b0;
    else    
        echo_flag <= (~echo1) & echo2;
    	


always@(posedge sys_clk or negedge sys_rst)
	if(sys_rst == 1'b0)
		data <= 20'd0;
	else	if(echo_flag == 1'b1)
		data <= time_sum;//(time_sum*34)/1_000_00; //in cm
	else
		data <= data;
		
		
endmodule*/




module Ultrasonic
(
    input   wire            sys_clk         ,//100MHz
    input   wire            sys_rst_n       ,//active low
    input   wire            echo            ,//
    


	output  reg     [12:0]  data_bin        ,//data
    output  reg             trig             //
);
 
//parameter define
parameter   CNT_100MS_MAX = 24'd5_000_000;//100ms/10ns = 10*10^7
parameter   CNT_10US_MAX  = 10'd1000 ;//10us/10ns = 1000
 
//wire or reg define
reg     [23:0]  cnt_100ms   ;
reg             echo_r      ;//
reg     [21:0]  cnt_echo    ;//
wire            echo_neg    ;//
reg             echo_neg_r  ;
reg     [21:0]  cnt_echo_r  ;
 
//main code
 
//100ms
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_100ms<=24'd0;
    else if(cnt_100ms==CNT_100MS_MAX-1'b1)
        cnt_100ms<=24'd0;
    else
        cnt_100ms<=cnt_100ms+1'b1;
end
 
//trig
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        trig<=1'b0;
    else if(cnt_100ms<=CNT_10US_MAX-1'b1)
        trig<=1'b1;
    else
        trig<=1'b0;
end 
 
//echo_r
assign  echo_neg = (~echo) & echo_r ;// ? 1'b1 : 1'b0 ;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        echo_r<=1'b0;
    else
        echo_r<=echo;
end
//cnt_echo
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_echo<=22'd0;
    else if(echo_r)
        cnt_echo<=cnt_echo+1'b1;
    else
        cnt_echo<=22'd0;
end 
 
//cnt_echo_r
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_echo_r<=22'd0;
    else if(echo_neg)
        cnt_echo_r<=cnt_echo;
    else
        cnt_echo_r<=cnt_echo_r;
end 
//echo_neg_r
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        echo_neg_r<=1'b0;
    else
        echo_neg_r<=echo_neg;
end 
 
//s=N*10*340_000/1000_000_000/2 mm = N*0.0017 mm = N*17/10000 ;
//data_bin
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        data_bin<=13'd0;
    else if(echo_neg_r)
        data_bin<=cnt_echo_r*34/10000; //--
    else
        data_bin<=data_bin;
end 

//fall_flag_r1
/*always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        fall_flag_r1<=1'b0;
    else
        fall_flag_r1<=echo_neg_r;
end */
 
endmodule

