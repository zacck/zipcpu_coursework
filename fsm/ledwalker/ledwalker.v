module ledwalker (
    i_clk,
    o_led
);
  output reg [8:0] o_led;
  input wire i_clk;

  reg [31:0] counter;
  reg stb;

  initial {stb, counter} = 0;
  initial o_led = 9'b000000001;

  parameter integer CLK_RATE_HZ = 12_000_000;

  always @(posedge i_clk)
    if (counter == 0) counter <= CLK_RATE_HZ - 1;
    else counter <= counter - 1'b1;

  always @(posedge i_clk) begin
    stb <= 1'b0;
    if (counter == 0) stb <= 1'b1;
  end

  always @(posedge i_clk) if (stb) o_led <= {o_led[7:0], o_led[8]};

endmodule
