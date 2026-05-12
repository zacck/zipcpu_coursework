`include "uartport.v"

`default_nettype none
module txdata(
	i_clk,
	i_reset,
	i_stb, 
	i_data, 
	o_busy, 
	o_uart_tx);

	parameter UART_SETUP = 868;
	input wire i_clk, i_stb, i_reset;
	input wire [31:0] i_data;
	output wire o_uart_tx;
	output wire o_busy;

	reg [3:0] state; 
	reg tx_stb; 
	wire tx_busy;
	initial tx_stb = 1'b0;
	initial state = 4'h0;

	assign o_busy = (state != 4'h0);

	always @(posedge i_clk)
		if(i_reset)
		begin 
			state  <= 4'h0;
			tx_stb <= 1'b0;
		end else if(!o_busy)
		begin
			if(i_stb)
			begin
				state <= 1;
				tx_stb <= 1;
			end
		end else if((tx_stb) && (!tx_busy))
		begin
			state <= state + 1'b1;
			if (state >= 4'hc)
			begin
				tx_stb <= 1'b0;
				state <= 4'h0;
			end  
		end

	reg [31:0] my_data_copy;
	initial my_data_copy = 0;

	always @(posedge i_clk)
		if(!o_busy)
			my_data_copy <= i_data; 
		else if ((!tx_busy) && (state > 4'h1))
			my_data_copy <= {i_data[27:0], 4'h0};

	reg [7:0] hex, tx_data;
	
	always @(posedge i_clk)
		case(my_data_copy[31:28])
			4'h0: hex <= "0"; 
			4'h1: hex <= "1";
			4'h2: hex <= "2";
			4'h3: hex <= "3";
			4'h4: hex <= "4";
			4'h5: hex <= "5";
			4'h6: hex <= "6"; 
			4'h7: hex <= "7";
			4'h8: hex <= "8"; 
			4'h9: hex <= "9"; 
			4'ha: hex <= "a"; 
			4'hb: hex <= "b";
			4'hc: hex <= "c"; 
			4'hd: hex <= "d";
			4'he: hex <= "e";
			4'hf: hex <= "f";
			default: begin end 
		endcase

	always @(posedge i_clk)
		if(!tx_busy)
			case(state)
				4'h1: tx_data <= "0";
				4'h2: tx_data <= "x"; 
				4'h3: tx_data <= hex; 
				4'h4: tx_data <= hex;
				4'h5: tx_data <= hex; 
				4'h6: tx_data <= hex; 
				4'h7: tx_data <= hex; 
				4'h8: tx_data <= hex; 
				4'h9: tx_data <= hex; 
				4'ha: tx_data <= hex; 
				4'hb: tx_data <= "\r"; 
				4'hc: tx_data <= "\n";
				default tx_data <= "Q";
			endcase


`ifndef SIM
	uartport #(UART_SETUP[23:0]) 
		txdatauart(i_clk, tx_stb, tx_data, o_uart_tx, tx_busy);
`else 
	
	(* anyseq *) wire serial_busy, serial_out; 
	assign o_uart_tx = serial_out; 
	assign tx_busy = serial_busy;
`endif 

`ifdef SIM 
	reg f_past_valid; 
	initial f_past_valid = 0; 
	always @(posedge i_clk)
		f_past_valid <= 1;
	reg [1:0] f_minbusy; 	
	initial f_minbusy = 0; 
	// Force F min buy to take at least 4 clocks 00, 01, 10, 11
	always @(posedge i_clk)
		if((tx_stb) && (!tx_busy))
			f_minbusy <= 2'b01; 
		else if (f_minbusy != 2'b00)
			f_minbusy <= f_minbusy + 1'b1;

	//uart must be busy after a request
	always @(*)
		if(f_minbusy != 0)
			assume(tx_busy);

	// uart should not become busy on its own 
	initial assume(!tx_busy); 
	always @(posedge i_clk)
		if($past(i_reset))
			assume(!tx_busy);
		else if (($past(tx_stb))&&(!$past(tx_busy)))
			//becomes busy with a request
			assume(tx_busy);
		else if (!$past(tx_busy))
			//stay not busy
			assume(!tx_busy);

	always @(posedge i_clk)
		if(f_past_valid)
			cover($fell(o_busy));

	always @(posedge i_clk)
		if((past_valid)&&(!$past(i_reset))
			cover($fell(o_busy));
`endif
endmodule
