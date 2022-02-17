/* STACK CFG -----------------------------------------------------------------*/
__STACK_SIZE =      0x00000400;
__HEAP_SIZE  =      0x00000C00; /* TODO: heap need for kernel?! */
/*----------------------------------------------------------------------------*/

/* */
MEMORY
{
  FLASH (rx) 	 : ORIGIN = 0x00000000, LENGTH = 0x080000   /*  256k */
  RAM (rwx)  	 : ORIGIN = 0x20000000, LENGTH = 0x001000   /* 4k */
  TEE_ARGS (rwx) : ORIGIN = 0x44A00000, LENGTH = 0x000080   /* 128 */
}

ENTRY(reset_handler)

SECTIONS
{
    .text :
    {
        KEEP(*(.vect_tbl))
        _vect_table_end = .;
        _vect_table_size = _vect_table_end - _vect_table;
        __end__ = .;

        *(.text*);
        *(.RODATA*);
    } > FLASH

    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > FLASH
    .ARM.exidx :
    {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > FLASH

    __etext = .;

    .data :
    {
        . = ALIGN(4);
        __data_start__ = .;

        *(.data*)

        . = ALIGN(4);
        __data_end__ = .;

    } > RAM AT > FLASH

    .bss (NOLOAD):
    {
        . = ALIGN(4);
        __bss_start__ = .;

        *(.bss*)
        *(COMMON)

        . = ALIGN(4);
        __bss_end__ = .;
    } > RAM

    bss_size = __bss_end__ - __bss_start__;

    .stack (ORIGIN(RAM) + LENGTH(RAM) - __STACK_SIZE) (COPY) :
    {
        . = ALIGN(8);
        __Stack_Lim = .;
        . = . + __STACK_SIZE;
        . = ALIGN(8);
        __stack_top = .;
    } > RAM
}