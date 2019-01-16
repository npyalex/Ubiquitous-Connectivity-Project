/*
 * Sensor Coordinator code was written using the Metronome Coordinator (Processing Code) as reference 
 * DIGF 6003 Ubiquitous Computing - Kate Hartman & Nick Puckett
 * 
 */

import processing.serial.*; // import the Processing serial library
Serial myPort;              // The serial port
int radioID;
int sensorValue;
int[] sradios = {1,2,4,5,6,7,8,10,12,15}; // array to hold radios that are transmitting to controller
int[] svalues = {50,50,50,50,50,50,50,50,50,50}; // array to hold sensor values - constantly updated

void setup() {
  size(800, 800);
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


void draw() {
  background(255);
  int coord = 50; // a variable to increment the next ellipses position onscreen @maria
  
  // Loop through the radios & sensor value arrays to create an ellipse for each radio @maria
  for(int i = 0; i < sradios.length; i++){
    int rid = sradios[i]; // The radio ID
    // Get the corresponding sensor value
    int sval = svalues[i]; // The sensor value
    
    // Draw the ellipses at the specified coordinate, using sval to control size @maria
    ellipseMode(CENTER);
    fill(255);
    ellipse(coord,coord,sval,sval);
    
    // Draw the labels at the ellipse center @maria
    textAlign(CENTER,CENTER);
    fill(0);
    text(rid, coord, coord); 
    coord += 60;
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
