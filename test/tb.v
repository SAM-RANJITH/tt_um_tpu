`timescale 1ns/1ps
`default_nettype none

module tb;

reg clk=0;
always #5 clk=~clk;

reg rst_n=0, ena=1;
reg [7:0] ui_in=0, uio_in=0;

wire [7:0] uo_out;
wire [7:0] uio_out;

tt_um_braun_tpu dut(.*);

task write(input [7:0] d);
begin
  @(posedge clk); ui_in<=d; uio_in<=1;   // WE=1
  @(posedge clk); uio_in<=0;
end
endtask

initial begin
  $dumpfile("wave.vcd");
  $dumpvars(0,tb);

  repeat(5) @(posedge clk);
  rst_n=1;

  // load A
  write(2); write(3); write(4); write(5);

  // load B
  write(1); write(2); write(3); write(4);

  // start
  @(posedge clk);
  uio_in <= 8'b00000010; // start
  @(posedge clk);
  uio_in <= 0;

  // wait for done
  wait(uio_out[0] == 1);

  $display("Result = %0d", uo_out);

  #20;
  $finish;
end

endmodule
