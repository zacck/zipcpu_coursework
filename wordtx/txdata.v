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
	input wire [32:0] i_data;
	output wire o_uart_tx;
	output wire o_busy;

	reg [3:0] state; 
	reg tx_stb; 
	wire tx_busy;
	initial tx_stb = 1'b0;
	initial state = 4'h0;

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

	reg [32:0] my_data_copy;
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


	uartport #(UART_SETUP[23:0]) 
		txdatauart(i_clk, tx_stb, tx_data, o_uart_tx, tx_busy);
endmodule
