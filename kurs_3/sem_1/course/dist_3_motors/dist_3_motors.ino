#include <Servo.h>

Servo myservo1;  // create servo object to control a servo
Servo myservo2;
Servo myservo3;
Servo myservo4;
Servo myservo5;
Servo myservo6;
const int Trig = 2; 
const int Echo = 12; 
const int ledPin = 13;

void setup() {
  myservo1.attach(4);  // attaches the servo on pin 9 to the servo object
  myservo2.attach(5);
  myservo3.attach(3);
  //  myservo4.attach(4);
  //  myservo5.attach(5);
  //  myservo6.attach(6);

  pinMode(Trig, OUTPUT);  
  pinMode(Echo, INPUT); 
  pinMode(ledPin, OUTPUT); 

  Serial.begin(9600);
}


unsigned int time_us=0;
unsigned int distance_sm=0;
bool turned=false;

void loop() {
  digitalWrite(Trig, HIGH); 
  delayMicroseconds(10);  
  digitalWrite(Trig, LOW);  
  time_us=pulseIn(Echo, HIGH);  
  distance_sm=time_us/58;  
  Serial.println(distance_sm); 
  if(distance_sm<10 && !turned)
  {
//    myservo1.write(20);                  
//    myservo2.write(20); 
//    myservo3.write(20); 
//    delay(400);
//    
         
    myservo1.write(45); 
    myservo2.write(45); 
    myservo3.write(45); 
    delay(150);
//    
           
    myservo1.write(90);
    myservo3.write(90); 
    myservo2.write(90); 
//    delay(150);


    turned=true;


    digitalWrite(ledPin, 1);
    
    
    //  myservo4.write(45); 
    //  myservo5.write(45); 
    //  myservo6.write(45); 
    //  delay(150);
    
    //  myservo4.write(90);  
    //  myservo5.write(90); 
    //  myservo6.write(90); 
    //  delay(150);
    //    
    //    myservo2.write(45);                 
    //    myservo1.write(45); 
    //    myservo3.write(45); 
    //    delay(150);
    
    //  myservo4.write(45); 
    //  myservo5.write(45); 
    //  myservo6.write(45); 
    //  delay(150);
    }else if(turned && distance_sm>10)
      {
        
        digitalWrite(ledPin, 0);
        myservo1.write(45);
        myservo2.write(45); 
        myservo3.write(45); 
        delay(150);
//  
        myservo1.write(20);                  
        myservo2.write(20); 
        myservo3.write(20); 
        turned=false;
      }else if(distance_sm>10)
      {
        digitalWrite(ledPin, 0);
        }
        Serial.println(turned);
   delay(100);
}

