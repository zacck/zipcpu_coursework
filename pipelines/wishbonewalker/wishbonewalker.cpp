#include <stdio.h>
#include <stdlib.h>
#include "Vwishbonewalker.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

//clock toggler for our simulation
void tick(int tickcount, Vwishbonewalker *tb, VerilatedVcdC *tfp) {
	tb->eval(); 
	if(tfp)//dump 2ns before the tick
	       tfp->dump(tickcount * 10 - 2);
	tb->i_clk = 1; 
	tb->eval(); 
	if(tfp) //tick every 10ns
		tfp->dump(tickcount * 10);
	tb->i_clk = 0; 
	tb->eval();
	if(tfp) { //trailing edge dump 
		  tfp->dump(tickcount * 10 + 5); 
		  tfp->flush(); 
	}
}



int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv); 
	Vwishbonewalker *tb = new Vwishbonewalker;

	// trace generation
	unsigned tickcount = 0;
	Verilated::traceEverOn(true);
	VerilatedVcdC *tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("wishbonewalkertrace.vcd");

	int last_led = tb->o_data;
	tb->i_we = 1;
	tb->i_stb = 1;
	tb->i_cyc = 1;
	for(int k=0; k <(1<<10); k++) {
		tick(++tickcount, tb, tfp);
		if (last_led != tb->o_data) {
			printf("k = %7d ", k);
			printf("i_we = %d ", tb->i_we);
			printf("o_stall  = %d ", tb->o_stall);
			printf("data = %d\n", tb->o_data);
		} 
		last_led = tb->o_data;
	}
}




