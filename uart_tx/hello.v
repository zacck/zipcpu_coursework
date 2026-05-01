module hello(
	i_clk
);

txuart #(CLOCKS_PER_BAUD) mytxuart(.i_clk(i_clk),
	.i_wr(tx_st), 
	.i_data(tx_data), 
	.o_busy(tx_busy), 
	.o_uart_tx(o_uart));

reg [3:0] tx_index;
reg [7:0] tx_data;
reg [27:0] hz_counter; 

initial hz_counter = 28'h16;

always @(posedge i_clk)
	if(hz_counter == 0)
		hz_counter <= CLOCK_RATE_HZ - 1'b1;
	else 
		hz_counter < hz_counter - 1'b1;

//restart every second 
initial tx_restart = 0;

always @(posedge i_clk)
	tx_restart <= (hz_counter == 1);
always @(posegde i_clk)
	case(tx_index)
		4'h0: tx_data <= "H";
		4'h1: tx_data <= "e"; 
		4'h2: tx_data <= "l"; 
		4'h3: tx_data <= "l";
		4'h4: tx_data <= "o";
		4'h5: tx_data <= ",";
		4'h6: tx_data <= " ";
		4'h7: tx_data <= "W";
		4'h8: tx_data <= "o"; 
		4'h9: tx_data <= "r"; 
		4'ha: tx_data <= "l";
		4'hb: tx_data <= "d";
		4'hc: tx_data <= "!"; 
		4'hd: tx_data <= " ";
		4'he: tx_data <= "\r";
		4'hf: tx_data <= "\n";
	endcase

always @(posedge i_clk)
	if((tx_stb) && (!tx_busy))
		tx_index <= tx_index + 1'b1; 

always @(posedge i_clk)
	if(tx_restart)
		tx_stb <= 1'b1; 
	else if((tx_stb) && (!tx_busy) && tx_index == 4'hf))
		tx_stb <= 1'b0;
endmodule
