#include "uart_driver.h"
#include <stdint.h>


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
int uartlite_putchar(char ch)
{
	while(Uart_IsTransmitFull());
	write32(UARTLITE_ADDR+UART_TX_FIFO_OFFSET, ch);
    return 1;
}
