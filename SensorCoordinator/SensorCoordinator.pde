/*
 * Sensor Coordinator code was written using the Metronome Coordinator (Processing Code) as reference 
 * DIGF 6003 Ubiquitous Computing - Kate Hartman & Nick Puckett
 * 
 */

import processing.serial.*; // import the Processing serial library
Serial myPort;              // The serial port
int radioID;
int sensorValue;
int sqSize = 700; // Largest square is the size of the window
int[] sradios = {1,2,4,5,6,7,8,10,12,15,9}; // array to hold radios that are transmitting to controller
int[] svalues = {0,255,0,255,0,255,0,255,0,255,0}; // array to hold sensor values - constantly updated
                                                 // NOTE: sradios.length must == svalues.length @tyson
                                         
// HSB Modifiers
int satVal = abs(255/4 * 3); // value for saturation, (any value, 255 max) @tyson 
int hueVal = 30; // hue seperation per radio (any value, 255 range)
int hueStart = 100; // hue offset (any value, 255 range)

void setup() {
  size(700, 700);
  // List all the available serial ports in the console
  // printArray(Serial.list()); // uncomment this to view your port Amaria

  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  String portName = Serial.list()[32];
  myPort = new Serial(this, portName, 9600);
  // read incoming bytes to a buffer
  // until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

/*
 *  This function draws a 
 */
void draw() {
  background(255);
  int coord = sqSize/2; // a variable to center the squares in canvas @maria
  
  // Loop through the radios & sensor value arrays to create a square for each radio @maria
  for(int i = 0; i < sradios.length; i++) {
    
    colorMode(HSB,255,255,255); // switch to HSB colors @tyson
    float cVal = svalues[i]; // the new balance value
    color sqCol = color((hueStart + hueVal * i) % 255,satVal % 255,cVal);// Color the squares
                                                // % aka modulo guarantees values will be valid
    
    // Draw the squares at the specified coordinate, using sqSize to control size @maria
    rectMode(CENTER);
    noStroke();
    fill(sqCol);
    int newSize = sqSize - ((sqSize/sradios.length) * i); // Generate a smaller size for the next square @maria
                                                          // Adjusted to adapt to sradios array size @tyson
    rect(coord,coord,newSize,newSize);
    
    // Draw the labels at the square's center @maria
    /*
    textAlign(CENTER,CENTER);
    fill(0);
    text(rid, coord, coord); */
  }
}

void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    println(myString);
    myString = trim(myString);
    
    // split the string at the commas
    // and convert the sections into integers:
    int sensors[] = int(split(myString, ','));
    //println();
    radioID= sensors[0];  
    sensorValue = sensors[1]; 
    // println("Radio Id: " + rID + " Sensor Value: " + sVal);
    updateData(radioID,sensorValue);
  }
}

/*
 * This function takes a radioID and a corresponding sensor value and updates
 * the sensor value in their respective global array - svalues @maria
 */
void updateData(int rID, int sVal){
  // println("Radio Id: " + rID + " Sensor Value: " + sVal);
  
  for (int i =0; i<sradios.length;i++) { // Loop through all radios @tyson
    if (rID == sradios[i]) { // if target radio id matches current radio index... @tyson
      svalues[i] = sVal;  // set a new value for this radio index @tyson
      return; // exit this function @tyson
    }
  }
  
  // This will only occur if rID was not found! @tyson
  println("Sensor value not updated! Check the radio ID ");
  
}
