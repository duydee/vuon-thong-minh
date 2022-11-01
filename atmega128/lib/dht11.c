#include "dht11.h"


#define DHT11_PIN  6

void Request()                /* Microcontroller send start pulse/request */
{
    DDRD |= (1<<DHT11_PIN);
    PORTD &= ~(1<<DHT11_PIN);    /* set to low pin */
    delay_ms(20);            /* wait for 20ms */
    PORTD |= (1<<DHT11_PIN);    /* set to high pin */
}

void Response()                /* receive response from DHT11 */
{
    DDRD &= ~(1<<DHT11_PIN);
    while(PIND & (1<<DHT11_PIN));
    while((PIND & (1<<DHT11_PIN))==0);
    while(PIND & (1<<DHT11_PIN));
}

char Receive_data()            /* receive data */
{    
    char q,c=0;
    for ( q=0; q<8; q++)
    {
        while((PIND & (1<<DHT11_PIN)) == 0);  /* check received bit 0 or 1 */
        delay_us(30);
        if(PIND & (1<<DHT11_PIN))/* if high pulse is greater than 30ms */
        c = (c<<1)|(0x01);    /* then its logic HIGH */
        else            /* otherwise its logic LOW */
        c = (c<<1);
        while(PIND & (1<<DHT11_PIN));
    }
    return c;
}


