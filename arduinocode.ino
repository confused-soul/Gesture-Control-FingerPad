void setup() {
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  pinMode(A5, INPUT);
  Serial.begin(115200);
}

void loop() {
  //taking readings
  int l1 = analogRead(A1);
  int l2 = analogRead(A2);
  int l3 = analogRead(A3);
  int l4 = analogRead(A4);
  int l5 = analogRead(A5);

  //printing
  Serial.print(l1);
  Serial.print("x");
  Serial.print(l2);
  Serial.print("x");
  Serial.print(l3);
  Serial.print("x");
  Serial.print(l4);
  Serial.print("x");
  Serial.print(l5);
  Serial.print("x");
  Serial.print("a");
  
  //delay
  delay(1);
}
