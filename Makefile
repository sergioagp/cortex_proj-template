PROJECT = ta_memtest

BIN_FOLDER = bin/

LD_SCRIPT := arch/cortex-m1/linker.ld

#############################################################
# Toolchain definitions
#############################################################

CROSS_COMPILE := arm-none-eabi-
CC			:=	$(CROSS_COMPILE)gcc
LD			:=	$(CROSS_COMPILE)ld
OBJDUMP		:=	$(CROSS_COMPILE)objdump
OBJCOPY		:=	$(CROSS_COMPILE)objcopy
READELF		:=	$(CROSS_COMPILE)readelf
GDB			:=	$(CROSS_COMPILE)gdb
SIZE		:=	$(CROSS_COMPILE)size
SSTRIP		:=	$(CROSS_COMPILE)strip

#############################################################
# Objects declaration
#############################################################
INCLUDES 	+= -I.
INCLUDES	+= -Itee
INCLUDES 	+= -Itee/include


ASM_SRCS 	+= arch/cortex-m1/boot.S
ASM_SRCS 	+= arch/tee_isr.S

#C_SRCS	 	+= tee/tee_isr.c
C_SRCS	 	+= apps/main.c

ASM_OBJS	:= $(ASM_SRCS:.S=.o)
C_OBJS		:= $(C_SRCS:.c=.o)
OBJECTS		:= $(ASM_OBJS) $(C_OBJS)

PROJECT_OBJS := $(PROJECT).elf 
PROJECT_OBJS += $(PROJECT).hex
PROJECT_OBJS += $(PROJECT).bin
PROJECT_OBJS += $(PROJECT).lst
PROJECT_OBJS += $(PROJECT).coe

#############################################################
# Flags definitions
#############################################################

MCUFLAGS	+= -march=armv6-m
MCUFLAGS	+= -mcpu=cortex-m1

LDFLAGS		+= -T $(LD_SCRIPT)
LDFLAGS 	+= -static $(MCUFLAGS)
LDFLAGS		+= -mthumb
LDFLAGS 	+= -nostartfiles
LDFLAGS 	+= -Xlinker --gc-sections


CFLAGS		+= -g
CFLAGS		+= -ffunction-sections -fdata-sections -fomit-frame-pointer
CFLAGS		+= $(MCUFLAGS)
CFLAGS		+= $(INCLUDES)
CFLAGS		+= -O0

# default rule: build all
.PHONY: all clean run debug
all: $(PROJECT_OBJS)

clean:
	rm -rf $(BIN_FOLDER) $(PROJECT_OBJS) $(OBJECTS)

run: $(PROJECT).elf
	qemu-arm -cpu cortex-m0 $<

debug: $(PROJECT).elf
	qemu-arm -cpu cortex-m0 -g 1234 $<


# wildcard rules
%.o: %.S Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

$(PROJECT).elf: $(OBJECTS) $(LINK_DEPS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

%.hex: %.elf
	$(OBJCOPY) -O ihex $< $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.lst: %.elf
	$(OBJDUMP) --all-headers --demangle --disassemble --file-headers --wide -D $< > $@

%.coe: %.bin
	python3 tools/bintocoe.py $< $@ 