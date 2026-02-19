module wishbonewalker (
    i_clk,
    i_cyc,
    i_stb,
    i_we,
    i_addr,
    i_data,
    o_stall,
    o_ack,
    o_data
);
  input wire i_clk;
  input wire i_cyc;
  input wire i_stb;
  input wire i_we;
  input wire i_addr;
  input wire [5:0] i_data;
  output wire o_stall;
  output wire o_ack;
  output wire [5:0] o_data;

  reg [3:0] state;
  reg [5:0] o_led;
  wire busy;

  // set defaults
  initial o_led = 6'h00;
  initial state = 0;
  initial busy = 0;

  initial o_ack = 1'b0;

  // Ack all transcations
  always @(posedge i_clk) o_ack <= (i_stb) && (!o_stall);

  //stall if cycle is requested
  assign o_stall = (busy) && (i_we);

  assign o_data  = o_led;

  /* Implement a state machine for the led walking
   * Go back and forth like the wavedrom signals
   */
  always @(posedge i_clk)
    if ((i_stb) && (!o_stall)) state <= 4'h1;
    else if (state >= 4'hB) state <= 4'h0;
    else if (state != 0) state <= state + 1'b1;


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
endmodule
