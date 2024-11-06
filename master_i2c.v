module master_i2c (
    input  wire clk,
    input  wire rst,
	 output wire scl,
	 inout  wire sda
);

	 wire i2c_sda = 8'b1;
	 wire i2c_scl = 8'b1;
	 
	 assign sda = i2c_sda;
	 assign scl = i2c_scl;
	 
    // FSM definitions
    localparam STATE_IDLE = 0;
    localparam STATE_START = 1;
    localparam STATE_ADDRESS = 2;
    localparam STATE_ACK = 3;
    localparam STATE_WRITE = 4;
    localparam STATE_STOP = 5;
	 
    // LCD I2C address 0x27
    localparam [7:0] LCD_ADDR = 8'h27;
	 
    reg [2:0] state_reg, state_next;
    reg [7:0] data_reg, data_next;
    reg rs_reg, rs_next;
    reg rw_reg, rw_next;
    reg en_reg, en_next;
    reg [15:0] init_counter;

    // Initialisation
    always @(posedge clk or posedge rst) 
	 begin
        if (rst) begin
            state_reg <= STATE_IDLE;
            data_reg <= 8'b0;
            rs_reg <= 1'b0;
            rw_reg <= 1'b0;
            en_reg <= 1'b0;
            init_counter <= 15'b0;
        end else begin
            state_reg <= state_next;
            data_reg <= data_next;
            rs_reg <= rs_next;
            rw_reg <= rw_next;
            en_reg <= en_next;
            if (state_reg == STATE_IDLE) begin
                init_counter <= init_counter + 1;
            end
        end
    end

	// open case for each state
    always @(*) 
	 begin
        state_next = state_reg;
        data_next = data_reg;
        rs_next = rs_reg;
        rw_next = rw_reg;
        en_next = en_reg;

        case (state_reg)
            STATE_START: begin
                if (init_counter < 16'h1) begin
                    // Wait for power-up
                    state_next = STATE_START;
                end else if (init_counter < 16'h2) begin
                    // Function set: 8-bit, 2 line, 5x8 dots
                    data_next = 8'b00000001;
                    rs_next = 1'b0;
                    rw_next = 1'b0;
                    en_next = 1'b1;
                    state_next = STATE_ADDRESS;
                end else if (init_counter < 16'h3) begin
                    // Display on/off control: display on, cursor off, blink off
                    data_next = 8'h27;
                    rs_next = 1'b0;
                    rw_next = 1'b1;
                    en_next = 1'b0;
                    state_next = STATE_ACK;
                end else if (init_counter < 16'h4) begin
                    // Clear display
                    data_next = 8'b00000011;
                    rs_next = 1'b0;
                    rw_next = 1'b0;
                    en_next = 1'b1;
                    state_next = STATE_WRITE;
                end else begin
                    state_next = STATE_IDLE;
                end
            end

            STATE_IDLE: begin
                // Idle state, waiting for commands
                en_next = 8'h0;
            end

            STATE_WRITE: begin
                // Write data
                en_next = 8'h4;
                state_next = STATE_IDLE;
            end
        endcase
    end

    // Output assignments
 //   assign data = lcd_data;
 //   assign rs = lcd_rs;
 //   assign rw = lcd_rw;
 //   assign en = lcd_en;
		assign sda = i2c_sda;
		assign scl = i2c_scl;
		
endmodule
