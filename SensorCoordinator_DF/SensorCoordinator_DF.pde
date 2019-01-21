/*
 * SensorCoordinateor draw a sketch of the rooms in the Digital Futures Graduate Student Lounge,
 * Changing color of the location according to the values from XBee radios in the room. 
 * 
 * Sensor Coordinator code was written using the Metronome Coordinator (Processing Code) as reference 
 * DIGF 6003 Ubiquitous Computing - Kate Hartman & Nick Puckett
 */

import processing.serial.*; // import the Processing serial library
Serial myPort;              // The serial port
int radioID;
int sensorValue;
int sqSize = 700; // Largest square is the size of the window
int[] sradios = {1,2,4,5,6,7,8,10,12,15}; // array to hold radios that are transmitting to controller
int[] svalues = {255,255,255,255,255,255,255,255,255,255}; // [DF LOUNGE ROOMS] array to hold sensor values - constantly updated

// DF Grad Student Lounge Rooms
int[] xRooms = {958,1023,841,706,706,609,411,132,550,127,841}; // x coords for floor plan
int[] yRooms = {381,223,165,166,346,166,169,465,389,236,381}; // y coords for floor plan
int[] wRooms = {172,108,182,135,135,97,198,418,151,284,118}; // width for floor plan
int[] hRooms = {229,158,217,173,263,217,296,145,220,227,229}; // height for floor plan
int[] lRooms = {1,2,3,4,5,6,7,8,9,10,11}; // labels for floor plan

void setup() {
  size(1280, 800);
  // List all the available serial ports in the console
  // printArray(Serial.list()); // uncomment this to view your port

  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  String portName = Serial.list()[32];
  myPort = new Serial(this, portName, 9600);
  // read incoming bytes to a buffer
  // until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

/*
 *  This function draws:
 *  1. an optical illusion pattern of squares on the screen
 *  2. a representation of the DF Grad Student Lounge
 *  NOTE: // To view a particular illusion - comment out the appropriate sketch @maria
 */
void draw() {
  background(255);

  // Loop through the radios & sensor value arrays to create a square for each radio  
  for(int i = 0; i < xRooms.length; i++){
    int rX = xRooms[i]; // x-coords
    int rY = yRooms[i]; // y-coords
    int rW = wRooms[i]; // width
    int rH = hRooms[i]; // height
    int sval;
    
    if(i == 10){
      // Not enough radios
      sval = svalues[0]; // One radio will control two spaces
    } else {
      sval = svalues[i]; // Get the corresponding sensor value
    }
    
    // Map the sensor values to range 0 - 255 for RGB color mode. 
    // Map function - val to map, min, max, min val to map to, max val to map to
    float cVal = map(sval,0,1023,0,255); // the new color value
    color sqCol = color(cVal,cVal,cVal);// Color the squares - Black & White
    
    fill(sqCol);
    rect(rX,rY,rW,rH);
  }
  
  // Draw the labels over the floorplan
  for(int i = 0; i < xRooms.length; i++){
    int rX = xRooms[i]; // x-coords
    int rY = yRooms[i]; // y-coords
    int rW = wRooms[i]; // width
    int rH = hRooms[i]; // height
    int rL = lRooms[i]; // label
    
    textAlign(CENTER,CENTER);
    fill(0);
    text(rL, rX+(rW/2) , rY+(rH/2)); // calc a new x,y pos to center the labels in the squares
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
  if(rID == 1){
    svalues[0] = sVal;
  } else if(rID == 2){
    svalues[1] = sVal;
  } else if(rID == 4){
    svalues[2] = sVal;
  } else if(rID == 5){
    svalues[3] = sVal;
  } else if(rID == 6){
    svalues[4] = sVal;
  } else if(rID == 7){
    svalues[5] = sVal;
  } else if(rID == 8){
    svalues[6] = sVal;
  } else if(rID == 10){
    svalues[7] = sVal;
  } else if(rID == 12){
    svalues[8] = sVal;
  } else if(rID == 15){
    svalues[9] = sVal;
  } else {
    println("Sensor value not updated! Check the radio ID ");
  }
  // TODO: Add Alicia's Radio
}
