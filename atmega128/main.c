#include "main.h"
#include "./lib/port.h"
#include "./lib/userdef.h"
#include "./lib/menu.h"
#include "./lib/lcd20x4.h"
#include "./lib/dht11.h"
#include "./lib/uart0.h"
#include "./lib/myadc.h"

unsigned char s,h,m; // Bien cho ham thoi gian
unsigned char thu,d,n,y; // Bien cho ham ngay thang nam
char display_buffer[20];

char I_RH,D_RH,I_Temp,D_Temp,CheckSum;  //DO AM VA NHIET DO
int doam=0; //do am dung hien thi
unsigned char temperature;  // nhiet do lm35
char DoAmDat=55;               // do am dat
char CamBienMua=1;            // cam bien mua

//flag Auto
unsigned char flagAutoDen=0 ,flagAutoQuat=0 ,flagAutoBom=0;

//arr hen gio
unsigned char arrStatuTB[25];
char arrGioOn[30] , arrGioOff[30];
char arrPhutOn[30], arrPhutOff[30];
char arrFlagHenGio[30];


//dinh nghia lai ham
void setup();
void MenuDisplay(flash struct Menu *,unsigned char);
void screenMainDisplay();
//void setTime();
void getTime();
void NhietdoVadoam();
void valueinitSensor();
void setValuesInitHengio();
void HenGio();

int timeSensor=0;   //0.99s

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 value
    TCNT1H=0xB3B5 >> 8;
    TCNT1L=0xB3B5 & 0xff;

    ++timeSensor;
    if(timeSensor==20)  //20s
    {
        NhietdoVadoam();   
        timeSensor=0;
    }    
}

void main(void)
{
     unsigned char select=1 , flagMenu=0 ;
     flash struct Menu *menu;

     setup();
         
     LcdInit();
         
     s=0; m=38; h=10;
     thu=3; n=11; d=1; y=22;
      
     setValuesInitHengio(); 
     valueinitSensor();
     //setTime();
     
     //printf( "{\"type\":%d}\r\n" , getalldataStatusTB);
     //printf( "{\"type\":%d}\r\n" , getalldataHengioTB); 
     
    while (1)
    {    
         getTime();
         screenMainDisplay();     
         uart_handler();     
         HenGio();
                
         //auto thiet bi
         if(flagAutoDen==1)
         {
            if(h >= 18 | CamBienMua==1)  // neu lon hon 6 gio toi va troi mua thi den bat
            {   
                if(Dens.thietbiall != 0xFF)
                {   
                    Dens.thietbiall=0xFF;
                    Den_Activation;
                }    
            }
            else
            {
                if(Dens.thietbiall != 0x00)
                {
                    Dens.thietbiall=0x00;
                    Den_Activation;
                } 
            }
         }   
         if(flagAutoQuat==1)
         {
            if(temperature >= 32)  // neu nhiet do lon hon 32 C thi quat bat
            {   
                if(Quats.thietbiall != 0xFF)
                {
                    Quats.thietbiall = 0xFF;
                    Quat_Activation; 
                }
            }
            else
            {
                if(Quats.thietbiall != 0x00)
                {
                    Quats.thietbiall = 0x00;
                    Quat_Activation; 
                }
            }
         }
         if(flagAutoBom==1)
         {
            if( DoAmDat <= 20)  // neu nho hon 20% thi bom bat
            {   
                if(Boms.thietbiall != 0xFF)
                {
                    Boms.thietbiall = 0xFF;
                    Bom_Activation;
                }
            }
            else
            {
                if(Boms.thietbiall != 0x00)
                {
                    Boms.thietbiall = 0x00;
                    Bom_Activation;
                }
            }
         }             
         
         //menu  
         if(btnMENU == 0)
         {
            flagMenu=1;  
            menu = &MainMenu;
            MenuDisplay(menu,select);            
                    
            while(flagMenu == 1)
            {  
                 uart_handler();  
                 if(btnHOME == 0)
                 {
                    flagMenu=0;                      
                    while(btnHOME == 0);
                 }
                         
                 if(btnUP == 0 )
                 {   
                   select = (select==1)?3:select-1;
                   MenuDisplay(menu,select);
                           
                   while(btnUP == 0); 
                 }  

                 if(btnDOWN == 0 )
                 {
                   select = (select==3)?1:select+1;
                   MenuDisplay(menu,select);
                   while(btnDOWN == 0); 
                 } 
                         
                 if(btnRIGHT == 0 )
                 {     
                   switch(select)
                   {
                        case 1: 
                            menu=(menu->Menulist1 == NULL)?menu:menu->Menulist1;
                            break;
                        case 2:
                            menu=(menu->Menulist2 == NULL)?menu:menu->Menulist2;
                            break;
                        case 3:
                            menu=(menu->Menulist3 == NULL)?menu:menu->Menulist3;
                            break;    
                   }  
                   MenuDisplay(menu,select);
                   while(btnRIGHT == 0);
                 }   

                 if(btnLEFT == 0 )
                 {
                   menu=(menu->pre == NULL)?menu:menu->pre;
                   MenuDisplay(menu,select);
                   while (btnLEFT == 0);
                 } 

                 if(btnGO == 0)
                 {                    
                   unsigned char flagHengio=0, flagsetTime=0; //flagsetTime = 0 set gio , flagsetTime = 1 set phut
                   switch(select)
                   {
                        case 1:  
                            if(menu->ActivationON != NULL)
                            {  
                                menu->ActivationON(menu->menuID,ON);
                                arrStatuTB[menu->menuID]=1;
                            }
                            else if(menu->ActivationSet)
                            {   
                                while(btnGO == 0);
                                flagHengio = 1;
                                while(flagHengio == 1 ) // vao mode hen gio
                                {  
                                    while(flagsetTime == 0)  // set Gio on
                                    {
                                        if(btnUP == 0 )
                                        {   
                                            delay_ms(150);
                                            arrGioOn[menu->menuID]++;
                                            if(arrGioOn[menu->menuID] > 23)
                                            {
                                                arrGioOn[menu->menuID]=0; 
                                            }                                    
                                        } 
                                        if(btnDOWN == 0 )
                                        {   
                                            delay_ms(150);
                                            arrGioOn[menu->menuID]--;    
                                            if(arrGioOn[menu->menuID] <= 0)
                                            {
                                                arrGioOn[menu->menuID]=23;
                                            }                            
                                        }
                                        if(btnRIGHT == 0)
                                        {                        
                                            flagsetTime=1;
                                            while(btnRIGHT == 0); //quay lai ve set phut on
                                        }
                                        if(btnGO == 0)
                                        {   
                                            flagHengio=0;
                                            flagsetTime=-1;
                                            while(btnGO == 0);
                                        }
                                        MenuDisplay(menu,select); 
                                    }
                                    while(flagsetTime == 1)  // set  Phut  on
                                    {
                                        if(btnUP == 0 )
                                        {   
                                            delay_ms(150);
                                            arrPhutOn[menu->menuID]++;
                                            if(arrPhutOn[menu->menuID] > 59)
                                            {
                                                arrPhutOn[menu->menuID]=0; 
                                            }                                  
                                        } 
                                        if(btnDOWN == 0 )
                                        {   
                                            delay_ms(150);
                                            arrPhutOn[menu->menuID]--;    
                                            if(arrPhutOn[menu->menuID] <= 0)
                                            {
                                                arrPhutOn[menu->menuID]=59;
                                            }                          
                                        }
                                        if(btnLEFT == 0)
                                        {                        
                                            flagsetTime=0;  //quay lai ve set gio on
                                            while(btnLEFT == 0); 
                                        }
                                        if(btnGO == 0)
                                        {   
                                            flagHengio=0;
                                            flagsetTime=-1;
                                            while(btnGO == 0);
                                        }
                                        MenuDisplay(menu,select);
                                    }
                                    printf("{\"type\":%d,\"id\":%d,\"gio\":%d,\"phut\":%d}\r\n",hengioOns,menu->menuID,arrGioOn[menu->menuID],arrPhutOn[menu->menuID]);  
                                }
                            } 
                            break;
                        case 2:
                            if(menu->ActivationOFF != NULL) 
                            {
                                menu->ActivationOFF(menu->menuID,OFF);
                                arrStatuTB[menu->menuID]=0;
                            }
                            else if(menu->ActivationSet)
                            {   
                                while(btnGO == 0);
                                flagHengio = 1;
                                while(flagHengio == 1 )
                                {
                                    while(flagsetTime == 0)  // set Gio off
                                    {
                                        if(btnUP == 0 )
                                        {   
                                            delay_ms(150);
                                            arrGioOff[menu->menuID]++;
                                            if(arrGioOff[menu->menuID] > 23)
                                            {
                                                arrGioOff[menu->menuID]=0; 
                                            }                                    
                                        } 
                                        if(btnDOWN == 0 )
                                        {   
                                            delay_ms(150);
                                            arrGioOff[menu->menuID]--;    
                                            if(arrGioOff[menu->menuID] <= 0)
                                            {
                                                arrGioOff[menu->menuID]=23;
                                            }                            
                                        }
                                        if(btnRIGHT == 0)
                                        {                        
                                            flagsetTime=1;
                                            while(btnRIGHT == 0); //quay lai ve set phut  off
                                        }
                                        if(btnGO == 0)
                                        {   
                                            flagHengio=0;
                                            flagsetTime=-1;
                                            while(btnGO == 0);
                                        }
                                        MenuDisplay(menu,select); 
                                    }
                                    while(flagsetTime == 1)  // set  Phut   off
                                    {
                                        if(btnUP == 0 )
                                        {   
                                            delay_ms(150);
                                            arrPhutOff[menu->menuID]++;
                                            if(arrPhutOff[menu->menuID] > 59)
                                            {
                                                arrPhutOff[menu->menuID]=0; 
                                            }                                  
                                        } 
                                        if(btnDOWN == 0 )
                                        {   
                                            delay_ms(150);
                                            arrPhutOff[menu->menuID]--;    
                                            if(arrPhutOff[menu->menuID] <= 0)
                                            {
                                                arrPhutOff[menu->menuID]=59;
                                            }                          
                                        }
                                        if(btnLEFT == 0)
                                        {                        
                                            flagsetTime=0;  //quay lai ve set gio off
                                            while(btnLEFT == 0); 
                                        }
                                        if(btnGO == 0)
                                        {   
                                            flagHengio=0;
                                            flagsetTime=-1;
                                            while(btnGO == 0);
                                        }
                                        MenuDisplay(menu,select);
                                    }
                                    printf("{\"type\":%d,\"id\":%d,\"gio\":%d,\"phut\":%d}\r\n",hengioOffs,menu->menuID,arrGioOff[menu->menuID],arrPhutOff[menu->menuID]);  
                                }
                            }
                            break;
                        case 3:
                            if(menu->ActivationSet != NULL)
                            {
                                setValuesInitHengio();
                                printf("{\"type\":%d,\"id\":%d}\r\n",deleteHengio,menu->menuID);
                            }
                   }  
                           
                   MenuDisplay(menu,select);
                   while(btnGO == 0);
                 } 
            }          
            while(btnMENU == 0);
         }
         delay_ms(1000);
    }  
}

void valueinitSensor()
{
    //gia tri ban dau
     arrStatuTB[Device_Temp]=1;
     arrStatuTB[Device_Humi]=1;
     arrStatuTB[Device_DoAmDat]=1;
     arrStatuTB[Device_Mua]=1;
     
     Sensors.thietbi.TB0=1;
     Sensors.thietbi.TB1=1; 
     Sensors.thietbi.TB2=1;
     Sensors.thietbi.TB3=1;
     Sensor_Activation;
}

//void setTime()
//{ 
//    rtc_set_time(h,m,s);
//    rtc_set_date(thu,d,n,y);     
//}

void getTime()
{
    rtc_get_time(&h,&m,&s);
    rtc_get_date(&thu,&d,&n,&y);   
}

void MenuDisplay(flash struct Menu *menu,unsigned char select){
    
    PrintFlash(menu->Title,0,0);
    
    if( menu->ActivationSet != NULL && menu->Menulist3 == NULL && menu->ActivationON == NULL && menu->ActivationOFF == NULL )
    {
        sprintf(display_buffer," ON  H:%d, M:%d    ",arrGioOn[menu->menuID],arrPhutOn[menu->menuID]);
        Print(display_buffer,1,0); 
        sprintf(display_buffer," OFF H:%d, M:%d    ",arrGioOff[menu->menuID],arrPhutOff[menu->menuID]);
        Print(display_buffer,2,0);        
    } 
    else
    {
        PrintFlash(menu->List1,1,0);
        PrintFlash(menu->List2,2,0); 
    }
    
    if(menu->Menulist1 == NULL && menu->Menulist2 == NULL && menu->Menulist3 == NULL && menu->ActivationSet == NULL  )
    {   
        if(arrStatuTB[menu->menuID]==0)
        {                            
           Print("  Trang Thai: OFF  ",3,0); 
        }
        else
        {
           Print("  Trang Thai: ON   ",3,0); 
        }
    }    
    else
    {
        PrintFlash(menu->List3,3,0);
    }
    
    PrintFlash(">",select,0);   
} 

void screenMainDisplay()
{
    sprintf(display_buffer,"  Time: %2d:%02d:%02d   ",h,m,s);
    Print(display_buffer,0,0);
    sprintf(display_buffer," Thu %d,%2d/%02d/%d   ",thu,n,d,2000+y);
    Print(display_buffer,1,0);  
    //NhietdoVadoam();
    //kiem tra loi
//    if( (I_RH + D_RH + I_Temp + D_Temp) != CheckSum )
//    {     
//    }     
//    else
//    {      
//       sprintf(display_buffer," T: %d%d.0 C  H: %d.%d ",temperature/10,temperature%10,doam,D_RH);
//       Print(display_buffer,2,0);
//    }     
    sprintf(display_buffer," T: %d%d.0 C  H: %d.%d ",temperature/10,temperature%10,doam,D_RH);
    Print(display_buffer,2,0);
    if(CamBienMua==0)
    {  
        sprintf(display_buffer," DAD:%d ,KHONG MUA ",DoAmDat);
        Print(display_buffer,3,0);
    }
    else
    {   
        sprintf(display_buffer," DAD:%d , MUA      ",DoAmDat);
        Print(display_buffer,3,0);
    }  
}           

void NhietdoVadoam()
{
    //gui xung start
    Request();
    //doi xung phan hoi
    Response();    
    //doc 40bits data tu cam bien              
    I_RH = Receive_data();    
    D_RH = Receive_data();    
    I_Temp = Receive_data();    
    D_Temp = Receive_data();              
    CheckSum = Receive_data();
    temperature = read_adc(7);    
    
    doam =(int)I_RH;  //do am hien thi tren lcd 
    printf("{\"type\":%d,\"temp\":%d,\"humi\":%d,\"dad\":%d,\"cbmua\":%d}\r\n",sensors,temperature,I_RH,DoAmDat,CamBienMua);    
}  
                 

void setValuesInitHengio()
{
    unsigned char j;
   //set gia tri ban dau cho hen gio
    for(j=0;j <= 26;j++)
    {
        arrGioOn[j]=70;
        arrPhutOn[j]=70;
        arrGioOff[j]=70;
        arrPhutOff[j]=70; 
        arrFlagHenGio[j]=0;    
    } 
}

void checkHengioDen(unsigned char tb, unsigned char gioOn, unsigned char phutOn, unsigned char gioOff, unsigned char phutOff , unsigned char flagStatus, unsigned char id)
{
    if(h == gioOn && m == phutOn && flagStatus == 0)
    {        
            if(tb == 0) 
            {
               //arrStatuTB[Device_Den_Khu1] = 1;
               Dens.thietbi.TB0 = 1;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu1 , ON );    
            }
            else if(tb == 1)
            {
               //arrStatuTB[Device_Den_Khu2] = 1;
               Dens.thietbi.TB1 = 1; 
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu2 , ON ); 
            }   
            else if(tb == 2)
            {
               //arrStatuTB[Device_Den_Khu3] = 1;
               Dens.thietbi.TB2 = 1; 
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu3 , ON ); 
            }
                       
            Den_Activation;
            arrFlagHenGio[id] = 1;
    }
    if(h == gioOff && m == phutOff && flagStatus == 1)
    {   
            if(tb == 0) 
            {
               //arrStatuTB[Device_Den_Khu1] = 1;
               Dens.thietbi.TB0 = 0;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu1 , OFF );  
            }
            else if(tb == 1)
            {
               //arrStatuTB[Device_Den_Khu2] = 1;
               Dens.thietbi.TB1 =0;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu2 , OFF );    
            }   
            else if(tb == 2)
            {
               //arrStatuTB[Device_Den_Khu3] = 1;
               Dens.thietbi.TB2 = 0;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu3 , OFF );  
            }              
            Den_Activation; 
            arrFlagHenGio[id] = 0; 
    }
}
void checkHengioQuat(unsigned char tb, unsigned char gioOn, unsigned char phutOn, unsigned char gioOff, unsigned char phutOff,unsigned char flagStatus, unsigned char id)
{
    if(h == gioOn && m == phutOn && flagStatus == 0)
    {
            if(tb == 0) 
            {
               //arrStatuTB[Device_Quat_Khu1] = 1; 
               Quats.thietbi.TB0 =1;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu1 , ON ); 
            }
            else if(tb == 1)
            {
               //arrStatuTB[Device_Quat_Khu2] = 1;
                Quats.thietbi.TB1 =1;
                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu2 , ON );  
            }   
            else if(tb == 2)
            {
               //arrStatuTB[Device_Quat_Khu3] = 1;
                Quats.thietbi.TB2 =1; 
                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu3 , ON ); 
            }  
            Quat_Activation;
            arrFlagHenGio[id] = 1;
    }
    if(h == gioOff && m == phutOff && flagStatus == 1)
    {   
            if(tb == 0) 
            {
               //arrStatuTB[Device_Quat_Khu1] = 0;
               Quats.thietbi.TB0 =0;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu1 , OFF ); 
            }
            else if(tb == 1)
            {
               //arrStatuTB[Device_Quat_Khu2] = 0;
               Quats.thietbi.TB1 =0; 
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu2 , OFF ); 
            }   
            else if(tb == 2)
            {
               //arrStatuTB[Device_Quat_Khu3] = 0;
               Quats.thietbi.TB2 =0;  
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu3 , OFF );
            }  
            Quat_Activation;
            arrFlagHenGio[id] = 0;      
    }
    
}
void checkHengioBom(unsigned char tb, unsigned char gioOn, unsigned char phutOn, unsigned char gioOff, unsigned char phutOff,unsigned char flagStatus, unsigned char id)
{
    if(h == gioOn && m == phutOn && flagStatus == 0)
    {
            if(tb == 0) 
            {
               //arrStatuTB[Device_Bom_Khu1] = 1;
               Boms.thietbi.TB0 = 1 ;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu1 , ON );
            }
            else if(tb == 1)
            {
               //arrStatuTB[Device_Bom_Khu2] = 1; 
               Boms.thietbi.TB1 = 1;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu2 , ON ); 
            }   
            else if(tb == 2)
            {
               //arrStatuTB[Device_Bom_Khu3] = 1;
               Boms.thietbi.TB2 = 1;
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu3 , ON );  
            }  
            Bom_Activation;
            arrFlagHenGio[id] = 1;
    }
    if(h == gioOff && m == phutOff && flagStatus == 1)
    {   
            if(tb == 0) 
            {
               //arrStatuTB[Device_Bom_Khu1] = 0; 
                Boms.thietbi.TB0 = 0;
                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu1 , OFF );  
            }
            else if(tb == 1)
            {
               //arrStatuTB[Device_Bom_Khu2] = 0;
               Boms.thietbi.TB1 = 0; 
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu2 , OFF );   
            }   
            else if(tb == 2)
            {
               //arrStatuTB[Device_Bom_Khu3] = 0;
               Boms.thietbi.TB2 = 0;  
               printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu3 , OFF );  
            }  
            Bom_Activation;
            arrFlagHenGio[id] = 0;      
    }
}

void HenGio()
{
    unsigned char i;

    for(i=0;i<=Hengio_BomKhu3Lan3;i++)
    {  
            switch(i)
            {   
                //hen gio den
                case Hengio_DenKhu1Lan1:
                    checkHengioDen(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_DenKhu1Lan2:
                    checkHengioDen(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_DenKhu1Lan3: 
                    checkHengioDen(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_DenKhu2Lan1:
                    checkHengioDen(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_DenKhu2Lan2:
                    checkHengioDen(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;            
                case Hengio_DenKhu2Lan3:
                    checkHengioDen(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_DenKhu3Lan1:
                    checkHengioDen(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_DenKhu3Lan2:
                    checkHengioDen(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;              
                case Hengio_DenKhu3Lan3:
                    checkHengioDen(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                //hen gio quat    
                case Hengio_QuatKhu1Lan1:
                    checkHengioQuat(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_QuatKhu1Lan2:
                    checkHengioQuat(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_QuatKhu1Lan3:
                    checkHengioQuat(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_QuatKhu2Lan1:
                    checkHengioQuat(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_QuatKhu2Lan2:
                    checkHengioQuat(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;            
                case Hengio_QuatKhu2Lan3:
                    checkHengioQuat(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_QuatKhu3Lan1:
                    checkHengioQuat(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_QuatKhu3Lan2:
                    checkHengioQuat(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;              
                case Hengio_QuatKhu3Lan3:
                    checkHengioQuat(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break; 
                //hen gio bom     
                case Hengio_BomKhu1Lan1:
                    checkHengioBom(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_BomKhu1Lan2:
                    checkHengioBom(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_BomKhu1Lan3: 
                    checkHengioBom(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_BomKhu2Lan1: 
                    checkHengioBom(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_BomKhu2Lan2:
                    checkHengioBom(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;            
                case Hengio_BomKhu2Lan3: 
                    checkHengioBom(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_BomKhu3Lan1: 
                    checkHengioBom(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;
                case Hengio_BomKhu3Lan2:
                    checkHengioBom(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;              
                case Hengio_BomKhu3Lan3: 
                    checkHengioBom(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
                    break;   
            }
    }
}

void setup(){

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Port E initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);

// Port F initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTF=(1<<PORTF7) | (1<<PORTF6) | (1<<PORTF5) | (1<<PORTF4) | (1<<PORTF3) | (1<<PORTF2) | (1<<PORTF1) | (1<<PORTF0);

// Port G initialization
// Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRG=(0<<DDG4) | (1<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
// State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);



// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 19.531 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// OC1C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.99999 s
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0xB3;
TCNT1L=0xB5;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);


// External SRAM page configuration: 
MCUCR|=(1<<SRE);

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x81;

// ADC initialization
// ADC Clock frequency: 156.250 kHz
// ADC Voltage Reference: Int., cap. on AREF
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTD
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: On
// Square wave frequency: 1Hz
rtc_init(0,1,0);

// Global enable interrupts
#asm("sei")

}
