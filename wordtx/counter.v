module counter(i_clk,
	i_rst,
	i_event,
	o_counter);
 input wire  i_clk, i_event, i_rst; 
 output reg  [31:0] o_counter;

 initial o_counter = 0;

 // On reset start afresh
 always @(posedge i_rst) 
	 o_counter <= 0; 

 // if an event occurs count the event
 always @(posedge i_clk)
	 if(i_event)
		 o_counter <= o_counter + 1'b1;
endmodule
