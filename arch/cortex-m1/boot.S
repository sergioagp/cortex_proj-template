.syntax    unified

.extern _estack


/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss



.section .isr_vector,"a",%progbits
.type _vect_table, %object
.size _vect_table, .-_vect_table
.globl    _vect_table

_vect_table:
    .long    _estack                    /* Top of Stack */
    .long    reset_handler         /* Reset Handler */
    .long    nmi_handler           /* NMI Handler */
    .long    hardfault_handler     /* Hard Fault Handler */
    .long    memmanage_handler     /* MPU Fault Handler */
    .long    busfault_handler      /* Bus Fault Handler */
    .long    usagefault_handler    /* Usage Fault Handler */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    svc_handler           /* SVCall Handler */
    .long    debugmon_handler      /* Debug Monitor Handler */
    .long    0                     /* Reserved */
    .long    pendsv_handler        /* PendSV Handler */
    .long    systick_handler       /* SysTick Handler */

    /* TEE interrupts */
    .long    tee_interrupt_handler  
    .long    0  /* Reserved */
    .long    0  /* Reserved */
    .long    0  /* Reserved */

  .size    _vect_table, . - _vect_table

.section .text.reset_handler
.weak reset_handler
.type reset_handler, %function
reset_handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit
  
/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call the clock system intitialization function.*/
  bl  SystemInit
/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever

.size reset_handler, .-reset_handler


.section .text.hardfault_handler
.weak hardfault_handler
.type hardfault_handler, %function
hardfault_handler:
	movs	r0, #4
	mov		r1, lr
	tst		r0, r1
	beq		stacking_used_MSP
	mrs 	r0, psp				// first parameter - stacking was using PSP
	b		get_LR_and_branch
stacking_used_MSP:
	mrs 	r0, msp				// first parameter - stacking was using MSP
get_LR_and_branch:
	bx		lr

.pool
.size hardfault_handler, .-hardfault_handler

/*  Macro to define default handlers. */
.macro    def_irq_handler    handler_name
.align    1
.thumb_func
.weak    \handler_name
\handler_name:
  b        \handler_name
.endm

/* Core exceptions */
def_irq_handler       nmi_handler       
//def_irq_handler       hardfault_handler 
def_irq_handler       memmanage_handler 
def_irq_handler       busfault_handler  
def_irq_handler       usagefault_handler
def_irq_handler       svc_handler           
def_irq_handler       debugmon_handler      
def_irq_handler       pendsv_handler        
def_irq_handler       systick_handler       
/* TEE interrupts */
def_irq_handler     tee_interrupt_handler

  .end