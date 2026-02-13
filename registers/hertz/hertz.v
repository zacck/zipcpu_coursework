`default_nettype none
module hertz (
    i_clk,
    o_led
);

  parameter integer CLOCK_RATE_HZ = 12_000_000;
  input wire i_clk;
  output reg o_led;

  reg [31:0] counter;

  initial counter = 0;

  always @(posedge i_clk)
    if (counter >= CLOCK_RATE_HZ) begin
      counter <= 0;
      o_led   <= !o_led;
    end else counter <= counter + 1;

endmodule
