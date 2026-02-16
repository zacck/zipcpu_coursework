`default_nettype none
module ledwalkersm (
    i_clk,
    o_led
);
  parameter integer SIM_EN = 0;

  if(SIM_EN == 1) begin
	  `define SIM_ON
  end 

  output reg [7:0] o_led;
  input wire i_clk;

  reg [31:0] counter;
  reg stb;
  reg [3:0] led_index;

  // set defaults
  initial stb = 0;
  initial o_led = 8'h01;
  initial led_index = 0;

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
      if (led_index > 4'd12) led_index <= 0;
      else led_index <= led_index + 1'b1;
    end

  always @(posedge i_clk)
    case (led_index)
      4'h0: o_led <= 8'h01;
      4'h1: o_led <= 8'h02;
      4'h2: o_led <= 8'h04;
      4'h3: o_led <= 8'h08;
      4'h4: o_led <= 8'h10;
      4'h5: o_led <= 8'h20;
      4'h6: o_led <= 8'h40;
      4'h7: o_led <= 8'h80;
      4'h8: o_led <= 8'h40;
      4'h9: o_led <= 8'h20;
      4'ha: o_led <= 8'h10;
      4'hb: o_led <= 8'h08;
      4'hc: o_led <= 8'h04;
      4'hd: o_led <= 8'h02;
      default: o_led <= 8'h01;
    endcase

    `ifdef SIM_ON
	    // Design always stays within bounds
	    always @(posedge i_clk)
		    assert (led_index <= 4'd13);

	    // integer clock divider stays within bounds
	    always @(posedge i_clk)
		    assert (counter <= CLK_RATE_HZ-1); 

	    reg f_valid_output;
	    // FSM only arrives to valid states
	    always@(*)
	    begin
		    f_valid_output = 0;
		    case(o_led)
                    8'h01: f_valid_output = 1'b1;
		    8'h02: f_valid_output = 1'b1;
                    8'h04: f_valid_output = 1'b1;
                    8'h08: f_valid_output = 1'b1;
                    8'h10: f_valid_output = 1'b1;
                    8'h20: f_valid_output = 1'b1;
                    8'h40: f_valid_output = 1'b1;
                    8'h80: f_valid_output = 1'b1;
		    default: f_valid_output = 1'b0;
		    endcase
		    assert(f_valid_output);
            end 

    `endif
endmodule
