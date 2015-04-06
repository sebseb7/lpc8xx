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

#define CPU_RESET_CYCLECOUNTER    do { SCB_DEMCR = SCB_DEMCR | 0x01000000;  \
	DWT_CYCCNT = 0;                      \
	DWT_CTRL = DWT_CTRL | 1 ; } while(0)


void delay_ms(uint32_t ms) {
	uint32_t now = msTicks;
	while ((msTicks-now) < ms);
}

uint32_t divu7(uint32_t n) {
	uint32_t q, r;
	q = (n >> 1) + (n >> 4); q = q + (q >> 6);
	q = q + (q>>12) + (q>>24); 
	q = q >> 2;
	r = n - q*7;
	return q + ((r + 1) >> 3); // return q + (r > 6);
}

#define LED1 9        
#define LED2 11
#define LED 7        

int main(void) {

	SysTick_Config(SystemCoreClock / 1000);


	LPC_GPIO_PORT->DIR0 |= (1<<LED1)|(1<<LED2);    // set pins as output

	while (1)
	{
		LPC_GPIO_PORT->NOT0 = 1<<LED;    // LED output high


		delay_ms(200);

		/*
		   for(uint32_t i = 0; i < 1200000; i++)
		   {
		   uint32_t a = 323243434+i;

		// 6 seconds == 60 cycles
		//uint32_t b = divu7(a);

		// 45 seconds = 450 cycles
		uint32_t b = a / 7;
		//uint32_t b = a >> 2;

		if(b>LPC_GPIO_PORT->PIN0)
		{
		LPC_GPIO_PORT->NOT0 = 1;
		}

		}
		*/

	}

}

