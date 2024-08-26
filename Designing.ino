// #include <Wire.h> 
#include <Servo.h> 


Servo myservo;

// int Slot = 4;           //Total number of parking Slots

// comoute ultrasonics

int trigger1 = 6;
int echo1 = 7;
// const int trigger2 = 11;
// const int echo2 = 12;
int distance;
long duration;

void setup() {

Serial.begin(9600);

myservo.attach(4);
myservo.write(100);
delay(2000);

pinMode(trigger1, OUTPUT);
// pinMode(trigger2, OUTPUT);
pinMode(echo1, INPUT);
// pinMode(echo2, INPUT);

}

void loop(){ 

  // ultrasonic();
  // clear pin/ set up
  digitalWrite(trigger1,LOW);
  delayMicroseconds(2);

  digitalWrite(trigger1,HIGH);
  delayMicroseconds(10);
  digitalWrite(trigger1,LOW);
  // Start measuring 
  duration = pulseIn(echo1, HIGH);
  distance = duration*0.034/2;

  Serial.print("distance: ");
  Serial.println(distance);

  if(distance <= 180)
  {
    myservo.write(270);
    delay(2000);
  }

  else
  {
    myservo.write(90);
  }
}

// void ultrasonic();
// {
//   // clear pin/ set up
//   digitalWrite(trigger1,LOW);
//   delayMicroseconds(2);

//   // Start measuring 
//   digitalWrite(trigger1,HIGH);
//   delayMicroseconds(10);
//   digitalWrite(trigger1,LOW);

//   duration = pulseIn(echo1, HIGH);
//   distance = duration*0.034/2;

//   Serial.print(duration);
//   Serial.println(" ");
//   Serial.print(distance);
//   Serial.println(" cm");
// }
// if(digitalRead (IR1) == LOW && flag1==0){

// if(Slot>0){flag1=1;

// if(flag2==0){myservo.write(0); Slot = Slot-1;}

// }else{

// lcd.setCursor (0,0);

// lcd.print("    SORRY :(    ");  

// lcd.setCursor (0,1);

// lcd.print("  Parking Full  "); 

// delay (3000);

// lcd.clear(); 

// }

// }



// if(digitalRead (IR2) == LOW && flag2==0){flag2=1;

// if(flag1==0){myservo.write(0); Slot = Slot+1;}

// }



// if(flag1==1 && flag2==1){

// delay (1000);

// myservo.write(100);

// flag1=0, flag2=0;

// }



// lcd.setCursor (0,0);

// lcd.print("    WELCOME!    ");

// lcd.setCursor (0,1);

// lcd.print("Slot Left: ");

// lcd.print(Slot);

// }
