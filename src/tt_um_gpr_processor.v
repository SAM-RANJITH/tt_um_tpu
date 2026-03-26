`default_nettype none
`timescale 1ns/1ps

module tt_um_gpr_processor (
    input  wire [7:0] ui_in,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    output wire [7:0] uo_out,

    input  wire clk,
    input  wire rst_n,
    input  wire ena
);

assign uio_out = 8'b0;
assign uio_oe  = 8'b0;

wire [7:0] sample_in;
wire [7:0] fir_out;
wire [7:0] envelope_out;
wire detect;

assign sample_in = ui_in;

fir_filter FIR (
    .clk(clk),
    .din(sample_in),
    .dout(fir_out)
);

envelope_detector ENV (
    .clk(clk),
    .signal(fir_out),
    .env(envelope_out)
);

peak_detector PEAK (
    .clk(clk),
    .signal(envelope_out),
    .detect(detect)
);

assign uo_out[7:1] = envelope_out[7:1];
assign uo_out[0]   = detect;

endmodule

`default_nettype wire
