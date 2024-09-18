module i2c_master (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] data_in,
    output reg sda,
    output reg scl
);
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
                        bit_cnt <= bit_cnt - 1;
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
