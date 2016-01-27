/*
 Controlling a servo position using a potentiometer (variable resistor)
 by Michal Rinott <http://people.interaction-ivrea.it/m.rinott>

 modified on 8 Nov 2013
 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Knob
*/

#include <Servo.h>

Servo myservo;  // create servo object to control a servo
Servo myservo1;
Servo myservo2;
Servo myservo3;
Servo myservo4;
int potpin = 0;  // analog pin used to connect the potentiometer
int val=20;    // variable to read the value from the analog pin
int lastpos=0;
int previous = 0;
void setup() {
  myservo1.attach(3);
  myservo.attach(2); 
  myservo2.attach(4);
  myservo3.attach(5);
  myservo4.attach(9);
}

//void loop() {
//  myservo.write(20);                  // sets the servo position according to the scaled value
//  myservo1.write(20);
//  myservo2.write(20);
//  myservo3.write(20);
//  myservo4.write(20);
//  delay(1000);
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
  delay(1000);
  
  myservo.write(90);
  myservo1.write(90);
  myservo2.write(90);
  myservo3.write(90);
  myservo4.write(90);
  delay(100);
  
  myservo.write(135);  
  myservo1.write(135); 
  myservo2.write(135);
  myservo3.write(135);
  myservo4.write(135); 
  delay(1000);
  
//  myservo.write(180); 
//  myservo1.write(180);
//  myservo2.write(180);
//  myservo3.write(180);
//  myservo4.write(180);
//  delay(300);
//  
//  myservo.write(135);  
//  myservo1.write(135); 
//  myservo2.write(135);
//  myservo3.write(135);
//  delay(100);
//  myservo4.write(135); 
//  
  myservo.write(90);
  myservo1.write(90);
  myservo2.write(90);
  myservo3.write(90);
  myservo4.write(90);
  delay(100);

   
  myservo1.write(45); 
  myservo2.write(45);
  myservo3.write(45);
  myservo4.write(45);
  delay(100);
}

