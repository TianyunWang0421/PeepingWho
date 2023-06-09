#include <Servo.h>

// constants won't change
const int TRIG_PIN  = 2;  
const int ECHO_PIN  = 3;  
const int SERVO_PIN = 9; 
const int DISTANCE_THRESHOLD = 50; // centimeters

Servo servo; 

float duration_us, distance_cm;

void setup() {
  Serial.begin (9600); 
  pinMode(TRIG_PIN, OUTPUT); 
  pinMode(ECHO_PIN, INPUT); 
  servo.attach(SERVO_PIN);  
  servo.write(0);
}

void loop() {
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  duration_us = pulseIn(ECHO_PIN, HIGH);
  distance_cm = 0.017 * duration_us;

  if(distance_cm < DISTANCE_THRESHOLD)
    servo.write(90); // rotate servo motor to 90 degree
  else
    servo.write(0);  // rotate servo motor to 0 degree

  Serial.print("distance: ");
  Serial.print(distance_cm);
  Serial.println(" cm");

  delay(500);
}
