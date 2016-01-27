#include <Servo.h>

char incomingByte;  // входящие данные

Servo RotatoryServo;
Servo FirstStepLeftServo;
Servo FirstStepRightServo;
Servo SecondStepServo;
Servo ThirdStepServo;
Servo ClampServo;

int mySignals[8] = {0, 0, 0, 0, 0, 0, 0, 0};
int CurrentAngle[6] = {90, 0, 180, 90, 90, 0}; //4-down; 5-down;

bool goBFParallel = false;
int myStep = 10;


void setup() {
  Serial.begin(9600); // инициализация порта

  RotatoryServo.attach(8);
  FirstStepLeftServo.attach(3);
  FirstStepRightServo.attach(4);
  SecondStepServo.attach(5);
  ThirdStepServo.attach(6);
  ClampServo.attach(7);
  PrepareForStart();

}

void loop() {
  Serial.println("aval:" + Serial.available());
  if (Serial.available() > 0) {
    Serial.println();

    incomingByte = Serial.read(); // считываем байт
    Serial.println(incomingByte);

    if (isLowerCase(incomingByte))
    {
      int i = incomingByte - 97;
      mySignals[i] = 0;
    } else {
      int i = incomingByte - 65;
      mySignals[i] = 1;
      if (i % 2 != 1 && mySignals[i + 1] != 1)
        mySignals[i] = 1;
      else if (i % 2 == 1 && mySignals[i - 1] != 1)
        mySignals[i] = 1;
    }

    for (int i = 0; i < 8; i++)
      Serial.print(mySignals[i]);
  }

  ProcessingSignals(mySignals);
  delay(100);
}

void PrepareForStart()
{
  RotatoryServo.write(CurrentAngle[0]);
  //  for (int i = CurrentAngle[1] / myStep; i > 0; i--)
  //  {
  //    CurrentAngle[1] = i * myStep;
  //    CurrentAngle[2] = 175 - i * myStep;
  //    FirstStepLeftServo.write(CurrentAngle[1]);
  //    FirstStepRightServo.write(CurrentAngle[2]);
  //    delay(100);
  //  }
  FirstStepLeftServo.write(CurrentAngle[1]);
  FirstStepRightServo.write(CurrentAngle[2]);
  delay(2000);
  SecondStepServo.write(CurrentAngle[3]);
  ThirdStepServo.write(CurrentAngle[4]);
  ClampServo.write(CurrentAngle[5]);
}



void ProcessingSignals(int* mySignals) {
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
  if (signal)
  {
    ClampServo.write(80);
    delay(400);
  } else {
    ClampServo.write(180);
    delay(400);
  }
}

void GoTake(int signal)
{

  if (signal) {
    Serial.println("I'm gotake");
    ClampServo.write(45);
    delay(400);

    ClampServo.write(90);
    delay(200);

    ClampServo.write(135);
    delay(200);

    ClampServo.write(180);
    delay(200);
    mySignals[1] = 0;
  }
}

void GoDown(int signal)
{

  if (signal) {
    Serial.println("I'm godown");

    if (CurrentAngle[1] <= 10)
    {

      Serial.println("I'm in secondStep" + CurrentAngle[3]);
      if (CurrentAngle[3] >= 170)
      {
        Serial.println("I'm in secondStep" + CurrentAngle[3]);
        if (CurrentAngle[4] <= 0)
        {
          Serial.println("I'm in thirdStep " + CurrentAngle[4]);
          CurrentAngle[4] += myStep;
          ThirdStepServo.write(CurrentAngle[4]);
        } else {
          mySignals[2] = 0;
        }
      } else {

        CurrentAngle[3] += myStep;
        SecondStepServo.write(CurrentAngle[3]);
      }

    }

    else
    {
      Serial.println("I'm in firstStep ");
      for (int i = CurrentAngle[1] / myStep; i > 0; i--)
      {
        CurrentAngle[1] = i * myStep;
        CurrentAngle[2] = 175 - i * myStep;
        FirstStepLeftServo.write(CurrentAngle[1]);
        FirstStepRightServo.write(CurrentAngle[2]);
        delay(100);
      }
    }
    delay(200);
  }

}

void GoUp(int signal)
{

  if (signal) {
    Serial.println(CurrentAngle[1]);
    if (CurrentAngle[1] > 89 && CurrentAngle[1] < 101)
    {

      Serial.println("I'm in secondStep");
      Serial.println(CurrentAngle[3]);
      delay(100);
      if (CurrentAngle[3] <= 10)
      {
        Serial.println("I'm in secondStep");
        if (CurrentAngle[4] >= 170)
        {
          CurrentAngle[4] += myStep;
          ThirdStepServo.write(CurrentAngle[4]);
        } else {
          mySignals[3] = 0;
        }
      } else {

        CurrentAngle[3] -= myStep;
        SecondStepServo.write(CurrentAngle[3]);
      }

    }

    else
    {
      Serial.println("I'm in firstStep " + CurrentAngle[1]);
      if (CurrentAngle[1] < 90)
        for (int i = CurrentAngle[1] / myStep; i <= 90 / myStep; i++)
        {
          CurrentAngle[1] = i * myStep;
          CurrentAngle[2] = 180 - i * myStep;
          FirstStepLeftServo.write(CurrentAngle[1]);
          FirstStepRightServo.write(CurrentAngle[2]);
          delay(200);
        }
      else if (CurrentAngle[1] > 100)
        for (int i = CurrentAngle[1] / myStep; i > 100 / myStep; i--)
        {
          CurrentAngle[1] = i * myStep;
          CurrentAngle[2] = 175 - i * myStep;
          FirstStepLeftServo.write(CurrentAngle[1]);
          FirstStepRightServo.write(CurrentAngle[2]);
          delay(200);
        }
    }
    delay(200);
  }
}

void GoRight(int signal)
{

  if (signal) {
    Serial.println("fdd");
    Serial.println(CurrentAngle[0]);

    Serial.println("fdd1");
    delay(100);
    for (int i = CurrentAngle[0] / myStep; i * myStep > 20; i--) {
      CurrentAngle[0] = i * myStep;
      RotatoryServo.write(CurrentAngle[0]);
      delay(100);
    }
    mySignals[4] = 0;
  }
}

void GoLeft(int signal)
{

  if (signal) {
    Serial.println("I'm goleft");
    Serial.println(CurrentAngle[0]);
    for (int i = CurrentAngle[0] / myStep; i * myStep < 170 ; i++) {
      CurrentAngle[0] = i * myStep;
      RotatoryServo.write(CurrentAngle[0]);
      delay(100);
    }
    mySignals[5] = 0;
  }
}

void GoBack(int signal)
{

  if (signal) {
    Serial.println("I'm in goBack");
    if (!goBFParallel)
    {
      CurrentAngle[4] = 90;
      goBFParallel = true;
    }
    Serial.println(CurrentAngle[1]);
    if (CurrentAngle[1] >= 90)// && CurrentAngle[1] < 101)
    {

      Serial.println("I'm in secondStep");
      Serial.println(CurrentAngle[3]);
      delay(100);
      if (CurrentAngle[3] >= 160)
      {
        //        Serial.println(CurrentAngle[4]);
        //        CurrentAngle[4] = 130;
        //        ThirdStepServo.write(CurrentAngle[4]);
        goBFParallel = false;
        mySignals[6] = 0;
      } else {
        CurrentAngle[3] += myStep;
        CurrentAngle[4] += myStep;
        SecondStepServo.write(CurrentAngle[3]);
        ThirdStepServo.write(CurrentAngle[4]);
      }

    }

    else
    {
      Serial.println("I'm in firstStep " + CurrentAngle[1]);
      if (CurrentAngle[1] < 90)
        for (int i = CurrentAngle[1] / myStep; i <= 90 / myStep; i++)
        {
          CurrentAngle[1] = i * myStep;
          CurrentAngle[2] = 180 - i * myStep;
          FirstStepLeftServo.write(CurrentAngle[1]);
          FirstStepRightServo.write(CurrentAngle[2]);
          delay(200);

        }
    }
    delay(200);
  }
}
void GoForward(int signal)
{

  if (signal) {
    Serial.println("I'm goforward");
    if (!goBFParallel)
    {
      CurrentAngle[4] = 90;
      goBFParallel = true;
    }
    Serial.println(CurrentAngle[1]);
    if (CurrentAngle[1] <= 10)
    {
      Serial.println("I'm in secondStep");
      Serial.println(CurrentAngle[3]);
      if (CurrentAngle[3] >= 89 && CurrentAngle[3] <= 101)
      {
        goBFParallel = false;
        mySignals[7] = 0;

      } else {
        if (CurrentAngle[3] < 90)
        {
          CurrentAngle[3] += myStep;
          SecondStepServo.write(CurrentAngle[3]);
        } else if (CurrentAngle[3] > 100)
        {
          CurrentAngle[3] -= myStep;
          SecondStepServo.write(CurrentAngle[3]);
        }
      }
    }
    else
    {
      Serial.println("I'm in firstStep " + CurrentAngle[1]);
      for (int i = CurrentAngle[1] / myStep; i > 0; i--)
      {
        CurrentAngle[1] = i * myStep;
        CurrentAngle[2] = 175 - i * myStep;
        FirstStepLeftServo.write(CurrentAngle[1]);
        FirstStepRightServo.write(CurrentAngle[2]);
        delay(100);
      }
    }
    delay(200);
  }
}
