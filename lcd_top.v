module lcd_top (
	input wire	clk,
	input wire	rst,
	
	inout wire	scl,
	inout wire	sda
);

	 // Internal wires
    wire	 i2c_sda;
    wire	 i2c_scl;
    wire	 [7:0] lcd_data;
    wire	 start;

    // Instantiate the I2C Master module
    master_i2c master_i2c_inst(
        .clk				(clk),
        .rst				(rst),
		  .data				(data),
		  .rs					(rs),
		  .rw					(rw),
		  .en					(en)
/*      .start				(start),
        .data_in			(lcd_data),
        .sda				(i2c_sda),
        .scl				(i2c_scl) 
		  
*/
    );
	 
	 lcd_i2c lcd_i2c_inst(
			.clk				(clk),
			.rst_n			(rst_n),
			.lcd_e			(lcd_e),
			.lcd_rs			(lcd_rs),
			.lcd_data		(lcd_data)
	  );

    // LCD data to display ""
    reg [7:0] lcd_data_reg;
    reg start_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lcd_data_reg <= 8'h1; 
            start_reg <= 1'b0;
        end else begin
            lcd_data_reg <= 8'h50;
            start_reg <= 1'b1;     // Start
        end
    end
    
    assign lcd_data = lcd_data_reg;
    assign start = start_reg;

endmodule