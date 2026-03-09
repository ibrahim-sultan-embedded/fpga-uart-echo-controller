module baud_gen
#(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)
(
    input wire clk,
    input wire rst,
    output reg baud_tick
);

localparam integer BAUD_DIV = CLK_FREQ / BAUD_RATE;

reg [31:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        baud_tick <= 0;
    end
    else begin
        if (counter == BAUD_DIV-1) begin
            counter <= 0;
            baud_tick <= 1;
        end
        else begin
            counter <= counter + 1;
            baud_tick <= 0;
        end
    end
end

endmodule