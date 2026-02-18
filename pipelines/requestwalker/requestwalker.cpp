#include <stdio.h>
#include <stdlib.h>
#include "Vrequestwalker.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

//clock toggler for our simulation
void tick(int tickcount, Vrequestwalker *tb, VerilatedVcdC *tfp) {
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
	Vrequestwalker *tb = new Vrequestwalker;

	// trace generation
	unsigned tickcount = 0;
	Verilated::traceEverOn(true);
	VerilatedVcdC *tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("requestwalkertrace.vcd");

	int last_led = tb->o_led;
	tb->i_request = 1;
	for(int k=0; k <(1<<10); k++) {
		tick(++tickcount, tb, tfp);
		if (last_led != tb->o_led) {
			printf("k = %7d ", k);
			printf("i_req = %d ", tb->i_request);
			printf("o_busy  = %d ", tb->o_busy);
			printf("led = %d\n", tb->o_led);
		} 
		last_led = tb->o_led;
	}
}




