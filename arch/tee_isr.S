# Copyright(C) 2018 Hex Five Security, Inc. - All Rights Reserved

//#include "platform.h"
//#include "common.h"

# Make sure that the GNU assembler is using a modern syntax for Arm THUMB.
.syntax unified



# -------------------------------------------------------------
.section        .data.tee_isr
# -------------------------------------------------------------

# -------------------------------------------------------------
.section        .text.tee_isr
# -------------------------------------------------------------

# -------------------------------------------------------------
.align 2 
.global         tee_ta_initcontext_isr
.type           tee_ta_initcontext_isr, %function
tee_ta_initcontext_isr:
    b        tee_ta_initcontext_isr
/* Read interrupt status to clear pending */
//check input
//load input to regs
//call c function
//ret

.global         tee_ta_opensession_isr
.type           tee_ta_opensession_isr, %function

.global         tee_ta_closesession_isr
.type           tee_ta_closesession_isr, %function

.global         tee_ta_invokecommand_isr
.type           tee_ta_invokecommand_isr, %function
