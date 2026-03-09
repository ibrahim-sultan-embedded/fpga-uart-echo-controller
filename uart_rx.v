module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       rx,
    output reg  [7:0] rx_data,
    output reg        rx_done
);

reg [3:0] bit_index;
reg [7:0] data_reg;
reg [1:0] state;

localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        bit_index <= 0;
        data_reg <= 0;
        rx_done <= 0;
    end else begin
        rx_done <= 0;

        case(state)

        IDLE: begin
            if (rx == 0) begin
                state <= START;
            end
        end

        START: begin
            if (baud_tick) begin
                state <= DATA;
                bit_index <= 0;
            end
        end

        DATA: begin
            if (baud_tick) begin
                data_reg[bit_index] <= rx;
                if (bit_index == 7) begin
                    state <= STOP;
                end else begin
                    bit_index <= bit_index + 1;
                end
            end
        end

        STOP: begin
            if (baud_tick) begin
                rx_data <= data_reg;
                rx_done <= 1;
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule