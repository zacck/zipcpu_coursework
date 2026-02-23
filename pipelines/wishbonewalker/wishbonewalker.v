module wishbonewalker (
    i_clk,
    i_cyc,
    i_stb,
    i_we,
    i_addr,
    i_data,
    o_stall,
    o_ack,
    o_data,
    o_led
);
  input wire i_clk;

  //Wishbone
  input wire i_cyc, i_stb, i_we;
  input wire i_addr;
  input wire [5:0] i_data;

  output wire o_stall;
  output reg o_ack;
  output wire [5:0] o_data;

  output reg [5:0] o_led;

  parameter integer SIM_EN = 0;

  if (SIM_EN == 1) begin : gen_sim_1
    `define SIM_ON
  end

  reg [3:0] state;
  wire busy;

  // set defaults
  initial state = 0;
  initial o_ack = 1'b0;

  /* Implement a state machine for the led walking
   * Go back and forth like the wavedrom signals
   */
  always @(posedge i_clk)
    if ((i_stb) && (i_we) && (!o_stall)) state <= 4'h1;
    else if (state >= 4'd11) state <= 4'h0;
    else if (state != 0) state <= state + 1'b1;


  // Ack all transcations
  always @(posedge i_clk) o_ack <= (i_stb) && (!o_stall);

  //stall if cycle is requested
  assign o_stall = (busy) && (i_we);

  assign o_data = o_led;


  // Continously assign a busy signal depending on our state
  assign busy = (state != 0);


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

`ifdef SIM_ON
  reg f_past_valid;
  initial f_past_valid = 0;
  always @(posedge i_clk) f_past_valid = 1'b1;

  /*Validate state machine*/
  always_comb
    case (state)
      4'h1: assert (o_led == 6'h01);
      4'h2: assert (o_led == 6'h02);
      4'h3: assert (o_led == 6'h04);
      4'h4: assert (o_led == 6'h08);
      4'h5: assert (o_led == 6'h10);
      4'h6: assert (o_led == 6'h20);
      4'h7: assert (o_led == 6'h10);
      4'h8: assert (o_led == 6'h08);
      4'h9: assert (o_led == 6'h04);
      4'ha: assert (o_led == 6'h02);
      4'hb: assert (o_led == 6'h01);
      default: assert (o_led == 6'h00);
    endcase

  always_comb assert (busy != (state == 0));

  always_comb assert (state <= 4'hb);

  /* Stall when we get i_we and valid i_stb
   * State should be 1
   */
  always @(posedge i_clk)
    if ((f_past_valid) && ($past(i_stb)) && ($past(i_we)) && (!$past(o_stall))) begin
      assert (state == 1);
      assert (busy);
    end


  /* Check that state increments within bounds*/
  always @(posedge i_clk)
    if ((f_past_valid) && ($past(busy)) && ($past(state < 4'hb)))
      assert (state == $past(state) + 1);

  // Bus should start at idle
  initial assume (i_cyc);

  // i_stb only if i_cyc
  always_comb if (!i_cyc) assume (!i_stb);

  // i_cyc goes high i_stb should too
  always @(posedge i_clk) if ((!$past(i_cyc)) && (i_cyc)) assume (i_stb);

  // Requests are stalled
  always @(posedge i_clk)
    if ((f_past_valid) && ($past(i_stb)) && ($past(o_stall))) begin
      assume (i_stb);
      assume (i_we == $past(i_we));
      assume (i_addr == $past(i_addr));
      if (i_we) assume (i_data == $past(i_data));
    end

  /* We ack every request*/
  always @(posedge i_clk) if ((f_past_valid) && ($past(i_stb)) && (!$past(o_stall))) assert (o_ack);

  always @(posedge i_clk) if (f_past_valid) cover ((!busy) && ($past(busy)));
`endif
endmodule
