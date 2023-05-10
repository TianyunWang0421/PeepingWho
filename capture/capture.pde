import processing.video.*;
import processing.serial.*;

Capture video;
Serial arduino;
int distanceThreshold = 10;
PImage capturedImage;

void setup() {
  size(800, 480); // Adjust the canvas size according to your needs
  
  // Initialize video capture
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No cameras available");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }
    
    // Choose the USB camera by index
    int cameraIndex = 0; // Set the desired camera index here
    if (cameraIndex >= 0 && cameraIndex < cameras.length) {
      video = new Capture(this, cameras[0]);
      video.start();
    } else {
      println("Invalid camera index");
      exit();
    }
  }
  
  // Initialize Arduino serial communication
  String portName = "/dev/cu.usbmodem141101"; // Set the desired serial port here
  arduino = new Serial(this, portName, 9600);

}

void draw() {
  if (video.available()) {
    video.read();
  }
  
  // Read distance from Arduino ultrasonic sensor
  if (arduino.available() > 0) {
    String distanceString = arduino.readStringUntil('\n');
    distanceString = trim(distanceString);
    if (distanceString != null) {
      int distance = Integer.parseInt(distanceString);
      if (distance < distanceThreshold) {
        capturePicture();
      }
    }
  }
  
  // Draw the captured image on both sides
  if (capturedImage != null) {
    image(capturedImage, 0, 0, width/2, height);
    image(capturedImage, width/2, 0, width/2, height);
  }
}

void capturePicture() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  
  // Save the captured image
  video.save("picture_" + timestamp + ".jpg");
  println("Picture captured");
  
  // Load the captured image
  capturedImage = loadImage("picture_" + timestamp + ".jpg");
}
