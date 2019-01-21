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
int[] sradios = {1,2,4,5,6,7,8,10,12,15}; // array to hold radios that are transmitting to controller
int[] svalues = {0,255,0,255,0,255,0,255,0,255}; // array to hold sensor values - constantly updated

void setup() {
  size(700, 700);
  // List all the available serial ports in the console
  // printArray(Serial.list()); // uncomment this to view your port Amaria

  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  String portName = Serial.list()[0];
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
    int rid = sradios[i]; // The current radio ID
    int sval = svalues[i]; // The current sensor value
    
    // Map the sensor values to range 0 - 255 for RGB color mode. 
    // Map function - val to map, min, max, min val to map to, max val to map to
    float cVal = map(sval,0,1023,0,255); // the new color value
    //color sqCol = color(cVal,cVal,cVal);// Color the squares
    color sqCol = color(cVal,cVal/2,cVal/3);// Color the squares
    
    // Draw the squares at the specified coordinate, using sqSize to control size @maria
    rectMode(CENTER);
    noStroke();
    fill(sqCol);
    int newSize = sqSize - (70 * i); // Generate a smaller size for the next square @maria
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
  
  for (int i =0; i<sradios.length;i++) { // Loop through all radios
    if (rID == sradios[i]) { // if target radio id matches current radio index...
      svalues[i] = sVal;  // set a new value for this radio index
      return; // exit this function
    }
  }
  
  // This will only occur if rID was not found!
  println("Sensor value not updated! Check the radio ID ");
  
  /*
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
  */
}
