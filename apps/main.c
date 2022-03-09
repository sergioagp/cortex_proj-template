#include "main.h"
#include <stdlib.h>
#include <stdint.h>


#define UARTLITE_ADDR				0x40600000

#define UART_RX_FIFO_OFFSET			0	/* receive FIFO, read only */
#define UART_TX_FIFO_OFFSET			4	/* transmit FIFO, write only */
#define UART_STATUS_REG_OFFSET		8	/* status register, read only */
#define UART_CONTROL_REG_OFFSET		12	/* control reg, write only */

#define ULITE_CONTROL_TXFIFOFull_Mask	(0x1<<3)
#define TX_FIFO_FULL		0x08	/* transmit FIFO full */

#define Uart_IsTransmitFull() \
	((read32(UARTLITE_ADDR+UART_STATUS_REG_OFFSET) & TX_FIFO_FULL) == \
	  TX_FIFO_FULL)


static uint32_t read32(uintptr_t Addr)
{
	return *(volatile uint32_t *) Addr;
}

static void write32(uintptr_t Addr, uint32_t Value)
{
	volatile uint32_t *LocalAddr = (volatile uint32_t *)Addr;
	*LocalAddr = Value;

}

// SIMPLE TEST R/W TO SHARED MEMORY
void printhelloworld(void) {
	write32(UARTLITE_ADDR+UART_TX_FIFO_OFFSET, 'X');
	char str[] = "Hello World\n\r";

	for(int i=0; i<sizeof(str); i++) {
		while(Uart_IsTransmitFull());
		write32(UARTLITE_ADDR+UART_TX_FIFO_OFFSET, str[i]);
	}
}


// SIMPLE TEST R/W TO SHARED MEMORY
int main(void) {
	printhelloworld();
	while (1) {
	}
}
