`include "chgdetector.v"
`include "counter.v"
`include "txdata.v"

`default_nettype none

module top(i_clk,
	i_event,
`ifdef SIM 
	o_setup,
`endif
	o_uart_tx);

	parameter CLOCK_RATE_HZ = 12_000_000; 
	parameter BAUD_RATE = 115_200; 

	input wire i_clk, i_event; 
	output wire o_uart_tx; 

	parameter UART_SETUP = (CLOCK_RATE_HZ /BAUD_RATE);

`ifdef SIM 
	output wire [31:0] o_setup; 
	assign o_setup = UART_SETUP; 
`endif 

	wire  [31:0] counterv, tx_data;
	wire  tx_busy, tx_stb; 

	counter topcounter(i_clk, 1'b0, i_event, counterv); 

	chgdetector topdiffer(i_clk, counterv, tx_stb, tx_data, tx_busy);

	txdata #(UART_SETUP)
		topworder(i_clk, 1'b0, tx_stb, tx_data, tx_busy, o_uart_tx);
endmodule
