`default_nettype none

module envelope_detector(
    input wire clk,
    input signed [7:0] signal,
    output reg [7:0] env
);

always @(posedge clk)
begin
    if(signal < 0)
        env <= -signal;
    else
        env <= signal;
end

endmodule

`default_nettype wire
