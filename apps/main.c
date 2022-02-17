#include "main.h"
#include <stdlib.h>
#include <stdint.h>


uint32_t *invokecmd_args_ptr = (uint32_t *) 0x44A00000;
int boot(void) {

	*invokecmd_args_ptr=0xDEADDEAD;
	*(invokecmd_args_ptr+0x0) = 0xBEEFBEEF;
	*(invokecmd_args_ptr+0x08) = 0xDEADDEAD;
	*(invokecmd_args_ptr+0x0C) = 0xBEEFBEEF;

	while (1) {
	}
}

// SIMPLE TEST R/W TO SHARED MEMORY
int main(void) {
	*invokecmd_args_ptr=0xDEADDEAD;
	*(invokecmd_args_ptr+0x0) = 0xBEEFBEEF;
	*(invokecmd_args_ptr+0x08) = 0xDEADDEAD;
	*(invokecmd_args_ptr+0x0C) = 0xBEEFBEEF;
	boot();

	while (1) {
	}
}
