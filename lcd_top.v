module lcd_top (
	input wire	clk,
	input wire	rst,
	input wire	scl,
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
        .sda				(i2c_sda),
        .scl				(i2c_scl) 
    );
	 
    lcd_i2c lcd_i2c_inst(
	.clk				(clk),
	.lcd_data		(lcd_data),
	.sda				(i2c_sda),
	.scl				(i2c_scl)
    );

    // LCD data to display ""
    reg [7:0] data_reg;
    reg start_reg;
    
    always @(posedge clk or negedge sda) begin
        if (!sda) begin
            data_reg <= 8'b0; 
            start_reg <= 8'b0;
        end else begin
            data_reg <= 8'b1;
            start_reg <= 8'b1;     // Start
        end
    end
    
    assign lcd_data = data_reg;
 //   assign start = start_reg;

endmodule
