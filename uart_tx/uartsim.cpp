#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <poll.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <signal.h>
#include <ctype.h>

#include "uartsim.h"

UARTSIM::UARTSIM(void) {
	setup(25); 
	m_rx_baudcounter = 0; 
	m_tx_baudcounter = 0; 
	m_rx_state = RXIDLE;
	m_tx_state = TXIDLE; 
}


void UARTSIM::setup(unsigned isetup) {
	m_baud_counts = (isetup & 0x0ffffff); 
}

int UARTSIM::operator()(const int i_tx) {
	if(m_rx_state == RXIDLE) {
		//find start bit
		if(!i_tx) {
			m_rx_state = RXDATA; 
			//wait a baud and a half
			m_rx_baudcounter = m_baud_counts + m_baud_counts/2-1;

			m_rx_bits = 0; 
			m_rx_data = 0; 
		} 
	} else if(m_rx_baudcounter <= 0) {
			if(m_rx_bits >= 8) {
				// Last data bit 
				m_rx_state = RXIDLE; 
				putchar(m_rx_data); 
				fflush(stdout); 
			} else {
				m_rx_bits++; 
				m_rx_data = ((i_tx & 1) ? 0x80 : 0 
						| (m_rx_data >> 1); 
			} // restart the baud counter 
			m_rx_baudcounter = m_baud_counts - 1; 
		} else  
			m_rx_baudcounter--; 
}

			


