#include <stdio.h>
#include <stdlib.h>
#include "Vledwalkersm.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

//clock toggler for our simulation
void tick(int tickcount, Vledwalkersm *tb, VerilatedVcdC *tfp) {
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
	Vledwalkersm *tb = new Vledwalkersm;

	// trace generation
	unsigned tickcount = 0;
	Verilated::traceEverOn(true);
	VerilatedVcdC *tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("ledwalkersmtrace.vcd");

	int last_led = tb->o_led; 
	for(int k=0; k <(1<<20); k++) {
		tick(++tickcount, tb, tfp);
		if (last_led != tb->o_led) {
			printf("k = %7d ", k);
			printf("led = %d\n", tb->o_led);
		} 
		last_led = tb->o_led;
	}
}




