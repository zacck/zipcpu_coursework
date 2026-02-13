`default_nettype none
module dimmer (
    i_clk,
    o_led
);

  input wire i_clk;
  output wire o_led;

  reg [12:0] counter;


  always @(posedge i_clk) counter <= counter + 1;

  assign o_led = (counter[2:0] < counter[12:10]);
endmodule
