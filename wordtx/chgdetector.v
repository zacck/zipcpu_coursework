module chgdetector(
	//forwars status in
	i_clk,
	i_data,
	o_stb,
	o_data,
	// backwards status in
	i_busy,); 

 input wire i_clk; 
 input wire [31:0] i_data; 
 input wire i_busy;

 output reg o_stb; 
 output reg [31:0] o_data; 

 initial {o_stb, o_data} = 0;

 always @(posedge i_clk) 
	 if(!i_busy) 
	 begin 
		o_stb <= 0; 
		//detect that change has occured
		if(o_data != i_data)
		begin
			// strobe out a valid change
			o_stb <= 1'b1; 
			o_data <= i_data;
		end
	end

`ifdef SIM
	reg f_past_valid; 
	initial f_past_valid = 0; 
	always @(posedge i_clk) f_past_valid <= 1'b1; 

	// if we have seen an stb and i_busy 
	// o_stb and o_data should not change
	always @(posedge i_clk)
		if((f_past_valid)
			&($past(o_stb))&&($past(i_busy)))
		assert((o_stb)&&($stable(o_data)));

	//If o_stb rises we should see i_data copied to o_data
	always @(posedge i_clk)
		if((f_past_valid) && ($rose(o_stb)))
			assert(o_data == $past(i_data));

`endif
endmodule
