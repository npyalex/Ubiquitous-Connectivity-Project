int radioID = 15; // put your radio number here

void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  Serial1.begin(9600);
}

void loop() {
  // read the input on analog pin 0:
  int pinValue = analogRead(A0); 
  //map the data so it can be turned into a colour by Processing:
  int sensorValue = map(pinValue, 100, 1000, 0, 255); 
  Serial1.print(radioID);
  Serial.print(radioID);
  Serial1.print(",");
  Serial.print(",");
  Serial1.println(sensorValue);
  Serial.println(sensorValue);
  delay(200);        // delay in between reads for stability
}
