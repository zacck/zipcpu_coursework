`default_nettype none
module tfail (
    i_clk,
    o_led
);

  parameter integer NBITS = 1024;
  input wire i_clk;
  output wire o_led;

  reg [NBITS-1:0] counter;

  initial counter = 0;

  always @(posedge i_clk) counter <= counter + 1;

  assign o_led = counter[NBITS-1];
endmodule
