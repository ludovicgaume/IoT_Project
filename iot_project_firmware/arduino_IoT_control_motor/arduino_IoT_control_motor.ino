#include<SoftwareSerial.h>
#include <stdio.h>
SoftwareSerial SUART(2, 3); //SRX=Dpin-2; STX-DPin-3
// Motor A connections
int enA = 5;
int in1 = 8;
int in2 = 7;
// Motor B connections
int enB = 6;
int in3 = 9;
int in4 = 4;
int robot_speed_number = 0;
int robot_speed_PWM = 0;
int sens = 0;
int message = 0;
int prev_message = 0;
const byte numChars = 32;
char receivedChars[numChars];
boolean newData = false;
/*****************************************************************************          
 *          ______     
 *   enA  -|      |- VCC1
 *   IN1  -|      |- IN4
 *   OUT1 -|      |- OUT4
 *   GND  -|      |- GND
 *   GMD  -|      |- GND
 *   OUT2 -|      |- OUT3
 *   IN2  -|      |- IN3
 *   VCC2 -|______|- enB
 *   
 ENX = High will make the engine spin, Low will make it stop but can control the speed with a 
 (PWM maximum possible values are 0 to 255)
 OUT1(+) and OUT2(-) are the output for motor 1
 OUT4(+) and OUT3(-) are the outpût for motor 2
 IN1      IN2  Spinning Direction
 Low(0)  Low(0)  Motor OFF
 High(1) Low(0)  Forward
 Low(0)  High(1) Backward
 High(1) High(1) Motor OFF
 
 
 ******************************************************************************/
void setup()
{
  Serial.begin(4800); //enable Serial Monitor
  SUART.begin(4800); //enable SUART Port
  
  // Set all the motor control pins to outputs
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  
  // Turn off motors - Initial state
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);

}

void loop()
{
  byte n = SUART.available(); //n != 0 means a character has arrived
  if (n != 0)
  {/*
    while(SUART.read() != "," && SUART.available() != 0){
      char message = SUART.read();  //read character
      message = (int)message;
      Serial.print(message);        //show character on Serial Monitor
      Serial.println("");
    }
    */
    int message = SUART.parseInt();  //read character
    if(message > 100){
      message = prev_message;
    }
    Serial.print("message");
    Serial.print(message);        //show character on Serial Monitor
    Serial.println("");
    
    /*
    We decode the message received by SUART encoded on a int
    the int is between 0 and 39 in the format XY
    X is the direction 0 straight, 1 back, 2 left, 3 right
    Y is the speed between 0 and 9
  */
  Serial.print("message");        //show character on Serial Monitor
  Serial.println(message);
  robot_speed_number = message % 10;
  Serial.print("robot_speed_number");        //show character on Serial Monitor
  Serial.println(robot_speed_number);
  /*
   We convert the value into PWM shape by using the function map()
   The synthax is: map(value, fromLow, fromHigh, toLow, toHigh)
  */
  robot_speed_PWM = map(robot_speed_number, 0, 9, 0, 255);
  Serial.print("robot_speed_PWM");        //show character on Serial Monitor
  Serial.println(robot_speed_PWM);
  sens = message / 10;
  Serial.print("sens");        //show character on Serial Monitor
  Serial.println(sens);
  move_robot(robot_speed_PWM, sens);
  prev_message = message;
  }
  
  else{
    Serial.print("No message");
    //int message = 0;
  }
  delay(200);
}


void move_robot(int motorSpeed, int sens) {
  // Set motors to maximum speed
  // For PWM maximum possible values are 0 to 255
  analogWrite(enA, motorSpeed);
  analogWrite(enB, motorSpeed);
  // If forward is clicked
  if(motorSpeed>0 && sens == 0){
    // Turn on motor A & B
    /*
    The function select type replace these four lines
    digitalWrite(in1, HIGH);
    digitalWrite(in2, LOW);
    digitalWrite(in3, HIGH);
    digitalWrite(in4, LOW);
    */
    select_type_move(HIGH, LOW, HIGH, LOW);
    delay(100);
  }
  // If backward is clicked
  if(motorSpeed>0 && sens == 1){
    // Change motor directions
    select_type_move(LOW, HIGH, LOW, HIGH);
    delay(100);
  }
  // If turn left is clicked
  if(motorSpeed>0 && sens == 2){
    select_type_move(LOW, HIGH, HIGH, LOW);
    delay(100);
  }
  
  // If turn right is clicked
  if(motorSpeed>0 && sens == 3){
    select_type_move(HIGH, LOW, LOW, HIGH);
    delay(100);
  }
  if(motorSpeed == 0){
    //Stop motor at the end
    stop_robot();
  }
}

void select_type_move(int in1_state, int in2_state, int in3_state, int in4_state){
  digitalWrite(in1, in1_state);
  digitalWrite(in2, in2_state);
  digitalWrite(in3, in3_state);
  digitalWrite(in4, in4_state);
}

void stop_robot(){
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);
}
