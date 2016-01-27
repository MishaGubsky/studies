const int button = 3; 
const int ledPin = 13;  // 13 – если будете использовать встроенный в Arduino светодиод

void setup() 
{ 
pinMode(button, INPUT); 
pinMode(ledPin,OUTPUT);  
Serial.begin(9600); 
}

unsigned int time_us=0;

unsigned int distance_sm=0;
bool turned=false;

void loop() 
{  
  if(digitalRead(button))
  {
    Serial.println('+');
    digitalWrite(ledPin,HIGH);
    }else
    {
      Serial.println('-');
      digitalWrite(ledPin,LOW);
    }// Выводим на порт 
  
  delay(100); 
}
