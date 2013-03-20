PROJECT=template

LDCRIPT=core/lpc8xx.ld

OPTIMIZATION = s

#########################################################################

SRC=$(wildcard core/*.c) $(wildcard *.c) 

OBJECTS=$(patsubst %,.bin/%,$(SRC:.c=.o))
DEPS=$(patsubst %,.bin/%,$(SRC:.c=.d))
LSTFILES=$(patsubst %,.bin/%,$(SRC:.c=.lst))

#  Compiler Options
GCFLAGS = -std=gnu99  -mcpu=cortex-m0 -mthumb -O$(OPTIMIZATION) -I. -Icore -Idrivers/inc
# Warnings
GCFLAGS += -Wno-strict-aliasing -Wstrict-prototypes -Wundef -Wall -Wextra -Wunreachable-code 
# Optimizazions
GCFLAGS +=  -fstrict-aliasing -fsingle-precision-constant -funsigned-char -funsigned-bitfields -fshort-enums -fno-builtin -ffunction-sections -fno-common -fdata-sections 
# Debug stuff
GCFLAGS += -Wa,-adhlns=.bin/$(<:.c=.lst) -g

LDFLAGS = -T$(LDCRIPT) -nostartfiles  -Wl,--gc-section 

#  Compiler/Linker Paths
GCC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
REMOVE = rm -f
SIZE = arm-none-eabi-size

#########################################################################


all: .bin .bin/core firmware.bin stats

.bin:
	mkdir .bin

.bin/core:
	mkdir .bin/core

firmware.bin: .bin/$(PROJECT).elf Makefile
	@$(OBJCOPY) -R .stack -O binary .bin/$(PROJECT).elf firmware.bin

.bin/$(PROJECT).elf: $(OBJECTS) Makefile
	@echo "  \033[1;34mLD \033[0m (\033[1;33m $(OBJECTS)\033[0m) -> $(PROJECT).elf"
	@$(GCC) -o .bin/$(PROJECT).elf $(OBJECTS) $(GCFLAGS) $(LDFLAGS) 
	@arm-none-eabi-strip -s .bin/$(PROJECT).elf

stats: .bin/$(PROJECT).elf 
	@$(SIZE) .bin/$(PROJECT).elf

clean:
	$(REMOVE) $(OBJECTS)
	$(REMOVE) $(DEPS)
	$(REMOVE) $(LSTFILES)
	$(REMOVE) firmware.bin
	$(REMOVE) .bin/$(PROJECT).elf
	-rmdir .bin/core
	-rmdir .bin

-include $(DEPS)

#########################################################################

.bin/%.o: %.c Makefile 
	@echo "  \033[1;34mGCC\033[0m $<"
	@$(GCC) $(GCFLAGS) -o $@ -c $<
	@$(GCC) $(GCFLAGS) -MM $< > $*.d.tmp
	@sed -e 's|.*:|.bin/$*.o:|' < $*.d.tmp > .bin/$*.d
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
		sed -e 's/^ *//' -e 's/$$/:/' >> .bin/$*.d
	@rm -f $*.d.tmp

#########################################################################

flash: all
	tools/isp.py
#	-/Applications/lpcxpresso_5.1.2_2065/lpcxpresso/bin/dfu-util -d 0x471:0xdf55 -c 0 -t 2048 -R -D /Applications/lpcxpresso_5.1.2_2065/lpcxpresso/bin/LPCXpressoWIN.enc
#	sleep 1
#	/Applications/lpcxpresso_5.1.2_2065/lpcxpresso/bin/crt_emu_cm3_gen -wire=winusb -pLPC812 -vendor=NXP -flash-load-exec=firmware.bin
	


.PHONY : clean all flash stats

