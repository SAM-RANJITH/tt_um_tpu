`default_nettype none

module fir_filter(
    input wire clk,
    input wire [7:0] din,
    output reg [7:0] dout
);

reg [7:0] d1,d2,d3;
reg [9:0] acc;

always @(posedge clk)
begin
    d3 <= d2;
    d2 <= d1;
    d1 <= din;

    acc = din + (d1<<1) + (d2<<1) + d3;

    dout <= acc[9:2];
end

endmodule

`default_nettype wire
