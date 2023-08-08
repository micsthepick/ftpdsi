#include <dsiwifi7.h>
#include <nds.h>


void doVBlank(void)
{
	Wifi_Update();
	resyncClock();
}

int main()
{
	readUserSettings();
	irqInit();
	initClockIRQ();
	fifoInit();

	SetYtrigger(80);

	installSoundFIFO();
	installSystemFIFO();

	installWifiFIFO();

	irqSet(IRQ_VBLANK, doVBlank);

	irqEnable( IRQ_VBLANK | IRQ_NETWORK);

	while(1)
	{
		swiWaitForVBlank();
	}
	return 0;
}
