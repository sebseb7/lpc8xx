PROJECT=template

LDCRIPT=core/lpc8xx.ld

OPTIMIZATION = 1

#########################################################################

SRC=$(wildcard core/*.c) $(wildcard *.c)


OBJECTS= $(SRC:.c=.o) 
LSSFILES= $(SRC:.c=.lst) 
HEADERS=$(wildcard core/*.h) $(wildcard *.h)

#  Compiler Options
GCFLAGS = -std=gnu99 -ffreestanding -mcpu=cortex-m0 -mthumb -O$(OPTIMIZATION) -I. -Icore 
# Warnings
GCFLAGS += -Wno-strict-aliasing -Wstrict-prototypes -Wundef -Wall -Wextra -Wunreachable-code 
# Optimizazions
GCFLAGS +=  -fstrict-aliasing -fsingle-precision-constant -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -fno-builtin -ffunction-sections -fno-common -fdata-sections
# Debug stuff
#GCFLAGS += -Wa,-adhlns=$(<:.c=.lst),-gstabs -g 

LDFLAGS =  -mcpu=cortex-m0 -mthumb -O$(OPTIMIZATION) -nostartfiles  -T$(LDCRIPT) 


#  Compiler/Linker Paths
GCC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
REMOVE = rm -f
SIZE = arm-none-eabi-size

#########################################################################

all: firmware.bin Makefile stats


firmware.bin: $(PROJECT).elf Makefile
	$(OBJCOPY) -R .stack -O binary $(PROJECT).elf firmware.bin

$(PROJECT).elf: $(OBJECTS) Makefile
	@echo "  \033[1;34mLD \033[0m (\033[1;33m $(OBJECTS)\033[0m) -> $(PROJECT).elf"
	@$(GCC) $(LDFLAGS) $(OBJECTS) -o $(PROJECT).elf -lm
	arm-none-eabi-strip -s $(PROJECT).elf

stats: $(PROJECT).elf Makefile
	$(SIZE) $(PROJECT).elf

clean:
	$(REMOVE) $(OBJECTS)
	$(REMOVE) $(LSSFILES)
	$(REMOVE) firmware.bin
	$(REMOVE) $(PROJECT).elf
	$(REMOVE) $(PROJECT).map

#########################################################################

%.o: %.c Makefile $(HEADERS)
	@echo "  \033[1;34mGCC\033[0m $<"
	@$(GCC) $(GCFLAGS) -o $@ -c $<

#########################################################################



.PHONY : clean all 

