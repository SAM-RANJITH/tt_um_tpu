`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump waveform
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end

  // Inputs
  reg clk = 0;
  reg rst_n = 0;
  reg ena = 1;
  reg [7:0] ui_in = 0;
  reg [7:0] uio_in = 0;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Clock generation
  always #5 clk = ~clk;

  // DUT
  tt_um_gpr_processor  user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // Test sequence
  initial begin

    // Reset
    #20;
    rst_n = 1;

    // Example stimulus
    ui_in = 8'hAA;
    #20;

    ui_in = 8'h55;
    #20;

    ui_in = 8'hFF;
    #20;

    // End simulation
    #100;
    $finish;

  end

endmodule
