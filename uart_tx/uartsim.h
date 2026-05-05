#ifndef UARTSIM_H
#define UARTSIM_H 

#include <stdio.h>
#include <stblib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <signal.h>



#define TXIDLE 0 
#define TXDATA 1
#define RXIDLE 0 
#define RXDATA 1


class UARTSIM {
	int m_baud_counts; 


	//State
	int m_rx_baudcounter, m_rx_state, m_rx_bits,
	    m_last_tx;

	int m_tx_baudcounter, m_tx_state, m_tx_busy; 

	unsigned m_rx_data, m_tx_data;

public:
	UARTSIM(void); 

	//adjusts baudrate call before flight
	void setup(unsigned isetup); 


	//called on every tick 
	//input is the tx from the device 
	//output hooked to rx wire into the device 
	int operator()(int tx); 
};

#endif
