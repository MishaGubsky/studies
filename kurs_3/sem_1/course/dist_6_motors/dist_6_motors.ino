/*
 Controlling a servo position using a potentiometer (variable resistor)
 by Michal Rinott <http://people.interaction-ivrea.it/m.rinott>

 modified on 8 Nov 2013
 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Knob
*/

#include <Servo.h>
#include <Stepper.h>

Servo myservo;  // create servo object to control a servo
Servo myservo1;
Servo myservo2;
Servo myservo3;
Servo myservo4;
Stepper stepper(100, 8, 9, 10, 11);

const int Trig = 2; 
const int Echo = 12; 
const int ledPin = 13;


void setup() {
  myservo1.attach(6);
  myservo.attach(2); 
  myservo2.attach(3);
  myservo3.attach(4);
  myservo4.attach(5);
  stepper.setSpeed(100);
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
    myservo.write(20);                  // sets the servo position according to the scaled value
    myservo1.write(20);
    myservo2.write(20);
    myservo3.write(20);
    myservo4.write(20);
    stepper.step(10);
    delay(300);
    //if(lastpos==90 || lastpos==0)
    //{
    //  val=!val;
    //}
    // lastpos+=val;
    
    myservo.write(45); 
    myservo1.write(45); 
    myservo2.write(45);
    myservo3.write(45);
    myservo4.write(45);
    stepper.step(10);
   
    delay(100);
    
    myservo.write(90);
    myservo1.write(90);
    myservo2.write(90);
    myservo3.write(90);
    myservo4.write(90);
    stepper.step(10);
    delay(100);
    
    myservo.write(135);  
    myservo1.write(135); 
    myservo2.write(135);
    myservo3.write(135);
    myservo4.write(135); 
    stepper.step(10);
    delay(100);
    
    myservo.write(180); 
    myservo1.write(180);
    myservo2.write(180);
    myservo3.write(180);
    myservo4.write(180);  
    stepper.step(10);
    delay(300);
    
    turned=true;
    digitalWrite(ledPin, 1);
 }else if(turned && distance_sm>10)
      {
        digitalWrite(ledPin, 0);
        myservo.write(135);  
        myservo1.write(135); 
        myservo2.write(135);
        myservo3.write(135);
        myservo4.write(135); 
        stepper.step(10);
        delay(100);
        
        myservo.write(90);
        myservo1.write(90);
        myservo2.write(90);
        myservo3.write(90);
        myservo4.write(90);
        stepper.step(10);
        delay(100);
      
        
        myservo.write(45); 
        myservo1.write(45); 
        myservo2.write(45);
        myservo3.write(45);
        myservo4.write(45);
        stepper.step(10);
        delay(100);    

        
        myservo.write(20);
        myservo1.write(20);
        myservo2.write(20);
        myservo3.write(20);
        myservo4.write(20);
        stepper.step(10);
        delay(300);
        turned=false;
  }else if(distance_sm>10)
      {
        digitalWrite(ledPin, 0);
        }
   //Serial.println(turned);
   delay(100);
}

