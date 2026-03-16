module top_uart_echo(

    input wire clk,
    input wire rst,
    input wire rx,
    output wire tx

);

wire baud_tick;

wire [7:0] rx_data;
wire rx_done;

wire [7:0] tx_data;
wire tx_start;
wire tx_busy;

baud_gen baud_inst(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

uart_rx rx_inst(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

uart_controller ctrl_inst(
    .clk(clk),
    .rst(rst),
    .rx_done(rx_done),
    .rx_data(rx_data),
    .tx_busy(tx_busy),
    .tx_start(tx_start),
    .tx_data(tx_data)
);

uart_tx tx_inst(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

endmodule
