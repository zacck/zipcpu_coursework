`default_nettype none
module uartport (
    i_clk,
    i_wr,
    i_data,
    o_uart_tx,
    o_busy
);

  output wire o_uart_tx;
  output reg o_busy;
  input wire i_wr;
  input wire i_clk;
  input wire [7:0] i_data;



  // States
  localparam [3:0] START_BIT = 4'h0,
          BIT_ZERO       = 4'h1,
          BIT_ONE        = 4'h2,
          BIT_TWO        = 4'h3,
          BIT_THREE      = 4'h4,
          BIT_FOUR       = 4'h5,
          BIT_FIVE       = 4'h6,
          BIT_SIX        = 4'h7,
          BIT_SEVEN      = 4'h8,
          LAST_BIT       = 4'h9,
          IDLE_BIT       = 4'ha;

  reg [8:0] lcl_data;
  reg [23:0] counter;
  reg baud_stb;
  reg [3:0] state;

  // Clock divider so we can set a baudrate
  parameter [23:0] CLOCKS_PER_BAUD = 24'd868;

  initial {o_busy, state} = {1'b0, IDLE_BIT};


  // Walk the states and outputs
  always @(posedge i_clk)
    if ((i_wr) && (!o_busy))
      // let's start writing a byte
      {o_busy, state} = {
        1'b1, START_BIT
      };
    else if (baud_stb) begin
      if (state == IDLE_BIT)
        // Stay in IDLE, but not busy
        {o_busy, state} <= {
          1'b0, IDLE_BIT
        };
      else if (state < LAST_BIT) begin
        o_busy <= 1'b1;
        state  <= state + 1'b1;
      end else
        // WAIT for IDLE
        {o_busy, state} <= {
          1'b1, IDLE_BIT
        };
    end


  // Shift register to push byte bits through the wire
  initial lcl_data = 9'h1ff;

  always @(posedge i_clk)
    if ((i_wr) && (!o_busy)) lcl_data <= {i_data, 1'b0};
    else if (baud_stb) lcl_data <= {1'b1, lcl_data[8:1]};

  assign o_uart_tx = lcl_data[0];

  initial baud_stb = 1'b1;
  initial counter = 0;
  always @(posedge i_clk)
    if ((i_wr) && (!o_busy)) begin
      counter  <= CLOCKS_PER_BAUD - 1;
      baud_stb <= 1'b0;
    end else if (!baud_stb) begin
      baud_stb <= (counter == 24'h01);
      counter  <= counter - 1'b1;
    end else if (state != IDLE_BIT) begin
      counter  <= CLOCKS_PER_BAUD - 1'b1;
      baud_stb <= 1'b0;
    end

endmodule
