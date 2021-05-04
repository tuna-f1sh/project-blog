---
id: 64
title: Musical Colours Update
date: 2012-08-23T16:47:44+01:00
author: John
layout: post
guid: /?p=64
permalink: /2012/08/musical-colours-update/
image: assets/img/uploads/2012/08/2012-08-23-14.57.20.jpg
categories:
  - Modification
tags:
  - arduino
  - binary
  - temperature
  - van
---
I finally got around to completing my [musical colours project](/2012/06/musical-rainbows-in-the-van/):

* Make the prototype permanent by building a perfboard arduino.

<figure id="attachment_65" aria-describedby="caption-attachment-65" class="wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-65" title="Musical Colours Control Box" src="/assets/img/uploads/2012/08/2012-08-23-14.57.20.jpg" alt="" /><figcaption id="caption-attachment-65" class="wp-caption-text">Includes the standard 5050 driver and usb to serial connection.</figcaption></figure> 

I wanted to keep the standard 5050 controller for general van lighting, controllable by the IR remote. I did this by using another transistor as a switch for the 12v line into the controller. One of the routines in the code then pushes the gate high to turn the controller on.

* Put everything in a project box, with usb, audio passthrough, IR input and push button to cycle routines. 

[<img loading="lazy" class="aligncenter size-large wp-image-69" title="Musical Colours Box" src="/assets/img/uploads/2012/08/2012-08-26-15.16.11.jpg" alt="" />](/assets/img/uploads/2012/08/2012-08-26-15.16.11.jpg)  

The button is connected to an `interrupt`, which is used in a `switch case` to change output: original 5050 controller, musical colours, temperature colours (see below).

* I added a temperature diode &#8211; because I had one lying around &#8211; for a &#8216;temperature colours&#8217; function.The function works by: 
    * Detecting the temperature as a voltage.
    * Translating this into a temperature in degC.
    * Converting this to a 5 bit binary word (max temperature of 32deg).
    * Displaying the binary word using the LED strip (MSB first): red 1, blue 0, 1s duty cycle
    * Displaying a constant analogue colour depending on the temperature.
