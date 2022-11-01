#ifndef _PORT_INCLUDED_
#define _PORT_INCLUDED_

#include "../main.h"


#define ON 1
#define OFF 0

//Den dong bo
#define denDongBo PORTD.4

//BUTTON
#define btnLEFT PINF.0
#define btnRIGHT PINF.1
#define btnUP PINF.2
#define btnDOWN PINF.3
#define btnGO PINF.4
#define btnMENU PINF.5
#define btnHOME PINF.6

//base address
#define Base_address 0x1100

//CS
#define CS0 0   // relay
#define CS1 1   // den
#define CS2 2   // quat
#define CS3 3   // bom
#define CS4 4   // sensor
#define CS5 5   // nut bam
#define CS9 9   //lcd
#define CS10 10  //lcd

//uart
#define sensors  0
#define statusTB 1
#define hengioOns  2
#define hengioOffs 3
#define deleteHengio 4
#define getalldataStatusTB 5
#define getalldataHengioTB 6
#define autoDen 7
#define autoQuat 8
#define autoBom 9

//dia chi sram 
#define Relay *(unsigned char *) (Base_address + CS0)
#define Den   *(unsigned char *) (Base_address + CS1)
#define Quat  *(unsigned char *) (Base_address + CS2)
#define Bom   *(unsigned char *) (Base_address + CS3)
#define Sensor   *(unsigned char *) (Base_address + CS4)

#define Relay_Activation (*(volatile unsigned char *) (Base_address + CS0) = *(unsigned char *) (&Relays) ) 
#define Den_Activation   (*(volatile unsigned char *) (Base_address + CS1) = *(unsigned char *) (&Dens) )
#define Quat_Activation  (*(volatile unsigned char *) (Base_address + CS2) = *(unsigned char *) (&Quats) )
#define Bom_Activation   (*(volatile unsigned char *) (Base_address + CS3) = *(unsigned char *) (&Boms) )
#define Sensor_Activation (*(volatile unsigned char *) (Base_address + CS4) = *(unsigned char *) (&Sensors) )
//#define READKEY          (*(unsigned char *)(&Buttons) = *(volatile unsigned char *)(Base_address + CS5))


#endif