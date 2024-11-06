module lcd_i2c (
    input 		wire	 clk,						// pin_23 
	 output 		reg 	 lcd_en,				// enable
	 output 		reg 	 lcd_rs,				// Register / Select
//	 output 		reg 	 lcd_rw,				// Read / Write 1/0
	 output 		reg    lcd_data,				// upper bits
	 inout		wire	 sda,
	 inout		wire	 scl
);

integer i;
integer j;
reg [20:0] count = 0;
reg [7:0] data;
reg lcd_rw = 1'b0;
		
always @(posedge clk) 
	begin
	count <= count + 1;
	
	case (count[20:0])
	
0: data   <=  8'h38;   	//-- control instruction : configure - 2 lines, 5x8 matrix --
1: data   <=  8'h0C;   	//-- control instruction : Display on, cursor off --
2: data   <=  8'h06;   	//-- control instruction : Increment cursor : shift cursor to right --
3: data   <=  8'h01;   	//-- control instruction : clear display screen --
4: data   <=  8'h80;   	//-- control instruction : begin at first line --

// Parking System 
5:  data  <=  8'h50;   	
6:  data  <=  8'h61;   	
7:  data  <=  8'h72;   	
8:  data  <=  8'h6B;   	
9:  data  <=  8'h69;   	
10: data  <=  8'h6E;   	
11: data  <=  8'h67;
12: data  <=  8'h20; 
13: data  <=  8'h53;   	
14: data  <=  8'h79;   	
15: data  <=  8'h73;   
16: data  <=  8'h74;   	
17: data  <=  8'h65;   	
18: data  <=  8'h6D;   	  	 	

	endcase
end	
		
always @(posedge clk) begin
//-- Delay for writing data
	
  if (i <= 1000000) begin
  i = i + 1; lcd_en = 1;
  data = data[j];
  end
  
  else if (i > 1000000 & i < 2000000) begin
  i = i + 1; lcd_en = 0;
  end
  
  else if (i == 2000000) begin
  j = j + 1; i = 0;
  end
  else i = 0;
  
 //-- LCD_RS signal should be set to 0 for writing commands and to 1 for writing data

  if (j <= 5 ) lcd_rs = 0;  
  else if (j > 5 & j< 22) lcd_rs = 1;   
  else if (j == 22) lcd_rs = 0;
  else if (j > 22) begin 
  lcd_rs = 1; j = 5;
  end
 
 end
endmodule
