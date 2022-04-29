#ifndef UART_DRIVER_H
#define UART_DRIVER_H

#include <stdint.h>

#define UARTLITE_ADDR				0x40600000

#define UART_RX_FIFO_OFFSET			0	/* receive FIFO, read only */
#define UART_TX_FIFO_OFFSET			4	/* transmit FIFO, write only */
#define UART_STATUS_REG_OFFSET		8	/* status register, read only */
#define UART_CONTROL_REG_OFFSET		12	/* control reg, write only */

#define ULITE_CONTROL_TXFIFOFull_Mask	(0x1<<3)
#define TX_FIFO_FULL		0x08	/* transmit FIFO full */

// SIMPLE TEST R/W TO SHARED MEMORY
int uartlite_putchar(char);

inline int __io_putchar(int ch) {
    return uartlite_putchar(ch);
}

#endif /*UART_DRIVER_H*/