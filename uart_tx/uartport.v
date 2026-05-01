`default_nettype none
module uartport(
	i_clk,
	i_wr, 
	i_data, 
	o_uart_tx, 
	o_busy
);

output reg o_uart_tx;
output reg o_busy;
input wire i_wr;
input wire i_clk; 
input wire [7:0]i_data;

reg [3:0] state;
reg [8:0] lcl_data;
reg [31:0] counter;
reg baud_stb;


parameter integer IDLE = 15; 
parameter integer START = 0;
parameter integer LAST = 14;

initial {o_busy, state} = {1'b0, IDLE};

// Clock divider so we can set a baudrate
parameter integer CLOCK_PER_BAUD 12_000_000;

initial counter = 0;
always @(posedge i_clk)
	if((i_wr)&&(!o_busy))
		counter <= CLOCK_PER_BAUD - 1;
	else if(counter > 0)
		counter <= counter - 1;
	else if(state != IDLE)
		counter <= CLOCK_PER_BAUD - 1;

assign baud_stb = (counter == 0);


always @(posedge i_clk)
	if((i_wr) && (!o_busy))
		// Start a new byte
		{o_busy, state} <= {1'b1, START}; 
	else if (baud_stb)
		// We just finished a byte
		{o_busy, state} <= {1'b0, IDLE};
	else if (baud_stb)
	begin 
		o_busy <= 1'b1; 
		state <= state + 1;
	end else
		{o_busy, state} <= {1'b1, IDLE};

// SHIFT register for out put
initial lcl_data = 9'h1ff;

always @(posedge i_clk)
	if((i_wr) &&(!o_busy))
		//Load the  register and start with 0
	        lcl_data <= { i_data, 1'b0 }; 
	else if(baud_stb)
		//shift 1'b1 in from the left so whole moves right for more data
		lcl_data <=  {1'b1, lcl_data[8:1]};

assign o_uart_tx = lcl_data [0];


endmodule
