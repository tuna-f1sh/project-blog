---
id: 341
title: Ambient Noise Level Indicator
date: 2014-05-12T22:12:58+01:00
author: John
layout: post
guid: /?p=341
permalink: /2014/05/ambient-noise-level-indicator/
image: assets/img/uploads/2014/05/2014-05-14-20.16.55-1000x288.jpg
categories:
  - Electronics
  - Programming
tags:
  - acoustics
  - arduino
  - concept
  - embedded
  - processing
---
As part of my work at MACH Acoustics &#8211; understanding how internal ambient noise levels affect different environments &#8211; I was inspired to create an indicator that shows when noise becomes higher than the base level. [Some solutions already exist](http://www.soundear.com/noise-monitoring-equipment-and-noise-level-measurement/noise-monitoring-equipment-for-hospitals.html) but they are pricey (because they used calibrated sound level meters), and not very engaging. I wanted something that could sit in a classroom and be a friendly indicator for the teachers and students, bringing the noise back down and perhaps learning something in the process!

The solution is a simple RGB led connected to the PWM outputs of an Arduino and uses [Processing](http://www.processing.org/) with the [Minim Library](http://code.compartmental.net/tools/minim/) to perform a FFT on the mic input &#8211; similar to a [couple of other projects](/2013/01/playing-halo-with-an-arduino/ "Light Feedback – Playing Halo with an Arduino").

The operation is best described by the video below and commented code. I&#8217;ve added a handy GUI that allows the user to do a number of things:

* View the mic reading, background sample, instantaneous sample, current colour and sample difference.
* Change the threshold between colours and benchmark colour.
* Set continuous sampling, direct LED/mic feedback
* Resample the background
* Set the frequency band that is used for the amplitude average &#8211; this is useful to demonstrate that it is working and also to ignore low frequency to only show speech for example; screechy children in a classroom!

<figure id="attachment_356" aria-describedby="caption-attachment-356" class="wp-caption aligncenter">
<img loading="lazy" src="/assets/img/uploads/2014/05/Screen-Shot-2014-05-11-at-16.23.16.png" alt="The control panel when the Java applet is running." class="size-full wp-image-356" /><figcaption id="caption-attachment-356" class="wp-caption-text">The control panel when the Java applet is running.</figcaption></figure> 

Its only a prototype concept at the moment. I&#8217;d like to design an enclosure that would suit the particular environment, such as a glowing star or dragon for a classroom.

```c
**
RGB Sound Feedback 

This script takes a sample of the background noise as a base level, then compares to a rolling sample period. An RGB level is
cycled through a colour system to denote the difference in the sampled background level and the current level, to illustrate
when noise levels are higher than they were before.

John Whittington - March 2014
@j_whittington

**/

import processing.serial.*; 
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;
import controlP5.*;

ControlP5 cp5;
Minim minim;
AudioInput in;
Arduino a;
FFT fft;

//Adrduino Pins
int GreenPin =  5;    // Green Pin
int RedPin =  6;    // Red Pin
int BluePin =  3;    // Blue Pin

//Variables
int RED, GREEN, BLUE; 
int RED_A = 0, GREEN_A = 0, BLUE_A = 0;

//Working numbers
//int amp = 100; //amplication level (best for linear)
int amp = 50; //amplication level (best for fade)
int leq = -1, leq30 = 0, leqTot = 0, leq30Tot = 0; //sound level containers
int sample = 1, sample30 = 1; //number of samples for average calc
int cscale = 1; //preset colour
int diff = 0; //level difference
int cBase = 0;
int cDiv = 5;

//Time Values
long timer_sample = 10000;
long timer_30 = 0;
long fade = 0;

//Control P5
CheckBox checkbox;
Button button;
Slider abc;
Range range;
//int myColorBackground;
 
void setup()
{
  size(700, 400);
  
  //----- Control P5 GUI Setup --------
  cp5 = new ControlP5(this);
  checkbox = cp5.addCheckBox("checkBox")
                .setPosition(100, 200)
                .setColorForeground(color(120))
                .setColorActive(color(255))
                .setColorLabel(color(255))
                .setSize(40, 40)
                .setItemsPerRow(1)
                .setSpacingColumn(30)
                .setSpacingRow(20)
                .addItem("continous background", 0)
                .addItem("direct LED/amp", 50)
                ;
                  // create a new button with name 'buttonA'
  button = cp5.addButton("newSample")
     .setValue(0)
     .setPosition(100,320)
     .setSize(80,40)
     ;
     
  cp5.addSlider("cBaseSlider")
   .setPosition(400,50)
   .setSize(200,20)
   .setRange(-50,50)
   .setValue(cBase)
   ;
    
   
   cp5.addSlider("cDivSlider")
   .setPosition(400,100)
   .setSize(200,20)
   .setRange(1,50)
   .setValue(5)
   ; 
   
   range = cp5.addRange("rangeController")
           // disable broadcasting since setRange and setRangeValues will trigger an event
           .setBroadcast(false) 
           .setPosition(400,200)
           .setSize(200,40)
           .setHandleSize(10)
           .setRange(0,20000)
           .setRangeValues(100,5000)
           .showTickMarks(true)
           .snapToTickMarks(true)
           .setNumberOfTickMarks(20)
//           .setDecimalPrecision(1)
           // after the initialization we turn broadcast back on again
           .setBroadcast(true)
           .setColorForeground(color(255,40))
           .setColorBackground(color(255,40))  
           ;
   
  //--------P5 End--------------------  
  
  minim = new Minim(this);
  minim.debugOn();
 
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);
  
  //fft
  fft = new FFT(in.bufferSize(),in.sampleRate());
  fft.logAverages(64,2); //octaves 64,128,256,512,1024...
  
  //println(Arduino.list());
  
  //Arduino configure
  a = new Arduino(this,Arduino.list()[6], 57600);
  a.pinMode(GreenPin, Arduino.OUTPUT);    
  a.pinMode(RedPin, Arduino.OUTPUT);  
  a.pinMode(BluePin, Arduino.OUTPUT);
  a.analogWrite(RedPin,0);
  a.analogWrite(BluePin,0);
  a.analogWrite(GreenPin,0);
}
 
void draw()
{  
  //Paint java applet to display
  background(0);
  stroke(255);
  
  //Apply forward fast fourier transform to mic input
  fft.forward(in.mix);
   
  //Mic input is log average amplitude between 64.5Hz and 4.4kHz by default
  //GUI slider allows this band to change
  int micAvg = round((fft.calcAvg(range.getLowValue(),range.getHighValue())*amp));
  //Used for simple linear brightness control
  int ledBright = constrain(micAvg,0,255);
  
  //Reset sample if button pressed
  if (button.isPressed()) {
    leq = -1;
    timer_sample = millis() + 10000;
    sample = 0;
    leqTot = 0;
    cscale = 1;
    LEDoff();
  }
  
  leqTot = leqTot + micAvg;
  //If continous background selected, the background is an average sound
  //level for the total sample since start
  if (checkbox.getArrayValue()[0] == 1) {
    leq = leqTot/sample;
  }
  //Sample period check for background levels
  else if (millis() - timer_sample >= 0 & leq &lt; 0) {
    leq = leqTot/sample;
    cscale = 1;
  }
  if (millis() - timer_30 >= 1000) {
    timer_30 = millis();
    leq30 = leq30Tot/sample30;
    sample30 = 1;
    leq30Tot = 0;
  }
  else {
    leq30Tot = leq30Tot + micAvg;
    sample30++;
  }
  sample++;
  
  //If we've got the background set the colour according to difference
  if (leq != -1) {
    //Find change in current Leq to sampled
    diff = leq30-leq;
    //Scale the difference to a colour
    cscale();
  } 
  //If we're till sampling, fade through RGB
  else {
    if (cscale &lt; 6 &#038; millis() - fade >= 100) {
      cscale++;

      fade = millis();
    } 
    else if (millis() - fade >= 100) {
      cscale = 1;
      fade = millis();
    }
  }

  //Is linear brightness checked?  
  if (checkbox.getArrayValue()[1] == 1) {
     a.analogWrite(BluePin, ledBright);
     a.analogWrite(RedPin, 0);
     a.analogWrite(GreenPin, 0);
     amp = 100; //Higher amp for linear brightness
  } else {
  //Set the scale as an RGB colour analogue value
  colour();
  //Send the colour to LED fader
  led();
  amp = 50;
  }
  
  //Log value to text display
  text("Mic",50,50);  
  text(micAvg,50,100);
  text("BGrd",100,50);
  text(leq,100,100);
  text("Crnt",150,50);
  text(leq30,150,100);
  text("CScale",200,50);
  text(cscale,200,100);
  text("Delta",250,50);
  text(diff,250,100);
  
  text("Base Threshold Difference",400,40);
  text("Colour Scale Resolution",400,90); 
}
 
 
void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
 
  super.stop();
}

public void cscale() {
  if (diff &lt; cBase - cDiv) { cscale = 0; } // white - under background
  if (diff > cBase - cDiv) { cscale = 1; } // light blue - less than sample
  if (diff > cBase + cDiv) {cscale =  2; } // blue - slightly above
  if (diff > cBase + (2*cDiv)) { cscale = 3; } // purple - getting louder
  if (diff > cBase + (3*cDiv)) { cscale = 4; } // yellow - louder
  if (diff > cBase + (4*cDiv)) { cscale = 5; } // orange - nearing top
  if (diff > cBase + (5*cDiv)) { cscale = 6; } // red - a lot greater than sample background
}

public void colour() {
  if(cscale == 2){ //blue
    RED = 0;
    GREEN = 0;
    BLUE = 255;
  } else if(cscale == 6){ //red
    RED = 255;
    GREEN = 0;
    BLUE = 0;
  } else if(cscale == 0){ //white
    RED = 255;
    GREEN = 255;
    BLUE = 255;
  } else if(cscale == 5){ //orange
    RED = 255;
    GREEN = 186;
    BLUE = 0;
  } else if(cscale == 1){ //light blue
    RED = 0;
    GREEN = 168;
    BLUE = 255;
  } else if(cscale == 3){ //purple
    RED = 255;
    GREEN = 0;
    BLUE = 255;
  } else if(cscale == 4){ //yellow
    RED = 255;
    GREEN = 255;
    BLUE = 0;
  }
}

void led()
{

  //Check Values and adjust "Active" Value
  if(RED != RED_A){
    if(RED_A > RED) RED_A = RED_A - 1;
    if(RED_A &lt; RED) RED_A++;
  }
  if(GREEN != GREEN_A){
    if(GREEN_A > GREEN) GREEN_A = GREEN_A - 1;
    if(GREEN_A &lt; GREEN) GREEN_A++;
  }
  if(BLUE != BLUE_A){
    if(BLUE_A > BLUE) BLUE_A = BLUE_A - 1;
    if(BLUE_A &lt; BLUE) BLUE_A++;
  }

  //Assign modified values to the pwm outputs for each colour led
  a.analogWrite(RedPin, RED_A);
  a.analogWrite(GreenPin, GREEN_A);
  a.analogWrite(BluePin, BLUE_A);

}

void LEDoff() {
  a.analogWrite(RedPin, 0);
  a.analogWrite(GreenPin, 0);
  a.analogWrite(BluePin, 0);
  RED_A = 0; GREEN_A = 0; BLUE_A = 0;
}

//Control P5 GUI Stuff

void keyPressed() {
  if (key==' ') {
    checkbox.deactivateAll();
  } 
  else {
    for (int i=0;i&lt;2;i++) {
      // check if key 0-1 have been pressed and toggle
      // the checkbox item accordingly.
      if (keyCode==(48 + i)) { 
        // the index of checkbox items start at 0
        checkbox.toggle(i);
      }
    }
  }
}

void cBaseSlider(int theValue) {
  cBase = round(theValue);
}

void cDivSlider(int theValue) {
  cDiv = round(theValue);
}
```
