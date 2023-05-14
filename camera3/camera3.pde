import processing.video.*;

Capture[] cameras; // Array to hold the camera objects
int numCameras; // Number of cameras

int windowWidth = 1920; // Width of the window
int windowHeight = 1280; // Height of the window
int cameraWidth; // Width of each camera feed
int cameraHeight; // Height of each camera feed

int draggedCamera = -1; // Index of the camera being dragged (-1 for none)
int dragOffsetX, dragOffsetY; // Offset between mouse position and camera top-left corner

int[] cameraPositionsX; // Array to store camera X positions
int[] cameraPositionsY; // Array to store camera Y positions

void settings() {
  size(windowWidth, windowHeight);
}

void setup() {
  // Check the available camera devices
  String[] devices = Capture.list();
  println("Available cameras:");
  for (int i = 0; i < devices.length; i++) {
    println(i + ": " + devices[i]);
  }

  // Choose which cameras to use
  numCameras = 1; // Set the number of cameras you want to use
  String[] selectedCameras = new String[]{"FaceTime Camera"}; // Names of the selected cameras

  // Calculate the width and height of each camera feed
  cameraWidth = windowWidth / 2;
  cameraHeight = windowHeight / 2;

  // Initialize the cameras array
  cameras = new Capture[numCameras];

  // Initialize the camera positions array
  cameraPositionsX = new int[numCameras];
  cameraPositionsY = new int[numCameras];

  // Open the selected cameras
  for (int i = 0; i < numCameras; i++) {
    cameras[i] = new Capture(this, cameraWidth, cameraHeight, selectedCameras[i]);
    cameras[i].start();

    // Set the initial camera positions
    cameraPositionsX[i] = (i % 2) * cameraWidth;
    cameraPositionsY[i] = (i / 2) * cameraHeight;
  }
}

void draw() {
  background(0);

  // Display the camera feeds
  for (int i = 0; i < numCameras; i++) {
    if (cameras[i].available()) {
      cameras[i].read();
    }

    // Calculate the position of the camera feed based on mouse dragging
    int xPos = cameraPositionsX[i];
    int yPos = cameraPositionsY[i];

    if (draggedCamera == i) {
      xPos = mouseX - dragOffsetX;
      yPos = mouseY - dragOffsetY;
    }

    image(cameras[i], xPos, yPos, cameraWidth, cameraHeight);

    // Update the camera positions
    cameraPositionsX[i] = xPos;
    cameraPositionsY[i] = yPos;
  }
}

void mousePressed() {
  // Check if the mouse is pressed on a camera feed
  for (int i = 0; i < numCameras; i++) {
    int xPos = cameraPositionsX[i];
    int yPos = cameraPositionsY[i];
    if (mouseX >= xPos && mouseX < xPos + cameraWidth && mouseY >= yPos && mouseY < yPos + cameraHeight) {
      // Start dragging the camera
      draggedCamera = i;
      dragOffsetX = mouseX - xPos;
      dragOffsetY = mouseY - yPos;
    }
  }
}

void mouseReleased() {
  // Stop dragging the camera
  draggedCamera = -1;
}
