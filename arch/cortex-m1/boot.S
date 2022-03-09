.syntax    unified


.section .vect_tbl, "ax"
.align 2
.globl    _vect_table
_vect_table:
    .long    __stack_top           /* Top of Stack */
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
    .long    tee_ta_initcontext_isr    
    .long    tee_ta_opensession_isr    
    .long    tee_ta_closesession_isr
    .long    tee_ta_invokecommand_isr

  .size    _vect_table, . - _vect_table



.section .text.reset_handler
.weak reset_handler
.type reset_handler, %function
reset_handler:
  ldr   r0, =__stack_top
  mov   sp, r0          /* set stack pointer */
/* Call the clock system intitialization function.*/
  //bl  SystemInit
/* Call static constructors */
  //bl __libc_init_array
/* Call the application's entry point.*/
  bl main

  //setup interrupts
loop:
    b loop    // Should not run here
.size reset_handler, .-reset_handler

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
def_irq_handler       hardfault_handler 
def_irq_handler       memmanage_handler 
def_irq_handler       busfault_handler  
def_irq_handler       usagefault_handler
def_irq_handler       svc_handler           
def_irq_handler       debugmon_handler      
def_irq_handler       pendsv_handler        
def_irq_handler       systick_handler       
/* TEE interrupts */
def_irq_handler     tee_ta_initcontext_isr
def_irq_handler     tee_ta_opensession_isr
def_irq_handler     tee_ta_closesession_isr
def_irq_handler     tee_ta_invokecommand_isr
  
  
  .end