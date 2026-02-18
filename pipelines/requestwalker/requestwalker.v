module requestwalker (
    i_clk,
    i_request,
    o_led,
    o_busy
);
  output reg [5:0] o_led;
  output reg o_busy;
  input wire i_request;
  input wire i_clk;

  reg [31:0] counter;
  reg stb;
  reg [3:0] state;

  // set defaults
  initial stb = 0;
  initial o_led = 6'h01;
  initial state = 0;


  /* Implement 1hz strobe signal
   * Only every true on counter overrun
   * Counter overruns once a second
   */
  parameter integer CLK_RATE_HZ = 12_000_000;
  initial counter = CLK_RATE_HZ - 1;

  always @(posedge i_clk)
    if (counter == 0) counter <= CLK_RATE_HZ - 1;
    else counter <= counter - 1'b1;


  always @(posedge i_clk) begin
    stb <= 1'b0;
    if (counter == 0) stb <= 1'b1;
  end

  /* Implement a state machine for the led walking
   * Go back and forth like the wavedrom signals
   */
  always @(posedge i_clk)
    if (stb) begin
      if ((i_request) && (!o_busy)) state <= 4'h1;
      else if (state >= 4'hB) state <= 4'h0;
      else if (state != 0) state <= state + 1'b1;

    end

  assign o_busy = (state != 0);


  always @(posedge i_clk)
    case (state)
      4'h1: o_led <= 6'h01;
      4'h2: o_led <= 6'h02;
      4'h3: o_led <= 6'h04;
      4'h4: o_led <= 6'h08;
      4'h5: o_led <= 6'h10;
      4'h6: o_led <= 6'h20;
      4'h7: o_led <= 6'h10;
      4'h8: o_led <= 6'h08;
      4'h9: o_led <= 6'h04;
      4'ha: o_led <= 6'h02;
      4'hb: o_led <= 6'h01;
      default: o_led <= 6'h00;
    endcase
endmodule
