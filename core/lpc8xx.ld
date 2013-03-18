/*
 * GENERATED FILE - DO NOT EDIT
 * (C) Code Red Technologies Ltd, 2008-2013
 * Generated linker script file for LPC812
 * Created from generic_c.ld (vLPCXpresso v5.1 (2 [Build 2065] [2013-02-20] ))
 * By LPCXpresso v5.1.2 [Build 2065] [2013-02-20]  on Mon Mar 18 12:06:08 CET 2013
 */


MEMORY
{
  /* Define each memory region */
  MFlash16 (rx) : ORIGIN = 0x0, LENGTH = 0x4000 /* 16k */
  RamLoc4 (rwx) : ORIGIN = 0x10000000, LENGTH = 0x1000 /* 4k */

}
  /* Define a symbol for the top of each memory region */
  __top_MFlash16 = 0x0 + 0x4000;
  __top_RamLoc4 = 0x10000000 + 0x1000;


ENTRY(ResetISR)

SECTIONS
{

    /* MAIN TEXT SECTION */    
    .text : ALIGN(4)
    {
        FILL(0xff)
        KEEP(*(.isr_vector))
        
        /* Global Section Table */
        . = ALIGN(4) ;
        __section_table_start = .;
        __data_section_table = .;
        LONG(LOADADDR(.data));
        LONG(    ADDR(.data)) ;
        LONG(  SIZEOF(.data));
        __data_section_table_end = .;
        __bss_section_table = .;
        LONG(    ADDR(.bss));
        LONG(  SIZEOF(.bss));
        __bss_section_table_end = .;
        __section_table_end = . ;
        /* End of Global Section Table */
        

        *(.after_vectors*)
        
        /* Code Read Protect data */
        . = 0x000002FC ;
        PROVIDE(__CRP_WORD_START__ = .) ;
        KEEP(*(.crp))
        PROVIDE(__CRP_WORD_END__ = .) ;
        ASSERT(!(__CRP_WORD_START__ == __CRP_WORD_END__), "Linker CRP Enabled, but no CRP_WORD provided within application");
        /* End of Code Read Protect */
        
        *(.text*)
        *(.rodata .rodata.*)
        . = ALIGN(4);
        
    } > MFlash16

    /*
     * for exception handling/unwind - some Newlib functions (in common
     * with C++ and STDC++) use this. 
     */
    .ARM.extab : ALIGN(4)
    {
    	*(.ARM.extab* .gnu.linkonce.armextab.*)
    } > MFlash16
    __exidx_start = .;
    
    .ARM.exidx : ALIGN(4)
    {
    	*(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > MFlash16
    __exidx_end = .;
    
    _etext = .;
        
    
    /* MAIN DATA SECTION */
    
    /* Default MTB section */
    .mtb_buffer_default (NOLOAD) :
    {
       KEEP(*(.mtb*))
    } > RamLoc4 

    .uninit_RESERVED : ALIGN(4)
    {
        KEEP(*(.bss.$RESERVED*))
        . = ALIGN(4) ;
        _end_uninit_RESERVED = .;
    } > RamLoc4

    .data : ALIGN(4)
    {
        FILL(0xff)
        _data = .;
        *(vtable)
        *(.data*)
        . = ALIGN(4) ;
        _edata = .;
    } > RamLoc4 AT>MFlash16


    /* MAIN BSS SECTION */
    .bss : ALIGN(4)
    {
        _bss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4) ;
        _ebss = .;
        PROVIDE(end = .);
    } > RamLoc4
        
    
    /* DEFAULT NOINIT SECTION */
    .noinit (NOLOAD): ALIGN(4)
    {
        _noinit = .;
        *(.noinit*) 
         . = ALIGN(4) ;
        _end_noinit = .;
    } > RamLoc4
    
    PROVIDE(_pvHeapStart = .);
    PROVIDE(_vStackTop = __top_RamLoc4 - 0);
}
