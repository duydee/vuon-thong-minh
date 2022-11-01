#include <ArduinoJson.h>

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>

#include <WebSocketsClient.h>
#include <SocketIOclient.h>

#include <Hash.h>

ESP8266WiFiMulti WiFiMulti;
SocketIOclient socketIO;

//type uart
#define sensors      0
#define statusTB     1
#define hengioOns    2
#define hengioOffs   3
#define deleteHengio 4
#define getalldataStatusTB   5 
#define getalldataHengioTB   6
#define autoDen 7
#define autoQuat 8
#define autoBom 9

//id thiet bi

//hen gio quat
 
/* Set wifi */
const char *ssid = "00000000"; 
const char *password = "88888888";
const char *host = "vuonthongminh.herokuapp.com"; //    vuonthongminh.herokuapp.com

unsigned long lasttime = 0;

String inputString="";
bool stringComplete=false; 

String idget;
int type,id;
String flag;


//bien sensor
int temp, humi, dad,cbmua;

//arr status TB
int arrStatuTB[25];

//arr hen gio TB
int arrGioOn[30], arrPhutOn[30];
int arrGioOff[30], arrPhutOff[30];

String data;


void socketIOEvent(socketIOmessageType_t type,  unsigned char * payload, size_t length) {
    switch(type) {
        case sIOtype_DISCONNECT:
            Serial.printf("[IOc] Disconnected!\n");
            break;
        case sIOtype_CONNECT:
            Serial.printf("[IOc] Connected to url: %s\n", payload);
            socketIO.send(sIOtype_CONNECT, "/");
            break;
        case sIOtype_EVENT:
            //Serial.printf("data : %s\n",payload);
            GetData(length,payload);
            break;
        case sIOtype_ACK:
            Serial.printf("[IOc] get ack: %u\n", length);
            hexdump(payload, length);
            break;
        case sIOtype_ERROR:
            Serial.printf("[IOc] get error: %u\n", length);
            hexdump(payload, length);
            break;
        case sIOtype_BINARY_EVENT:
            Serial.printf("[IOc] get binary: %u\n", length);
            hexdump(payload, length);
            break;
        case sIOtype_BINARY_ACK:
            Serial.printf("[IOc] get binary ack: %u\n", length);
            hexdump(payload, length);
            break;
    }
}

void GetData(int length, unsigned char * payload)
{
//[IOc] data: ["capnhapdataStatusTB",[{"id":0,"ten":"Temp","trangthai":"0"},{"id":1,"ten":"humi","trangthai":"0"},{"id":2,"ten":"độ ẩm đất","trangthai":"0"},{"id":3,"ten":"cảm biến mưa","trangthai":"0"},{"id":4,"ten":"đèn khu 1","trangthai":"0"},{"id":5,"ten":"đèn khu 2","trangthai":"0"},{"id":6,"ten":"đèn khu 3","trangthai":"0"},{"id":7,"ten":"quạt khu 1","trangthai":"0"},{"id":8,"ten":"quạt khu 2","trangthai":"0"},{"id":9,"ten":"quạt khu 3","trangthai":"0"},{"id":10,"ten":"bơm khu 1","trangthai":"0"},{"id":11,"ten":"bơm khu 2","trangthai":"0"},{"id":12,"ten":"bơm khu 3","trangthai":"0"},{"id":13,"ten":"relay 1","trangthai":"0"},{"id":14,"ten":"relay 2","trangthai":"0"},{"id":15,"ten":"relay 3","trangthai":"0"},{"id":16,"ten":"relay 4","trangthai":"0"},{"id":17,"ten":"relay 5","trangthai":"0"},{"id":18,"ten":"relay 6","trangthai":"0"},{"id":19,"ten":"relay 7","trangthai":"0"},{"id":20,"ten":"relay 8","trangthai":"0"}]]
//[IOc] data: ["capnhapdataHengioTB",[{"id":0,"ten":"đèn khu 1 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":1,"ten":"đèn khu 1 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":2,"ten":"đèn khu 1 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":3,"ten":"đèn khu 2 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":4,"ten":"đèn khu 2 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":5,"ten":"đèn khu 2 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":6,"ten":"đèn khu 3 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":7,"ten":"đèn khu 3 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":8,"ten":"đèn khu 3 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":9,"ten":"quạt khu 1 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":10,"ten":"quạt khu 1 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":11,"ten":"quạt khu 1 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":12,"ten":"quạt khu 2 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":13,"ten":"quạt khu 2 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":14,"ten":"quạt khu 2 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":15,"ten":"quạt khu 3 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":16,"ten":"quạt khu 3 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":17,"ten":"quạt khu 3 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":18,"ten":"bơm khu 1 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":19,"ten":"bơm khu 1 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":20,"ten":"bơm khu 1 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":21,"ten":"bơm khu 2 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":22,"ten":"bơm khu 2 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":23,"ten":"bơm khu 2 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":24,"ten":"bơm khu 3 lần 1","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":25,"ten":"bơm khu 3 lần 2","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"},{"id":26,"ten":"bơm khu 3 lần 3","gioON":"-1","phutON":"-1","gioOFF":"-1","phutOFF":"-1"}]]
//[IOc] data: ["capnhapdataStatusTbChoEsp8266",{"id":1,"trangthai":"0"}]

//data : ["dongboallDataStatusTBchoEsp8266",[{"id":0,"ten":"Temp","trangthai":"1"},{"id":1,"ten":"humi","trangthai":"1"},{"id":2,"ten":"độ ẩm đất","trangthai":"1"},{"id":3,"ten":"cảm biến mưa","trangthai":"1"},{"id":4,"ten":"đèn khu 1","trangthai":"0"},{"id":5,"ten":"đèn khu 2","trangthai":"0"},{"id":6,"ten":"đèn khu 3","trangthai":"0"},{"id":7,"ten":"quạt khu 1","trangthai":"1"},{"id":8,"ten":"quạt khu 2","trangthai":"1"},{"id":9,"ten":"quạt khu 3","trangthai":"1"},{"id":10,"ten":"bơm khu 1","trangthai":"1"},{"id":11,"ten":"bơm khu 2","trangthai":"1"},{"id":12,"ten":"bơm khu 3","trangthai":"1"},{"id":13,"ten":"relay 1","trangthai":"1"},{"id":14,"ten":"relay 2","trangthai":"1"},{"id":15,"ten":"relay 3","trangthai":"1"},{"id":16,"ten":"relay 4","trangthai":"1"},{"id":17,"ten":"relay 5","trangthai":"1"},{"id":18,"ten":"relay 6","trangthai":"1"},{"id":19,"ten":"relay 7","trangthai":"1"},{"id":20,"ten":"relay 8","trangthai":"1"}]]
        
        data = String((char *)payload);  // doi thanh String
        
        DynamicJsonDocument jsonDocument(length + length); // 
        
        deserializeJson(jsonDocument,data );
        
        JsonArray root = jsonDocument.as<JsonArray>();

        flag = String(root[0]);
        
        if(flag == "capnhapdataStatusTBchoESP8266")
        { 
           if(int(root[1]["id"]) <= 9)
           {
               Serial.print("S0"+String(root[1]["id"])+String(root[1]["trangthai"])+"\n");
           }
           else
           {
               Serial.print("S"+String(root[1]["id"])+String(root[1]["trangthai"])+"\n");  
           }
        }
        else if(flag == "capnhapdataHenGioOnTBchoESP8266")
        {
           String gioON,phutON;
           if(int(root[1]["gioON"])<=9){gioON="0"+String(root[1]["gioON"]);}
           else{gioON=String(root[1]["gioON"]);}
           
           if(int(root[1]["phutON"])<=9){phutON="0"+String(root[1]["phutON"]);}
           else{phutON=String(root[1]["phutON"]);}
           
           if(int(root[1]["id"])<=9)
           {
               Serial.print("N0"+String(root[1]["id"])+gioON+phutON+"\n");
           }
           else
           {
               Serial.print("N"+String(root[1]["id"])+gioON+phutON+"\n");
           }
           
        }
        else if(flag == "capnhapdataHenGioOffTBchoESP8266")
        {
           String gioOFF,phutOFF;
           if(int(root[1]["gioOFF"])<=9){gioOFF="0"+String(root[1]["gioOFF"]);}
           else{gioOFF=String(root[1]["gioOFF"]);}
           
           if(int(root[1]["phutOFF"])<=9){phutOFF="0"+String(root[1]["phutOFF"]);}
           else{phutOFF=String(root[1]["phutOFF"]);}
           
           if(int(root[1]["id"])<=9)
           {
               Serial.print("F0"+String(root[1]["id"])+gioOFF+phutOFF+"\n");
           }
           else
           {
               Serial.print("F"+String(root[1]["id"])+gioOFF+phutOFF+"\n");
           }
        }
        else if(flag == "capnhapDeleteHengioTBchoESP8266")
        {
           if(int(root[1]["id"])<=9)
           {
               Serial.print("D0"+String(root[1]["id"])+"\n");
           }
           else
           {
               Serial.print("D"+String(root[1]["id"])+"\n");
           } 
        }
        else if(flag == "dongboallDataStatusTBchoEsp8266")
        {
            for(int i=0;i<=20;i++)
            {
               if(int(root[1][i]["id"]) <= 9)
               {
                   Serial.print("S0"+String(root[1][i]["id"])+String(root[1][i]["trangthai"])+"\n");
                   delay(3000);
               }
               else
               {
                   Serial.print("S"+String(root[1][i]["id"])+String(root[1][i]["trangthai"])+"\n");
                   delay(3000);
               }
            }          
        }
        else if(flag == "dongboallDataHengioTBchoEsp8266")
        {
           String gioON,phutON,gioOFF,phutOFF;
           for(int i=0;i<=26;i++)
           { 
              if(int(root[1][i]["gioON"])<=9){gioON="0"+String(root[1][i]["gioON"]);}
              else{gioON=String(root[1][i]["gioON"]);}
           
              if(int(root[1][i]["phutON"])<=9){phutON="0"+String(root[1][i]["phutON"]);}
              else{phutON=String(root[1][i]["phutON"]);}

              if(int(root[1][i]["gioOFF"])<=9){gioOFF="0"+String(root[1][i]["gioOFF"]);}
              else{gioOFF=String(root[1][i]["gioOFF"]);}
             
              if(int(root[1][i]["phutOFF"])<=9){phutOFF="0"+String(root[1][i]["phutOFF"]);}
              else{phutOFF=String(root[1][i]["phutOFF"]);}
              
               if(int(root[1][i]["id"]) <= 9)
               {
                    Serial.print("N0"+String(root[1][i]["id"])+gioON+phutON+"\n");
                    delay(2000);
                    Serial.print("F0"+String(root[1][i]["id"])+gioOFF+phutOFF+"\n");
                    delay(2000);
               }
               else
               {
                   Serial.print("N"+String(root[1][i]["id"])+gioON+phutON+"\n");
                   delay(2000);
                   Serial.print("F"+String(root[1][i]["id"])+gioOFF+phutOFF+"\n");
                   delay(2000);
               } 
               
           }
        } 
        else if(flag == "capnhapDataAutoDenchoEsp8266")
        {
            Serial.print("A" + String(root[1]["trangthai"]) +"\n");
        } 
        else if(flag == "capnhapDataAutoQuatchoEsp8266")
        {
            Serial.print("B" + String(root[1]["trangthai"]) +"\n");
        }
        else if(flag == "capnhapDataAutoBomchoEsp8266")
        {
            Serial.print("C" + String(root[1]["trangthai"]) +"\n");
        }        
}

//gui data sensor len db
void POSTdataSensor(int temp, int humi, int dad, int cbm)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("updatedataSensor");

        // add payload (parameters) for the event
        JsonObject nested = array.createNestedObject();
        nested["id"]   = 0;
        nested["temp"] = temp;
        nested["humi"] = humi;
        nested["doamdat"] = dad;
        nested["cambienmua"] = cbm;

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);   
}

//gui data trang thai thiet bi len db
void POSTdataStatusTB(int id ,int trangthai)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("updatedataStatusTB");

        // add payload (parameters) for the event
        JsonObject nestedstatusTB = array.createNestedObject();
        nestedstatusTB["id"]    = id;
        nestedstatusTB["trangthai"] = trangthai;
      

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);    
}

//gui data hen gio ON TB len db
void POSTdataHenGioONtB(int id, int gioOn, int phutOn)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("updatedataHenGioOnTB");

        // add payload (parameters) for the event
        JsonObject nestedhengioOnTB = array.createNestedObject();
        nestedhengioOnTB["id"]    = id;
        nestedhengioOnTB["gioON"] = gioOn;
        nestedhengioOnTB["phutON"] = phutOn;

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);      
}

//gui data hen gio OFF TB len db
void POSTdataHenGioOFFtB(int id, int gioOff, int phutOff)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("updatedataHenGioOffTB");

        // add payload (parameters) for the event
        JsonObject nestedhengioOffTB = array.createNestedObject();
        nestedhengioOffTB["id"]    = id;
        nestedhengioOffTB["gioOFF"] = gioOff;
        nestedhengioOffTB["phutOFF"] = phutOff;
        
        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);      
}

//gui data delete Hen gio len db
void DeletedataHenGio(int id)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("deleteHengio");

        // add payload (parameters) for the event
        JsonObject nesteddeletehengio = array.createNestedObject();
        nesteddeletehengio["id"]    = id;

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);      
}

//get all data tren database
void GetAllDataStatusTB()
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("dongboDataControlTBchoEsp8266");

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);      
}

//get all data tren database
void GetAllDataHenGioTB()
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("dongboDataHengioTBchoEsp8266");

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);      
}

//auto Den
void AutoTbDen(int trangthai)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("updatedataAutoDen");

        // add payload (parameters) for the event
        JsonObject nestedAutoDen = array.createNestedObject();
        nestedAutoDen["trangthai"] = trangthai;
      

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);    
}

//auto Quat
void AutoTbQuat(int trangthai)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("updatedataAutoQuat");

        // add payload (parameters) for the event
        JsonObject nestedAutoQuat = array.createNestedObject();
        nestedAutoQuat["trangthai"] = trangthai;
      

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);    
}

//auto Bom
void AutoTbBom(int trangthai)
{
        DynamicJsonDocument  doc(1024);
        JsonArray array = doc.to<JsonArray>();

        // add evnet name
        // Hint: socket.on('event_name', ....
        array.add("updatedataAutoBom");

        // add payload (parameters) for the event
        JsonObject nestedAutoBom = array.createNestedObject();
        nestedAutoBom["trangthai"] = trangthai;
      

        // JSON to String (serializion)
        String output;
        
        serializeJson(array, output);

        // Send event
        socketIO.sendEVENT(output);

        // Print JSON for debugging
        //Serial.println(output);    
}

void setup() {
   
      Serial.begin(9600);

      Serial.setDebugOutput(true);
  
      for(uint8_t t = 4; t > 0; t--) {
          Serial.printf("[SETUP] BOOT WAIT %d...\n", t);
          Serial.flush();
          delay(500);
      }
  
//      if(WiFi.getMode() & WIFI_AP) {
//          WiFi.softAPdisconnect(true);
//      }
//      
//      WiFiMulti.addAP(ssid,password);

      WiFi.mode(WIFI_STA);
      
      /* start SmartConfig */
      WiFi.beginSmartConfig();
    
     /* Wait for SmartConfig packet from mobile */
      Serial.println("Waiting for SmartConfig.");
      while (!WiFi.smartConfigDone()) {
        delay(500);
        Serial.print(".");
      }
      Serial.println("");
      Serial.println("SmartConfig done.");
  
      //WiFi.disconnect();
      while(WiFiMulti.run() != WL_CONNECTED) {
         delay(100);
      }
  
      String ip = WiFi.localIP().toString();
      Serial.printf("WiFi Connected %s\n", ip.c_str());
  
      // server address, port and URL
      socketIO.begin(host,80,"/socket.io/?EIO=4"); //port mac dinh tren heroku la 80
      //socketIO.begin("192.168.0.137",8080,"/socket.io/?EIO=4"); //test localhost
  
      // event handler
      socketIO.onEvent(socketIOEvent);
}

void loop() 
{
    socketIO.loop();
    
    while (Serial.available()) 
    {
      char inChar = (char)Serial.read();
      inputString += inChar;
      if(inChar == '\n')
      {
        stringComplete=true;  
      }
      if (stringComplete == true)
      {
         StaticJsonDocument<200> doc;
         DeserializationError error = deserializeJson(doc, inputString);

         if (error) 
         {
            //Serial.print(F("deserializeJson() failed: "));
            //Serial.println(error.f_str());
            return;
         }
         
         type = doc["type"];
         switch(type)
         {
            case sensors:
                //{"type":0,"temp":31,"humi":82,"dad":55,"cbmua":1}
                 temp = doc["temp"];
                 humi = doc["humi"];
                 dad  = doc["dad"];
                 cbmua= doc["cbmua"];
  
                 //Serial.println( String(temp) + String(humi) + String(dad) + String(cbmua) );
                 POSTdataSensor(temp,humi,dad,cbmua);
              break;
              
            case statusTB:
                //{"type":1,"id":17,"status":0}
                 id = doc["id"];
                 arrStatuTB[id] = doc["status"];
                 //Serial.println("trang thai TB " + String(id) + " la:" + String(arrStatuTB[id])); 
                 POSTdataStatusTB(id,arrStatuTB[id]);
              break;
              
            case hengioOns:
               //{"type":2,"id":0,"gio":0,"phut":0}
                id = doc["id"];
                arrGioOn[id] = doc["gio"];
                arrPhutOn[id] = doc["phut"];
                //Serial.println("hen gio on TB " + String(id) + " Gio: " + String(arrGioOn[id]) +" Phut: " + String(arrPhutOn[id]));
                POSTdataHenGioONtB(id,  arrGioOn[id],  arrPhutOn[id]); 
              break;
              
            case hengioOffs:
               //{"type":3,"id":0,"gio":3,"phut":2}
                id = doc["id"];
                arrGioOff[id] = doc["gio"];
                arrPhutOff[id] = doc["phut"];
                //Serial.println("hen gio off TB " + String(id) + " Gio: " + String(arrGioOff[id]) +" Phut: " + String(arrPhutOff[id]));
                POSTdataHenGioOFFtB(id,  arrGioOff[id],  arrPhutOff[id]); 
              break;
              
            case deleteHengio:
               //{"type":4,"id":0}
               id = doc["id"];
               arrGioOn[id]= 70;
               arrPhutOn[id]= 70;
               arrGioOff[id]= 70;
               arrPhutOff[id]= 70;
               //Serial.println("da xoa tb co id la " + String(id));
               DeletedataHenGio(id);
              break;
            case getalldataStatusTB:
               //{"type":5}
              GetAllDataStatusTB(); 
              break;
            case getalldataHengioTB:
               //{"type":6}
              GetAllDataHenGioTB();
              break;
            case autoDen:
               //{"type":7}
              AutoTbDen(doc["status"]);
              break;
            case autoQuat:
               //{"type":8}
              AutoTbQuat(doc["status"]);
              break;
            case autoBom:
               //{"type":9}
              AutoTbBom(doc["status"]);
              break;
              
         }
         //Serial.print(inputString);
         
         inputString ="";
         stringComplete=false;         
      } 
   }   
}
