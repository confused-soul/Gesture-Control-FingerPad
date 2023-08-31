#include "SPI.h"
#include "TMRpcm.h"
#include "SD.h"
#define CSP 4

TMRpcm tmrpcm;

void setup() {
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  pinMode(A5, INPUT);
  pinMode(7, INPUT);
  pinMode(8, OUTPUT);
  
  tmrpcm.speakerPin = 9;
  
  Serial.begin(9600);
  
  if(!SD.begin(CSP)){
    digitalWrite(8, HIGH);
  return;
  }

  tmrpcm.setVolume(5);
}

void loop() {
  
  if(digitalRead(7) == LOW){
    while(analogRead(A1)>500 || analogRead(A2)>500 || analogRead(A3)>500 || analogRead(A4)>500){
      delay(100);
      Serial.print("*");
    }
    int t1 = millis();
    while(analogRead(A1)>75 || analogRead(A2)>75 || analogRead(A3)>75 || analogRead(A4)>75){
      delay(100);
      Serial.print("#");
    }
    if(analogRead(A1)<75){
      int t2 = millis();
      int t = (t2-t1);
      Serial.print(t);
      delay(100);
  
      if(t>200){
        settingVolume();
        tmrpcm.play("1.wav");
        Serial.print("a");
        delay(100);
      }
      else{
        settingVolume();
        tmrpcm.play("1a.wav");
        Serial.print("b");
        delay(100);
      }
    }
    if(analogRead(A2)<75){
      int t2 = millis();
      int t = (t2-t1);
      Serial.print(t);
      delay(100);
  
      if(t>200){
        settingVolume();
        tmrpcm.play("2.wav");
        Serial.print("a");
        delay(100);
      }
      else{
        settingVolume();
        tmrpcm.play("2a.wav");
        Serial.print("b");
        delay(100);
      }
    }
    if(analogRead(A3)<75){
      int t2 = millis();
      int t = (t2-t1);
      Serial.print(t);
      delay(100);
  
      if(t>200){
        settingVolume();
        tmrpcm.play("3.wav");
        Serial.print("a");
        delay(100);
      }
      else{
        settingVolume();
        tmrpcm.play("3a.wav");
        Serial.print("b");
        delay(100);
      }
    }
    if(analogRead(A4)<75){
      int t2 = millis();
      int t = (t2-t1);
      Serial.print(t);
      delay(100);
  
      if(t>200){
        settingVolume();
        tmrpcm.play("4.wav");
        Serial.print("a");
        delay(100);
      }
      else{
        settingVolume();
        tmrpcm.play("4a.wav");
        Serial.print("b");
        delay(100);
      }
    }
    tmrpcm.setVolume(5);
    if(analogRead(A5)<75)
      tmrpcm.play("5.wav");
  
    delay(100);
  }
  else{
    if(analogRead(A1)>75)
      tmrpcm.play("d1.wav");
      
    if(analogRead(A2)>75)
      tmrpcm.play("d2.wav");
      
    if(analogRead(A3)>75)
      tmrpcm.play("d3.wav");
      
    if(analogRead(A4)>75)
      tmrpcm.play("d4.wav");
      
    if(analogRead(A5)>75)
      tmrpcm.play("d5.wav");
      
    delay(500);
  }

}

void settingVolume(){
  int th = analogRead(A5);
  if(th>700)
    tmrpcm.setVolume(5);
  if(th>500 && th<700)
    tmrpcm.setVolume(4);
  if(th>300 && th<500)
    tmrpcm.setVolume(3);
  if(th>200 && th <300)
    tmrpcm.setVolume(2);
}
