#include "lcd20x4.h"

//LCD
#define LCDE_H (PORTG |= (1<<3)) 
#define LCDE_L (PORTG &= ~(1<<3)) 

#define LCD_DATA *(unsigned char *) (Base_address + CS9)
#define LCD_INS *(unsigned char *) (Base_address + CS10)

void LcdInit()
{
    LCD_INS = 0x38; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
    delay_us(200);
    LCD_INS = 0x0C; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
    delay_us(200); 
    LCD_INS = 0x06; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
    delay_us(200); 
    //LCD_INS = 0x01; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
    //delay_us(200);
}

void PrintFlash(flash char *str, unsigned char row , unsigned char col)
{
    unsigned char add;
    switch(row)
    {
        case 0: add = 0x80; break; 
        case 1: add = 0xC0; break;
        case 2: add = 0x94; break;
        case 3: add = 0xD4; break;
    }
    LCD_INS = add + col; 
    LCDE_H; delay_us(1); LCDE_L; delay_us(100);
    while(*(str) != '\0')
    {
        LCD_DATA = *str++; 
        LCDE_H; delay_us(1); LCDE_L; delay_us(100);
    }
}

void Print( char *str, unsigned char row , unsigned char col)
{
    unsigned char add;
    switch(row)
    {
        case 0: add = 0x80; break; 
        case 1: add = 0xC0; break;
        case 2: add = 0x94; break;
        case 3: add = 0xD4; break;
    }
    LCD_INS = add + col; 
    LCDE_H; delay_us(1); LCDE_L; delay_us(100);
    while(*(str) != '\0')
    {
        LCD_DATA = *str++; 
        LCDE_H; delay_us(1); LCDE_L; delay_us(100);
    }
}
