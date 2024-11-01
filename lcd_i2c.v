module lcd_i2c (
    input wire clk,
    input wire rst_n,
    output wire sda,
    output wire scl
);
    // Internal wires
    wire i2c_sda;
    wire i2c_scl;
    wire [7:0] lcd_data;
    wire start;

    // Instantiate the I2C Master module
    i2c_master i2c_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in(lcd_data),
        .sda(i2c_sda),
        .scl(i2c_scl)
    );

    // Assign outputs to FPGA pins
    assign sda = i2c_sda;
    assign scl = i2c_scl;

    // LCD data to display "Hello"
    assign lcd_data = 8'h48; // ASCII for 'H'
    assign start = 1'b1;     // Start condition
    reg [7:0] lcd_data_reg;
    reg start_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lcd_data_reg <= 8'h48; // ASCII for 'H'
            start_reg <= 1'b0;
        end else begin
            lcd_data_reg <= 8'h48;
            start_reg <= 1'b1;     // Start condition
        end
    end
    
    assign lcd_data = lcd_data_reg;
    assign start = start_reg;

endmodule


// module lcd_i2c (
//     input wire clk,
//     input wire reset,
//     inout wire sda,
//     output wire scl,
//     output wire [7:0] data,
//     output wire rs,
//     output wire rw,
//     output wire en
// );

//     // I2C address for the LCD
//     parameter I2C_ADDR = 7'h27;

//     // State machine states
//     typedef enum logic [2:0] {
//         IDLE,
//         START,
//         ADDR,
//         WRITE,
//         STOP
//     } state_t;

//     state_t state, next_state;

//     // I2C signals
//     reg [7:0] i2c_data;
//     reg i2c_start, i2c_stop, i2c_write;
//     wire i2c_ack;

//     // LCD control signals
//     reg [7:0] lcd_data;
//     reg lcd_rs, lcd_rw, lcd_en;

//     // Clock divider for I2C clock
//     reg [15:0] clk_div;
//     wire i2c_clk = clk_div[15];

//     // Clock divider process
//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             clk_div <= 16'd0;
//         end else begin
//             clk_div <= clk_div + 1;
//         end
//     end

//     // State machine process
//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             state <= IDLE;
//         end else begin
//             state <= next_state;
//         end
//     end

//     // Next state logic
//     always @(*) begin
//         case (state)
//             IDLE: begin
//                 if (i2c_start) begin
//                     next_state = START;
//                 end else begin
//                     next_state = IDLE;
//                 end
//             end
//             START: begin
//                 next_state = ADDR;
//             end
//             ADDR: begin
//                 if (i2c_ack) begin
//                     next_state = WRITE;
//                 end else begin
//                     next_state = STOP;
//                 end
//             end
//             WRITE: begin
//                 if (i2c_ack) begin
//                     next_state = STOP;
//                 end else begin
//                     next_state = WRITE;
//                 end
//             end
//             STOP: begin
//                 next_state = IDLE;
//             end
//             default: begin
//                 next_state = IDLE;
//             end
//         endcase
//     end

//     // I2C control process
//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             i2c_start <= 1'b0;
//             i2c_stop <= 1'b0;
//             i2c_write <= 1'b0;
//             i2c_data <= 8'd0;
//         end else begin
//             case (state)
//                 IDLE: begin
//                     i2c_start <= 1'b1;
//                     i2c_stop <= 1'b0;
//                     i2c_write <= 1'b0;
//                     i2c_data <= {I2C_ADDR, 1'b0};
//                 end
//                 START: begin
//                     i2c_start <= 1'b0;
//                     i2c_write <= 1'b1;
//                 end
//                 ADDR: begin
//                     i2c_write <= 1'b0;
//                     i2c_data <= lcd_data;
//                 end
//                 WRITE: begin
//                     i2c_write <= 1'b1;
//                 end
//                 STOP: begin
//                     i2c_stop <= 1'b1;
//                 end
//                 default: begin
//                     i2c_start <= 1'b0;
//                     i2c_stop <= 1'b0;
//                     i2c_write <= 1'b0;
//                 end
//             endcase
//         end
//     end

//     // LCD control signals
//     assign data = lcd_data;
//     assign rs = lcd_rs;
//     assign rw = lcd_rw;
//     assign en = lcd_en;

//     // I2C signals
//     assign scl = i2c_clk;
//     assign sda = (i2c_write) ? i2c_data[7] : 1'bz;

// endmodule
