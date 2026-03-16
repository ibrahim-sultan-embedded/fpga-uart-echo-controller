module uart_controller(

    input wire clk,
    input wire rst,

    input wire rx_done,
    input wire [7:0] rx_data,

    input wire tx_busy,

    output reg tx_start,
    output reg [7:0] tx_data

);

localparam IDLE = 2'd0;
localparam SEND = 2'd1;

reg [1:0] state;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        state <= IDLE;
        tx_start <= 0;
        tx_data <= 0;
    end

    else begin

        tx_start <= 0;

        case(state)

        IDLE:
        begin
            if(rx_done) begin
                tx_data <= rx_data;
                state <= SEND;
            end
        end

        SEND:
        begin
            if(!tx_busy) begin
                tx_start <= 1;
                state <= IDLE;
            end
        end

        endcase

    end

end

endmodule
