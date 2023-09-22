#include "tm1638.h"

/*
uint8_t num_mas[] = { 
        0x3F, // 0
        0x06, // 1
        0x5B, // 2
        0x4F, // 3
        0x66, // 4
        0x6D, // 5
        0x7D, // 6
        0x07, // 7
        0x7F, // 8
        0x6F, // 9
        0x80, // dot
        0x40  // -
};
*/

const uint8_t font_hex[] = {
  0b00111111, // 0
  0b00000110, // 1
  0b01011011, // 2
  0b01001111, // 3
  0b01100110, // 4
  0b01101101, // 5
  0b01111101, // 6
  0b00000111, // 7
  0b01111111, // 8
  0b01101111, // 9
  0b01110111, // A
  0b01111100, // B
  0b00111001, // C
  0b01011110, // D
  0b01111001, // E
  0b01110001  // F
};

// definition for the displayable ASCII chars
const uint8_t font_ascii[] = {
  0b00000000, // (32)  <space>
  0b10000110, // (33)	!
  0b00100010, // (34)	"
  0b01111110, // (35)	#
  0b01101101, // (36)	$
  0b00000000, // (37)	%
  0b00000000, // (38)	&
  0b00000010, // (39)	'
  0b00110000, // (40)	(
  0b00000110, // (41)	)
  0b01100011, // (42)	*
  0b00000000, // (43)	+
  0b00000100, // (44)	,
  0b01000000, // (45)	-
  0b10000000, // (46)	.
  0b01010010, // (47)	/
  0b00111111, // (48)	0
  0b00000110, // (49)	1
  0b01011011, // (50)	2
  0b01001111, // (51)	3
  0b01100110, // (52)	4
  0b01101101, // (53)	5
  0b01111101, // (54)	6
  0b00100111, // (55)	7
  0b01111111, // (56)	8
  0b01101111, // (57)	9
  0b00000000, // (58)	:
  0b00000000, // (59)	;
  0b00000000, // (60)	<
  0b01001000, // (61)	=
  0b00000000, // (62)	>
  0b01010011, // (63)	?
  0b01011111, // (64)	@
  0b01110111, // (65)	A
  0b01111111, // (66)	B
  0b00111001, // (67)	C
  0b00111111, // (68)	D
  0b01111001, // (69)	E
  0b01110001, // (70)	F
  0b00111101, // (71)	G
  0b01110110, // (72)	H
  0b00000110, // (73)	I
  0b00011111, // (74)	J
  0b01101001, // (75)	K
  0b00111000, // (76)	L
  0b00010101, // (77)	M
  0b00110111, // (78)	N
  0b00111111, // (79)	O
  0b01110011, // (80)	P
  0b01100111, // (81)	Q
  0b00110001, // (82)	R
  0b01101101, // (83)	S
  0b01111000, // (84)	T
  0b00111110, // (85)	U
  0b00101010, // (86)	V
  0b00011101, // (87)	W
  0b01110110, // (88)	X
  0b01101110, // (89)	Y
  0b01011011, // (90)	Z
  0b00111001, // (91)	[
  0b01100100, // (92)	\ (this can't be the last char on a line, even in comment or it'll concat)
  0b00001111, // (93)	]
  0b00000000, // (94)	^
  0b00001000, // (95)	_
  0b00100000, // (96)	`
  0b01011111, // (97)	a
  0b01111100, // (98)	b
  0b01011000, // (99)	c
  0b01011110, // (100)	d
  0b01111011, // (101)	e
  0b00110001, // (102)	f
  0b01101111, // (103)	g
  0b01110100, // (104)	h
  0b00000100, // (105)	i
  0b00001110, // (106)	j
  0b01110101, // (107)	k
  0b00110000, // (108)	l
  0b01010101, // (109)	m
  0b01010100, // (110)	n
  0b01011100, // (111)	o
  0b01110011, // (112)	p
  0b01100111, // (113)	q
  0b01010000, // (114)	r
  0b01101101, // (115)	s
  0b01111000, // (116)	t
  0b00011100, // (117)	u
  0b00101010, // (118)	v
  0b00011101, // (119)	w
  0b01110110, // (120)	x
  0b01101110, // (121)	y
  0b01000111, // (122)	z
  0b01000110, // (123)	{
  0b00000110, // (124)	|
  0b01110000, // (125)	}
  0b00000001, // (126)	~
};


void uDelay(uint32_t value){
    for(uint32_t i=0; i<value; i++){
        asm("nop");
    } 
}


__INLINE static void TM1638_Select(void){
    LL_GPIO_ResetOutputPin (STB_GPIO_Port, STB_Pin);
    uDelay(1000);
}


__INLINE static void TM1638_Unselect(void){
    LL_GPIO_SetOutputPin (STB_GPIO_Port, STB_Pin);
    uDelay(1000);
}


void TM1638_Init(uint8_t brightness) 
{    
    if( brightness > 7 ) brightness = 7;
    brightness = 0x80 | 0x08 | brightness ; // nastavenie jasu displeja

    TM1638_Select();

    LL_SPI_TransmitData8(SPI_DEV, brightness);
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    TM1638_Unselect();
    TM1638_Clear_All();
}


void TM1638_Led_OnOff( uint8_t led, LedStatus status ){
    
    if( led == 0 || led > 8 ) led = 1;
    
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, 0x44);
    while (SPI_DEV->SR & SPI_SR_BSY){};

    TM1638_Unselect();
    
    uint8_t addr = 0xC1 + (led - 1) *2;    // adresa LED diod

    TM1638_Select();
    
    LL_SPI_TransmitData8(SPI_DEV, addr);
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    LL_SPI_TransmitData8(SPI_DEV, (uint8_t)status); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    TM1638_Unselect();
}


void TM1638_Clear_Led(void){
    
    for(uint8_t i=1; i<9; i++){
        TM1638_Led_OnOff(i, LED_OFF);
    }
}


void TM1638_Clear_Display(void){
        
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, 0x44); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    TM1638_Unselect();
    
    for( uint8_t i = 0; i < 8; i++){
        uint8_t buf = 0xC0 + i*2;
        
        TM1638_Select();

        LL_SPI_TransmitData8 (SPI_DEV, buf); 
        while (SPI_DEV->SR & SPI_SR_BSY){};
        
        LL_SPI_TransmitData8 (SPI_DEV, 0); 
        while (SPI_DEV->SR & SPI_SR_BSY){};
        
        TM1638_Unselect();
    }
}


void TM1638_Clear_All(void){
    
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, 0x40); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    TM1638_Unselect();
        
    TM1638_Select();
    
    LL_SPI_TransmitData8(SPI_DEV, 0xC0); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    for( uint8_t i = 0; i< 16; i++){            
        LL_SPI_TransmitData8 (SPI_DEV, 0); 
        while (SPI_DEV->SR & SPI_SR_BSY){};    
    }
    
    TM1638_Unselect();
}


void TM1638_Set_Number(uint8_t pos, uint8_t digit, uint8_t dot){
    
    if( pos == 0 || pos > 8 ) pos = 1;
    if( digit > 11 ) digit = 11;
    
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, 0x44); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    TM1638_Unselect();
        
    uint8_t buf = 0xC0 + (8 - pos) * 2;
        
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, buf); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    if( dot ){  
        buf = font_ascii[digit + 16] | 0x80;
    }
    else{
        buf = font_ascii[digit+16];
    }
     LL_SPI_TransmitData8 (SPI_DEV, buf); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
        
    TM1638_Unselect();
}


void TM1638_Set_Char(uint8_t pos, char znak){
    
    if( pos == 0 || pos > 8 ) pos = 1;
    
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, 0x44); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    TM1638_Unselect();
        
    uint8_t buf = 0xC0 + (8 - pos) * 2;
        
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, buf); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    

        buf = font_ascii[znak-32]; // | 0x80;
  
     LL_SPI_TransmitData8 (SPI_DEV, buf); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
        
    TM1638_Unselect();
}


void TM1638_Set_Hex(uint8_t pos, uint8_t num){
    
    if( pos == 0 || pos > 8 ) pos = 1;
    
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, 0x44); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    TM1638_Unselect();
        
    uint8_t buf = 0xC0 + (8 - pos) * 2;
        
    TM1638_Select();
    
    LL_SPI_TransmitData8 (SPI_DEV, buf); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
    
    buf = font_hex[num & 0x0F]; // | 0x80;
  
    LL_SPI_TransmitData8 (SPI_DEV, buf); 
    while (SPI_DEV->SR & SPI_SR_BSY){};
        
    TM1638_Unselect();
}


void TM1638_Set_Hex8(uint8_t pos, uint8_t num){
    
    TM1638_Set_Hex(pos, (num & 0xF0) >> 4);
    TM1638_Set_Hex(pos-1, (num & 0x0F) );
}


void TM1638_Set_Hex16(uint8_t pos, uint16_t num){
    TM1638_Set_Hex8(pos, (num & 0xFF00) >> 8);
    TM1638_Set_Hex8(pos-2, (num & 0x00FF) );
}




void TM1638_Set_Text(char* text){
    uint8_t len = strlen(text);
    
    if(len > 8) len=8;
    
    for(uint8_t i=0; i<len; i++){
        TM1638_Set_Char(8-i, text[i]);
    }
}


uint8_t SPI_Read_HD_Byte(void){
    // privatna pomocna funkcia
    // nacitanie dat z SPI v mode Half Duplex
    // meni smer zbernice
    
    uint8_t data = 0;
    
    LL_SPI_Disable(SPI_DEV);    // zmena smeru zbernice - data vysiela slave
    LL_SPI_SetTransferDirection(SPI_DEV, LL_SPI_HALF_DUPLEX_RX);
    LL_SPI_Enable(SPI_DEV);
    
    // cakanie na nacitanie plneho buffra, sirka urcena v inicializacii
    while(!LL_SPI_IsActiveFlag_RXNE(SPI1));
    
    data = LL_SPI_ReceiveData8(SPI1); 
    
    LL_SPI_Disable(SPI1);       // zbernicu prebera MASTER
    LL_SPI_SetTransferDirection(SPI1, LL_SPI_HALF_DUPLEX_TX);
    LL_SPI_Enable(SPI1);
    return data;
}


uint8_t SPI_Read_FD_Byte(void){
    // privatna pomocna funkcia
    // nacitanie dat z SPI v mode Full Duplex
    // pre TM1638 je potrebne spojit MISO a MOSI
    uint8_t data = 0;
    
    while(!LL_SPI_IsActiveFlag_TXE(SPI_DEV));
    LL_SPI_TransmitData8(SPI_DEV,0xFF);

    while(!LL_SPI_IsActiveFlag_RXNE(SPI_DEV));
    data = LL_SPI_ReceiveData8(SPI_DEV);

    while(LL_SPI_IsActiveFlag_BSY(SPI_DEV));
    return data;
}


uint32_t TM1638_Get_Key(void){
    /*
    Kody tlacitok
        S1 -  1           0000 0000 0000 0000 0000 0000 0000 0001
        S2 -  256         0000 0000 0000 0000 0000 0001 0000 0000
        S3 -  65536       0000 0000 0000 0001 0000 0000 0000 0000
        S4 -  16777216    0000 0001 0000 0000 0000 0000 0000 0000
        S5 -  16          0000 0000 0000 0000 0000 0000 0001 0000
        S6 -  4096        0000 0000 0000 0000 0001 0000 0000 0000
        S7 -  1048576     0000 0000 0001 0000 0000 0000 0000 0000
        S8 -  268435456   0001 0000 0000 0000 0000 0000 0000 0000
    */
    
    uint32_t key=0;
    
    TM1638_Select();
        
    while(!LL_SPI_IsActiveFlag_TXE(SPI1)){}
    LL_SPI_TransmitData8 (SPI1, 0x42);          // povel citanie
    while(LL_SPI_IsActiveFlag_BSY(SPI1)){}
    
    uDelay(50);
    
    //------------------------------------------------------------------
    // Nacitanie odpovede v mode HALF DUPLEX
    //------------------------------------------------------------------
    key =        SPI_Read_HD_Byte() << 24 ;
    key = key + (SPI_Read_HD_Byte() << 16);
    key = key + (SPI_Read_HD_Byte() <<  8);
    key = key +  SPI_Read_HD_Byte()       ;
    
    TM1638_Unselect();
    
    uint32_t ret = 0; 
    
    ret = ret | (  key         & 0x00000001 );
    ret = ret | ( (key >> 7  ) & 0x00000002 );
    ret = ret | ( (key >> 14 ) & 0x00000004 );
    ret = ret | ( (key >> 21 ) & 0x00000008 );
    ret = ret | ( (key >> 0  ) & 0x00000010 );
    ret = ret | ( (key >> 7  ) & 0x00000020 );
    ret = ret | ( (key >> 14 ) & 0x00000040 );
    ret = ret | ( (key >> 21 ) & 0x00000080 );
    return ret;
}


/*
 *  -999 9999 do 9999 9999 
 */
void TM1638_Set_NumberInt(int32_t num){

    
    uint8_t position = 1;
    
    if( num == 0 ) TM1638_Set_Number( 1, 0, 0 );
    else 
        if( ((num < 0) && (num / 10000000)) || ((num > 0) && (num / 100000000)) ){
        
        TM1638_Set_Number( 0x01, 11, 0 );
        TM1638_Set_Number( 0x02, 11, 0 );
        TM1638_Set_Number( 0x03, 11, 0 );
        TM1638_Set_Number( 0x04, 11, 0 );
        TM1638_Set_Number( 0x05, 11, 0 );
        TM1638_Set_Number( 0x06, 11, 0 );
        TM1638_Set_Number( 0x07, 11, 0 );
        TM1638_Set_Number( 0x08, 11, 0 );
        
    }
    else{
        uint8_t minus = 0;
        if( num < 0 ){
            minus = 1;
            num = num * -1;
        }
        while( num ){

            TM1638_Set_Number( position, num % 10, 0 );
            num = num / 10;
            position++;
            
            if( position > 8 ) { break; }
        }
        if( minus ){
            TM1638_Set_Number( position, 11, 0 );
        }
    }
    
}

void TM1638_Set_NumberStr(char* num ){
    
    uint8_t len = strlen( num );
    uint8_t dot = 0;
    
    while( len ){
        if( num[len -1 ] == '.' ){
            dot++;
        }
        len--;
    }
    
    if( strlen( num ) - dot > 8 ){
        TM1638_Set_Number( 0x01, 11, 0 );
        TM1638_Set_Number( 0x02, 11, 0 );
        TM1638_Set_Number( 0x03, 11, 0 );
        TM1638_Set_Number( 0x04, 11, 0 );
        TM1638_Set_Number( 0x05, 11, 0 );
        TM1638_Set_Number( 0x06, 11, 0 );
        TM1638_Set_Number( 0x07, 11, 0 );
        TM1638_Set_Number( 0x08, 11, 0 );
        
        len = 0;
    }
    else{
        len = strlen( num );
    }
    
    uint8_t position = 1;
    dot = 0;
    
    while( len ){
        
        if(num[len-1] == '-'){
            TM1638_Set_Number( position, 11, dot );   
            dot = 0;
            position++;
        }
        else if(num[len-1] == '.'){
            dot = 1;
        }
        else if(num[len-1] == ' '){
            position++;
        }
        else{
            TM1638_Set_Number( position, num[len-1]-48, dot );    
            dot = 0;
            position++;
        }
        
        len--;
        
        if( position > 8 ) { 
            break; 
        }
    }
}

