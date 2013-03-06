ENTRY(ResetISR)

MEMORY
{
	sram	:	ORIGIN = 0x10000000, LENGTH = 8k
	flash	:	ORIGIN = 0x00000000, LENGTH = 64k
}

_end_stack = 0x10001FF0;

SECTIONS {
	. = ORIGIN(flash);

	vectors :
	{
		*(.vectors)
	} >flash

	.text :
	{
		*(.text)
		*(.rodata)
		*(.rodata*)
		_end_text = .;
	} >flash

	.data : 
	{
		_start_data = .;
		*(.data)
		_end_data = .;
	} >sram AT >flash

	.bss :
	{
		_start_bss = .;
		*(.bss)
		_end_bss = .;
	} >sram

	. = ALIGN(4);
	
	_start_stack = .;
}

_end = .;
PROVIDE(end = .);

