const int trigPin = 2;   // Trigger pin of ultrasonic sensor
const int echoPin = 3;   // Echo pin of ultrasonic sensor

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  // Send a pulse to the ultrasonic sensor
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Read the time it takes for the echo to return
  long duration = pulseIn(echoPin, HIGH);
  
  // Calculate the distance in centimeters
  int distance = duration * 0.034 / 2;
  
  // Send the distance over the serial port
  Serial.println(distance);
  
  delay(500);
}
