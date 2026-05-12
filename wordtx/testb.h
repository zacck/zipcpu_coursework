#ifndef TESTB_H
#define TESTB_H

#include <stdio.h>
#include <stdint.h>
#include <verilated_vcd_c.h>

#define TBASSERT(TB, A) do {if(!(A)) { tb.closetrace(); } assert(A);} while(0);

template <class VA> class TESTB {
	public: 
		VA		*m_core;
		VerilatedVcdC 	*m_trace;
		uint64_t 	m_tickcount; 

		// Constructor
		TESTB(void)	: 	m_trace(NULL), 
					m_tickcount(0l) {
				m_core = new VA; 
				Verilated::traceEverOn(true); 
				m_core->i_clk = 0; 
				eval();
		}

		// Destructor
		virtual ~TESTB(void) {
			closetrace();
			delete m_core; 
			m_core = NULL; 
		}

		// create a trace 
		virtual void opentrace(const char *vcdname) {
			if(!m_trace) {
				m_trace = new VerilatedVcdC; 
				m_core->trace(m_trace, 99);
				m_trace->open(vcdname);
			}
		}

		// close the trace
		virtual void closetrace(void) {
			if(!m_trace) {
				m_trace->close(); 
				delete m_trace;
				m_trace = NULL;
			}
		}

		virtual void eval(void) {
			m_core->eval(); 
		}

		virtual void tick(void) {
			m_tickcount++;
			eval(); 
			if(m_trace)//dump 2ns before the tick
			       m_trace->dump(m_tickcount * 10 - 2);
			m_core->i_clk = 1; 
			eval(); 
			if(m_trace) //tick every 10ns
				m_trace->dump(m_tickcount * 10);
			m_core->i_clk = 0; 
			eval();
			if(m_trace) { //trailing edge dump 
				  m_trace->dump(m_tickcount * 10 + 5); 
				  m_trace->flush(); 
			}
		}

		unsigned long tickcount(void) {
			return m_tickcount;
		}
};
#endif
