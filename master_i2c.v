/*module i2c_master (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] data_in,
    output reg sda,
    output reg scl
);
*/
module master_i2c (
    input wire clk,
    input wire rst,
    output wire [7:0] data,
    output wire rs,
    output wire rw,
    output wire en
);

    // State definitions
    localparam STATE_INIT = 0;
    localparam STATE_IDLE = 1;
    localparam STATE_WRITE = 2;

    reg [1:0] state_reg, state_next;
    reg [7:0] data_reg, data_next;
    reg rs_reg, rs_next;
    reg rw_reg, rw_next;
    reg en_reg, en_next;
    reg [15:0] init_counter;

    // Initialisation
    always @(posedge clk or posedge rst) 
	 begin
        if (rst) begin
            state_reg <= STATE_INIT;
            data_reg <= 8'b0;
            rs_reg <= 1'b0;
            rw_reg <= 1'b0;
            en_reg <= 1'b0;
            init_counter <= 16'd0;
        end else begin
            state_reg <= state_next;
            data_reg <= data_next;
            rs_reg <= rs_next;
            rw_reg <= rw_next;
            en_reg <= en_next;
            if (state_reg == STATE_INIT) begin
                init_counter <= init_counter + 1;
            end
        end
    end

    always @(*) 
	 begin
        state_next = state_reg;
        data_next = data_reg;
        rs_next = rs_reg;
        rw_next = rw_reg;
        en_next = en_reg;

        case (state_reg)
            STATE_INIT: begin
                if (init_counter < 16'd10000) begin
                    // Wait for power-up
                    state_next = STATE_INIT;
                end else if (init_counter < 16'd20000) begin
                    // Function set: 8-bit, 2 line, 5x8 dots
                    data_next = 8'b00111000;
                    rs_next = 1'b0;
                    rw_next = 1'b0;
                    en_next = 1'b1;
                    state_next = STATE_WRITE;
                end else if (init_counter < 16'd30000) begin
                    // Display on/off control: display on, cursor off, blink off
                    data_next = 8'b00001100;
                    rs_next = 1'b0;
                    rw_next = 1'b0;
                    en_next = 1'b1;
                    state_next = STATE_WRITE;
                end else if (init_counter < 16'd40000) begin
                    // Clear display
                    data_next = 8'b00000001;
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
                en_next = 1'b0;
            end

            STATE_WRITE: begin
                // Write data
                en_next = 1'b0;
                state_next = STATE_IDLE;
            end
        endcase
    end

    // Output assignments
    assign data = data_reg;
    assign rs = rs_reg;
    assign rw = rw_reg;
    assign en = en_reg;

endmodule
/*
    // State definitions
    reg [3:0] state;
    parameter IDLE = 4'd0;
    parameter START = 4'd1;
    parameter SEND = 4'd2;
    parameter STOP = 4'd3;

    reg [7:0] data;
    reg [2:0] bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sda <= 1'b1;
            scl <= 1'b1;
            data <= 8'd0;
            bit_cnt <= 3'd7;
        end else begin
            case (state)
                IDLE: begin
                    sda <= 1'b1;
                    scl <= 1'b1;
                    if (start) begin
                        state <= START;
                        data <= data_in;
                        bit_cnt <= 3'd7;
                    end
                end
                START: begin
                    sda <= 1'b0;
                    scl <= 1'b1;
                    state <= SEND;
                end
                SEND: begin
                    scl <= 1'b0;
                    sda <= data[bit_cnt];
                    scl <= 1'b1;
                    if (bit_cnt == 0)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt - 3'd1;
                end
                STOP: begin
                    scl <= 1'b1;
                    sda <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
	 
	 
endmodule
*/
