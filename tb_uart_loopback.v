`timescale 1ns/1ps

module tb_uart_loopback;

reg clk;
reg rst;
reg baud_tick;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

wire [7:0] rx_data;
wire rx_done;

uart_tx tx_inst(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

uart_rx rx_inst(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(tx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    baud_tick = 0;
    forever begin
        #80;
        baud_tick = 1;
        #20;
        baud_tick = 0;
    end
end

initial begin

    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #100
    rst = 0;

    #100

    tx_data = 8'hA5;
    tx_start = 1;

    #20
    tx_start = 0;

    #5000

    $finish;

end

endmodule
