#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE 250
unsigned char rx_buffer[RX_BUFFER_SIZE];

unsigned char index=0;
unsigned char flag_uart=0;

unsigned char id, trangthai, gioon, phuton, giooff, phutoff;
//unsigned char flagUARTstatus=0;

extern unsigned char arrStatuTB[25];
extern char arrGioOn[30] ,arrPhutOn[30] ;
extern char arrGioOff[30], arrPhutOff[30];
extern unsigned char flagAutoDen, flagAutoQuat ,flagAutoBom;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{ 
    char data;
    data=UDR0; 
    if(data == '\n')
    {   
        flag_uart=1;
        index=0; 
    }
    else
    {    
        rx_buffer[index]=data; 
        index++;
    }    
}

void uart_handler()
{
    
    if(flag_uart)
    {  
       id = (rx_buffer[1]-0x30)*10 + rx_buffer[2]-0x30; 
       
       switch(rx_buffer[0])
       {
            case 'S':
                trangthai = rx_buffer[3]-0x30;
                //arrStatuTB[id] = trangthai;
                //flagUARTstatus = 1;  
                if(id == 20)
                {
                    denDongBo = 1;  
                    TIMSK |=(1 << TOIE1); //bat timer1
                }
                switch(id)
                { 
                    case Device_Temp:
                        arrStatuTB[Device_Temp] = trangthai;
                        Sensors.thietbi.TB0 = trangthai;
                        Sensor_Activation;
                        break; 
                    case Device_Humi:        
                        arrStatuTB[Device_Humi]=trangthai;
                        Sensors.thietbi.TB1 = trangthai;
                        Sensor_Activation;
                        break;
                    case Device_DoAmDat:         
                        arrStatuTB[Device_DoAmDat]=trangthai;       
                        Sensors.thietbi.TB2 = trangthai;
                        Sensor_Activation;
                        break;
                    case Device_Mua:
                        arrStatuTB[Device_Mua]=trangthai;                      
                        Sensors.thietbi.TB3 = trangthai;
                        Sensor_Activation;
                        break;
                    case Device_Den_Khu1:
                        arrStatuTB[Device_Den_Khu1]=trangthai;
                        Dens.thietbi.TB0 = trangthai;
                        Den_Activation;
                        break;
                    case Device_Den_Khu2:
                        arrStatuTB[Device_Den_Khu2]=trangthai;
                        Dens.thietbi.TB1 = trangthai;
                        Den_Activation;
                        break;
                    case Device_Den_Khu3:            
                        arrStatuTB[Device_Den_Khu3]=trangthai;
                        Dens.thietbi.TB2 = trangthai;
                        Den_Activation;
                        break;
                    case Device_Quat_Khu1:
                        arrStatuTB[Device_Quat_Khu1]=trangthai;
                        Quats.thietbi.TB0 = trangthai;
                        Quat_Activation;
                        break;
                    case Device_Quat_Khu2:
                        arrStatuTB[Device_Quat_Khu2]=trangthai;
                        Quats.thietbi.TB1 = trangthai;
                        Quat_Activation;
                        break;                        
                    case Device_Quat_Khu3:            
                        arrStatuTB[Device_Quat_Khu3]=trangthai;
                        Quats.thietbi.TB2 = trangthai; 
                        Quat_Activation;
                        break;
                    case Device_Bom_Khu1:             
                        arrStatuTB[Device_Bom_Khu1]=trangthai;
                        Boms.thietbi.TB0 = trangthai;
                        Bom_Activation;
                        break;
                    case Device_Bom_Khu2:
                        arrStatuTB[Device_Bom_Khu2]=trangthai;
                        Boms.thietbi.TB1 = trangthai; 
                        Bom_Activation;
                        break;
                    case Device_Bom_Khu3:            
                        arrStatuTB[Device_Bom_Khu3]=trangthai;
                        Boms.thietbi.TB2 = trangthai;
                        Bom_Activation;
                        break;
                    case Device_Relay1:
                        arrStatuTB[Device_Relay1]=trangthai;
                        Relays.thietbi.TB0 = trangthai;
                        Relay_Activation;
                        break;
                    case Device_Relay2: 
                        arrStatuTB[Device_Relay2]=trangthai;
                        Relays.thietbi.TB1 = trangthai;
                        Relay_Activation;
                        break;
                    case Device_Relay3:   
                        arrStatuTB[Device_Relay3]=trangthai;
                        Relays.thietbi.TB2 = trangthai;
                        Relay_Activation;
                        break;
                    case Device_Relay4:                
                        arrStatuTB[Device_Relay4]=trangthai;
                        Relays.thietbi.TB3 = trangthai;
                        Relay_Activation;
                        break;
                    case Device_Relay5:                
                        arrStatuTB[Device_Relay5]=trangthai;
                        Relays.thietbi.TB4 = trangthai;
                        Relay_Activation;
                        break;
                    case Device_Relay6:                
                        arrStatuTB[Device_Relay6]=trangthai;
                        Relays.thietbi.TB5 = trangthai;
                        Relay_Activation;
                        break;
                    case Device_Relay7:                
                        arrStatuTB[Device_Relay7]=trangthai;
                        Relays.thietbi.TB6 = trangthai;
                        Relay_Activation;
                        break;
                    case Device_Relay8:                
                        arrStatuTB[Device_Relay8]=trangthai;
                        Relays.thietbi.TB7 = trangthai;
                        Relay_Activation;
                        break;    
                } 
                
                break;
            case 'N': 
                gioon = (rx_buffer[3]-0x30)*10 + rx_buffer[4]-0x30;
                phuton = (rx_buffer[5]-0x30)*10 + rx_buffer[6]-0x30; 
                arrGioOn[id]=gioon;
                arrPhutOn[id]=phuton;
                break;
            case 'F':
                if(id == 26)
                {
                    denDongBo = 1;   
                    TIMSK |=(1 << TOIE1); //bat timer1
                }
                giooff = (rx_buffer[3]-0x30)*10 + rx_buffer[4]-0x30;
                phutoff = (rx_buffer[5]-0x30)*10 + rx_buffer[6]-0x30; 
                arrGioOff[id]=giooff;
                arrPhutOff[id]=phutoff;
                break;
            case 'D': 
                arrGioOn[id]=70;
                arrPhutOn[id]=70;
                arrGioOff[id]=70;
                arrPhutOff[id]=70;
                break;            
            case 'A':   // auto den
                trangthai = rx_buffer[1]-0x30;
                arrStatuTB[Device_Den_Khu1] = trangthai;
                arrStatuTB[Device_Den_Khu2] = trangthai;  
                arrStatuTB[Device_Den_Khu3] = trangthai;    
                flagAutoDen = arrStatuTB[Auto_Den] = trangthai;
                break;
            case 'B':   // auto quat
                trangthai = rx_buffer[1]-0x30;
                arrStatuTB[Device_Quat_Khu1] = trangthai;
                arrStatuTB[Device_Quat_Khu2] = trangthai;  
                arrStatuTB[Device_Quat_Khu3] = trangthai;  
                flagAutoQuat = arrStatuTB[Auto_Quat] = trangthai;
                break;
            case 'C':  // auto bom
                trangthai = rx_buffer[1]-0x30;
                arrStatuTB[Device_Bom_Khu1] = trangthai;
                arrStatuTB[Device_Bom_Khu2] = trangthai;  
                arrStatuTB[Device_Bom_Khu3] = trangthai;   
                flagAutoBom = arrStatuTB[Auto_Bom] = rx_buffer[1]-0x30;      
                break; 
       }
       
       flag_uart=0;
    }   
}


// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 64
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0=0,tx_rd_index0=0;
#else
unsigned int tx_wr_index0=0,tx_rd_index0=0;
#endif

#if TX_BUFFER_SIZE0 < 256
unsigned char tx_counter0=0;
#else
unsigned int tx_counter0=0;
#endif

// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
    if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
    #if TX_BUFFER_SIZE0 != 256
       if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
    #endif  
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
    while (tx_counter0 == TX_BUFFER_SIZE0);
    #asm("cli")
    if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
       {
       tx_buffer0[tx_wr_index0++]=c;
    #if TX_BUFFER_SIZE0 != 256
       if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
    #endif
       ++tx_counter0;
       }
    else
       UDR0=c;
    #asm("sei")
}
#pragma used-

#endif