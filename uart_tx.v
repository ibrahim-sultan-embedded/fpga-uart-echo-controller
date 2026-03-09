module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy
);

    reg [3:0] bit_index;
    reg [9:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            bit_index <= 4'd0;
            shift_reg <= 10'b1111111111;
        end else begin
            if (!tx_busy) begin
                tx <= 1'b1;
                if (tx_start) begin
                    shift_reg <= {1'b1, tx_data, 1'b0};
                    tx_busy   <= 1'b1;
                    bit_index <= 4'd0;
                end
            end else if (baud_tick) begin
                tx <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};

                if (bit_index == 4'd9) begin
                    tx_busy   <= 1'b0;
                    bit_index <= 4'd0;
                end else begin
                    bit_index <= bit_index + 1'b1;
                end
            end
        end
    end

endmodule