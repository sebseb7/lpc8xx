#include "main.h"


volatile uint32_t msTicks = 0;

void SysTick_Handler(void) {
	msTicks++;
}

void delay_ms(uint32_t ms) {
	uint32_t now = msTicks;
	while ((msTicks-now) < ms);
}

int main(void) {


	SystemCoreClockUpdate();
	SysTick_Config(SystemCoreClock/1000);

}

