module baud_gen(

    input wire clk,
    input wire rst,
    output reg baud_tick

);

parameter DIV = 50;

reg [15:0] counter;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        counter <= 0;
        baud_tick <= 0;
    end

    else begin

        if(counter == DIV-1) begin
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
