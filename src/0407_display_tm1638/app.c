
#include "main.h"
#include "tm1638.h"

extern void SystemClock_Config(void);
extern void MX_USART2_UART_Init(void);
extern void MX_GPIO_Init(void);
extern void MX_SPI1_Init(void);

//----------------------------------------------------------------------

int main(void)
{
    LL_APB2_GRP1_EnableClock(LL_APB2_GRP1_PERIPH_SYSCFG);
    LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_PWR);
    NVIC_SetPriorityGrouping(NVIC_PRIORITYGROUP_4);

    SystemClock_Config();

    MX_GPIO_Init();
    MX_USART2_UART_Init();
    MX_SPI1_Init();

    LL_SPI_Enable(SPI1);
    LL_SPI_SetRxFIFOThreshold(SPI1, LL_SPI_RX_FIFO_TH_QUARTER);
    
    LL_mDelay(1);
    
    //------------------------------------------------------------------
    TM1638_Init(1);             // Display demo    
    TM1638_Set_Text("AHOJ");

    uint16_t key = 0; 
    uint16_t key_old = 0;       // zabranuje blikaniu led
  
    while (1)
    {
        key = TM1638_Get_Key();
        uDelay(1000);
        if( (key != 0) & (key != key_old) ){  
            key_old = key;  
            TM1638_Clear_Led();
            if (key & 0x08) TM1638_Led_OnOff(1, LED_ON );
            if (key & 0x04) TM1638_Led_OnOff(2, LED_ON );
            if (key & 0x02) TM1638_Led_OnOff(3, LED_ON );
            if (key & 0x01) TM1638_Led_OnOff(4, LED_ON );
            if (key & 0x80) TM1638_Led_OnOff(5, LED_ON );
            if (key & 0x40) TM1638_Led_OnOff(6, LED_ON );
            if (key & 0x20) TM1638_Led_OnOff(7, LED_ON );
            if (key & 0x10) TM1638_Led_OnOff(8, LED_ON );
            TM1638_Set_Hex8(2, key & 0xFF );
        }
    }
}
