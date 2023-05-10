import processing.video.*;
import java.awt.Frame;

Capture video;
Serial arduino;
int distanceThreshold = 15;
PImage capturedImage;

void setup() {
  size(640, 480);
  
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
      video = new Capture(this, cameras[1]);
      video.start();
    } else {
      println("Invalid camera index");
      exit();
    }
  }
  
  // Initialize Arduino serial communication
  String[] serialPorts = Serial.list();
  if (serialPorts.length == 0) {
    println("No Arduino connected");
    exit();
  } else {
    println("Available serial ports:");
    for (int i = 0; i < serialPorts.length; i++) {
      println(i + ": " + serialPorts[i]);
    }
    
    // Choose the Arduino serial port by index
    int portIndex = 0; // Set the desired port index here
    if (portIndex >= 0 && portIndex < serialPorts.length) {
      arduino = new Serial(this, serialPorts[portIndex], 9600);
    } else {
      println("Invalid serial port index");
      exit();
    }
  }
  
  // Create a separate window to display the captured picture
  Frame imageWindow = new Frame("Captured Image");
  imageWindow.setSize(640, 480);
  imageWindow.addNotify();
  PApplet imageApplet = new PApplet();
  imageApplet.init();
  imageWindow.add(imageApplet);
  imageApplet.setSize(640, 480);
  imageWindow.setVisible(true);
  capturedImage = createImage(640, 480, RGB);
}

void draw() {
  if (video.available()) {
    video.read();
  }
  
  background(0);
  image(video, 0, 0, width, height);
  
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
  
  // Display the captured image in the separate window
  if (capturedImage != null) {
    imageApplet.image(capturedImage, 0, 0, 640, 480);
  }
}

void capturePicture() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  video.save("picture_" + timestamp + ".jpg");
  println("Picture captured");
  
  // Load the captured image
  capturedImage = loadImage("picture_" + timestamp + ".jpg");
  if (capturedImage == null) {
    println("Failed to load the captured image");
  }
}
