#include  <Vhello.h>
#include "uartsim.h"
#include "testb.h"

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv); 
	TESTB<Vhello> *tb = new TESTB<Vhello>;
	UARTSIM *uart = new UARTSIM();

	unsigned baudclocks; 
	baudclocks = tb->m_core->o_setup; 
	uart->setup(baudclocks); 

	tb->opentrace("hello.vcd"); 

	for (int clocks = 0; clocks < 16 * 32 * baudclocks; clocks++) {
		tb-> tick();
		(*uart)(tb->m_core->uart_tx); 
	}

	printf("\n\nSimulation complete\n");
}
