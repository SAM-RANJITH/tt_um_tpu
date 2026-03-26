`default_nettype none

module peak_detector(
    input wire clk,
    input wire [7:0] signal,
    output reg detect
);

parameter THRESHOLD = 8'd120;

always @(posedge clk)
begin
    if(signal > THRESHOLD)
        detect <= 1'b1;
    else
        detect <= 1'b0;
end

endmodule

`default_nettype wire
