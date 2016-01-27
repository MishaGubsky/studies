#include <Servo.h> 

char incomingByte;  // входящие данные
int  LED = 12;      // LED подключен к 12 пину

Servo RotatoryServo;
Servo FirstStepLeftServo;
Servo FirstStepRightServo;
Servo SecondStepServo;
Servo ThirdStepServo;
Servo ClampServo;

int mySignals[8]={0,0,0,0,0,0,0,0};
int CurrentAngle[6]={90,0,0,0,90,0};


void setup() {
  Serial.begin(9600); // инициализация порта
  pinMode(LED, OUTPUT);
  
  RotatoryServo.attach(2);
  FirstStepLeftServo.attach(3);
  FirstStepRightServo.attach(4);
  SecondStepServo.attach(5);
  ThirdStepServo.attach(6);
  ClampServo.attach(7);
}

void loop() {
  Serial.println(mySignals[0]);
  Serial.println(mySignals[1]);
  if (Serial.available() > 0) {  //если пришли данные
    incomingByte = Serial.read(); // считываем байт
    Serial.println(incomingByte);
    
    if(isLowerCase(incomingByte))
    {
      int i=incomingByte-97;
      mySignals[i]=0;
    }else{
      int i=incomingByte-65;
      if(i % 2!=1 && mySignals[i+1]!=1)
        mySignals[i]=1;
      else if(i % 2==1 && mySignals[i-1]!=1)
        mySignals[i]=1;
    }
    
//    if(incomingByte == 'B') {
//      digitalWrite(LED, LOW);  // если 1, то выключаем LED
//        // и выводим обратно сообщение
//    }
//    if(incomingByte == 'b') {
//      digitalWrite(LED, HIGH); // если 0, то включаем LED
//      Serial.println("LED ON. Press 0 to LED OFF!");
//    }
  }
  
  ProcessingSignals(mySignals);
  delay(100);
}


void ProcessingSignals(int* mySignals){
  GoBreak(mySignals[0]);
  GoTake(mySignals[1]);
  GoDown(mySignals[2]);
  GoUp(mySignals[3]);
  GoRight(mySignals[4]);
  GoLeft(mySignals[5]);
  GoBack(mySignals[6]);
  GoForward(mySignals[7]);  
}


void GoBreak(int signal)
{  
  if(signal)
  {
    ClampServo.write(130);
    delay(400); 
  }else{
    ClampServo.write(180);
    delay(400); 
  }
}

void GoTake(int signal)
{  
  if(signal)
  {
    GoBreak(1);
    GoBreak(0);
    mySignals[1]=0;
  }
}

void GoDown(int signal)
{}

void GoUp(int signal)
{}
//?????????????????????
void GoRight(int signal)
{
  if(signal && CurrentAngle[0]<180)
  {
    CurrentAngle[0]+=20;
    RotatoryServo.write(CurrentAngle[0]);
  }
}

void GoLeft(int signal)
{
  if(signal && CurrentAngle[0]>0)
  {
    CurrentAngle[0]-=20;
    RotatoryServo.write(CurrentAngle[0]);
  }
}

///?????
void GoBack(int signal)
{
  if(signal){
    if(CurrentAngle[1]>60)
    {  
      if(CurrentAngle[3]<10)
      {
        if(CurrentAngle[4]<140)
           CurrentAngle[4]+=10;
         else
             CurrentAngle[4]-=10;
         TridStepServo.write(CurrentAngle[4]);  
      }else{
        CurrentAngle[3]-=10;
        SecondStepServo.write(CurrentAngle[3]);
      }
    }else
    {
      CurrentAngle[1]+=10;
      FirstStepLeftServo.write(CurrentAngle[1]);
      CurrentAngle[2]-=10;
      FirstStepRightServo.write(CurrentAngle[2]);
    }
  }
}

void GoForward(int signal)
{}
