#include "main.h"

/*
 * 	datasheet: http://www.nxp.com/documents/data_sheet/LPC81XM.pdf
 *  user manual: http://www.nxp.com/documents/user_manual/UM10601.pdf
 *  swtich matrix tool: http://www.lpcware.com/content/nxpfile/nxp-switch-matrix-tool-lpc800 (for pin configuration)
 *
 *
 *  ISP: When pin PIO0_1 is pulled LOW on reset, the part enters ISP mode and the ISP command handler starts up. 
 *       In ISP mode, pin PIO0_0 is connected to function U0_RXD and pin PIO0_4 is connected to function U0_TXD on the USART0 block.
 */


volatile uint32_t msTicks = 0;

void SysTick_Handler(void) {
	msTicks++;
}

void delay_ms(uint32_t ms) {
	uint32_t now = msTicks;
	while ((msTicks-now) < ms);
}



void main(void) {


	SystemCoreClockUpdate();
	SysTick_Config(SystemCoreClock/1000);

}

