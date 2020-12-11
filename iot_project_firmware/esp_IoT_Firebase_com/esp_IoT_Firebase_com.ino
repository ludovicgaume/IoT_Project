#include<SoftwareSerial.h>
#include <FirebaseESP8266.h>
#define FIREBASE_HOST "esp8266-flutter-test.firebaseio.com"
#define FIREBASE_AUTH "3Ebc8GnRzWsWsS84IgEUIEWjQee5FsTIaQTaMXfb"
//#define FIREBASE_HOST "billy-iot-project-b32bd-default-rtdb.europe-west1.firebaseio.com"
//#define FIREBASE_AUTH "f53ddqFvfioYgFGW6IlvSSRq9HorPUxpiYaWxfSw"
#define WIFI_SSID "AndroidHotspot4429"
#define WIFI_PASSWORD "123456789"
#include <Servo.h>

SoftwareSerial SUART(4, 5); //SRX=Dpin-D2; STX-DPin-D1
//-------------------------

// Pin attribution
// Constants for the sensor
const int pinServo = 16; //D0 on esp8266

int robot_speed = 0;
int sens = 0;
int message = 0;


Servo myservo;
FirebaseData firebaseData;
FirebaseJson json;
// Define the actuators data objects of actuators
FirebaseData angleData;
FirebaseData motorSpeedData;
FirebaseData sensData;
FirebaseData turnData;

void setup()
{
  Serial.begin(4800); //enable Serial Monitor
  SUART.begin(4800); //enable SUART Port
  WIFInit();
  FirebaseInit();
  init_sensors_actuators();
}

void loop()
{
  /*
    We create a message to send it with SUART encoded on a int
    the int is between 0 and 99 in the format XY
    X is the direction 0 straight, 1 back, 2 left, 3 right
    Y is the speed between 0 and 9
  */
  delay(1);
  // send sensor data to the database
  //sendSensorState();
  
  float distance = sendSensorState();
  //float distance = 1;
  json.clear().add("distance", distance);
  if(Firebase.setJSON(firebaseData, "/sensors/Json", json)){
    Serial.println("Passed");
  }else{
    Serial.println("Failed");
  }
  
  // get actuators command from the database
  //FirebaseObject command = Firebase.get("/actuators/Json");
  // update the actuator state
  updateActuators();
}

void init_sensors_actuators(){
  
  //assign pin for the servo motor
  myservo.attach(pinServo);
  
}

void WIFInit(){
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  //WiFi.begin(WIFI_SSID);
  Serial.print("Connecting to WiFi");
  while(WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Conneceted with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
}

void FirebaseInit(){
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
  Firebase.setReadTimeout(firebaseData, 1000 * 60);
  Firebase.setwriteSizeLimit(firebaseData, "tiny");
}

float sendSensorState(){
  float sensor_volt;
  float R0 = -0.15;
  float RS_gas; // Get value of RS in a GAS

  float ratio; // Get ratio RS_GAS/RS_air

  int sensorValue = analogRead(A0);

  sensor_volt=(float)sensorValue/1024*5.0;

  RS_gas = (5.0-sensor_volt)/sensor_volt; // omit *RL



  /*-Replace the name "R0" with the value of R0 in the demo of First Test -*/

  ratio = RS_gas/R0;  // ratio = RS/R0
  return RS_gas;
}
void updateActuators(){
  // get data from the variable which contain the last database state
  Firebase.getInt(angleData, "/actuators/Json/angle");
  Firebase.getInt(motorSpeedData, "/actuators/Json/motorSpeed");
  Firebase.getInt(sensData, "/actuators/Json/sens");
  Firebase.getInt(turnData, "/actuators/Json/turn");
  Serial.print("command = ");
  Serial.println(angleData.intData()); // the message from FireBase
  // use data to change actuators state

  // Control the servomotor
  myservo.write(angleData.intData());
  Serial.print("motorSpeedData = ");
  Serial.println(motorSpeedData.intData());
  Serial.print("sensData = ");
  Serial.println(sensData.intData());
  // Control the robot motion
  updateMotorState(motorSpeedData.intData(), sensData.intData());
  
}


void updateMotorState(int robot_speed, int sens){
  message = 10 * sens + robot_speed;
  Serial.print("Message = ");
  Serial.print((int)message);
  //----Send Motor control via SUART port----
  SUART.print(" ");
  SUART.print((int)message, DEC);
  SUART.print(" ");
}
