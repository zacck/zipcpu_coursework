`include "uartport.v"

`default_nettype none
module hello (
`ifdef SIM
    o_setup,
`endif
    i_clk,
    uart_tx
);

  parameter CLOCK_HZ_RATE = 12_000_000;  // 12MHZ clock 
  parameter BAUD_RATE = 115_200;
  input i_clk;
  output uart_tx;

  parameter INITIAL_UART_SETUP = (CLOCK_HZ_RATE / BAUD_RATE);

`ifdef SIM
  output wire [31:0] o_setup;
  assign o_setup = INITIAL_UART_SETUP;
`endif

  // Once a second restart
  reg tx_restart;
  reg [27:0] hz_counter;

  initial hz_counter = 28'h16;
  always @(posedge i_clk)
    if (hz_counter == 0) hz_counter <= CLOCK_HZ_RATE - 1'b1;
    else hz_counter <= hz_counter - 1'b1;

  initial tx_restart = 0;
  always @(posedge i_clk) tx_restart <= (hz_counter == 1);


  // Do tx
  wire tx_busy;
  reg tx_stb;
  reg [3:0] tx_index;
  reg [7:0] tx_data;

  initial tx_index = 4'h0;
  always @(posedge i_clk) if ((tx_stb) && (!tx_busy)) tx_index <= tx_index + 1'b1;


  always @(posedge i_clk)
    case (tx_index)
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
      4'he: tx_data <= "\n";
      4'hf: tx_data <= "\r";
      default: tx_data <= ".";
    endcase

  //send char request
  initial tx_stb = 1'b0;

  always @(posedge i_clk)
    if (&tx_restart) tx_stb <= 1'b1;
    else if ((tx_stb) && (!tx_busy) && (tx_index == 4'hf)) tx_stb <= 1'b0;

  uartport #(INITIAL_UART_SETUP[23:0]) uartport (
      .i_clk(i_clk),
      .i_wr(tx_stb),
      .i_data(tx_data),
      .o_uart_tx(uart_tx),
      .o_busy(tx_busy)
  );


`ifdef SIM
  reg f_past_valid;
  initial f_past_valid = 1'b0;

  always @(posedge i_clk) f_past_valid <= 1'b1;

  always @(*)
    if ((tx_stb) && (!tx_busy)) begin
      case (tx_index)
        4'h0: assert (tx_data <= "H");
        4'h1: assert (tx_data <= "e");
        4'h2: assert (tx_data <= "l");
        4'h3: assert (tx_data <= "l");
        //
        4'h4: assert (tx_data <= "o");
        4'h5: assert (tx_data <= ",");
        4'h6: assert (tx_data <= " ");
        4'h7: assert (tx_data <= "W");
        //
        4'h8: assert (tx_data <= "o");
        4'h9: assert (tx_data <= "r");
        4'ha: assert (tx_data <= "l");
        4'hb: assert (tx_data <= "d");
        //
        4'hc: assert (tx_data <= "!");
        4'hd: assert (tx_data <= " ");
        4'he: assert (tx_data <= "\n");
        4'hf: assert (tx_data <= "\r");
        //
      endcase
    end

  always @(posedge i_clk)
    if ((f_past_valid) && ($changed(tx_index)))
      assert (($past(tx_stb) && (!$past(tx_busy))));
      else if (f_past_valid) assert (($stable(tx_index)) && ((!$past(tx_stb)) || ($past(tx_busy))));

  always @(posedge i_clk) if (tx_index != 4'h0) assert (tx_stb);

`endif
endmodule
