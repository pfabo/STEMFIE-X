#include "main.h"
#include "string.h"

#ifndef __TM1638_H
#define __TM1638_H

#define STB_GPIO_Port       GPIOA
#define STB_Pin             LL_GPIO_PIN_3
#define SPI_DEV             SPI1

typedef enum{
    LED_OFF,
    LED_ON
}LedStatus;



void TM1638_Init(uint8_t brightness);            // inicializacia  + jas displeja 1..7

// ovladanie LED
void TM1638_Led_OnOff( uint8_t led, LedStatus status );
void TM1638_Clear_Led(void);

// vystup na displej
void TM1638_Set_Number(uint8_t pos, uint8_t digit, uint8_t dot);
void TM1638_Set_NumberStr(char* num );            // textovy retazec s cislom a des. bodkou
void TM1638_Set_NumberInt(int32_t num);           // -999 9999 do 9999 9999, zarovnane doprava

void TM1638_Set_Char(uint8_t pos, char znak);     // ascii znak
void TM1638_Set_Hex(uint8_t pos, uint8_t num);    // 0x00...0x0F
void TM1638_Set_Hex8(uint8_t pos, uint8_t num);   // 0x00...0xFF
void TM1638_Set_Hex16(uint8_t pos, uint16_t num); // 0x0000...0xFFFF
void TM1638_Set_Text(char* text);                 // 8 znakov textu zarovnane zlava

void TM1638_Clear_Display(void);
void TM1638_Clear_All(void);

uint32_t TM1638_Get_Key(void);

void uDelay(uint32_t value);




#endif
