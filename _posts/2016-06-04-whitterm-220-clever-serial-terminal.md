---
id: 888
title: Whitterm-220 Clever Serial Terminal
date: 2016-06-04T11:38:20+01:00
author: John
layout: post
guid: /?p=888
permalink: /2016/06/whitterm-220-clever-serial-terminal/
image: assets/img/uploads/2016/06/DSC_0034-825x510.jpg
categories:
  - Electronics
  - Fabrication
  - Mechanical
tags:
  - concept
  - design
  - featured
  - laser cut
  - raspberrypi
  - rs232
  - serial
  - wood
---
**21/12/18 UPDATE: Hello to Hack a Day readers. This project was shared when I did it but re-posted recently. It is 2.5 years old and there are many things I would do differently. I am considering work on a IO board specific to the project (RS232 driver, GPIO break-out, proper RX/TX LED buffers and potentially internal LiPo UPS). Glad there is renewed interest in the project as I still use it day to day :).**

30/06/19 UPDATE: I did what I was considering! See the updated [WT-220 2.0 here](/2019/06/whitterm-220-2-0/)

The Whitterm-220 (WT-220) is my latest project. It&#8217;s a _clever_ terminal, in the sense that it aims to emulate the dumb terminals of the 80s but with the versatility of something produced now. The name comes from my inspiration for the project: failure to win a [VT-220](https://en.wikipedia.org/wiki/VT220]) on eBay. I decided it would be fun to make a homage to the VT-220, that would actually be useful &#8211; a not so dumb, or _clever_ terminal &#8211; that would do more than simply parsing RS232 levels into Ascii characters.

  <figure class='gallery-item'> 
    <img src="/assets/img/uploads/2016/06/concept-colour.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-24-922" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-24-922'> A rough sketch before going to CAD. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/Assembly-v14-Front.png" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/Assembly-v12-Section.png" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/Assembly-v12.png" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure>

I used this project to experiment with Fusion 360. On the whole it has been good, although I did run into a number of features I&#8217;m used to on other pro CAD packages that are missing. It seems more of a in development tool, where features are added at the request of engineers in desperation upon finding a tool missing! The design is a stepped, laminated wood enclosure, which a screen and RPi assembly attach into. Each layer of plywood is a separate &#8216;sketch&#8217;, that I export to DXF for laser-cutting. You can view [the assembly on Autodesk 360](http://a360.co/1qxSz4C)

  <figure class='gallery-item'> 
    <img src="/assets/img/uploads/2016/06/IMG_1642.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-25-896" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-25-896'> Prior to gluing, I clamped the layers together to see how it looked. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1644.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-25-898" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-25-898'> The laminated steps were created in sections </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1645.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-25-899" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-25-899'> Each step was then glued together. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1653.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-25-901" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-25-901'> The RPi attaches to the screen </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1643.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1651.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-25-900" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-25-900'> Acrylic paint can be used to fill engravings then wiped off. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1678.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-25-905" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-25-905'> I used a MAX3232 breakout board to provide RS232 serial. A steady 5V is provided by an LM2596 </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1677.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure>

Inside this laminated plywood enclosure is a Raspberry Pi 2, booting into Arch linux. Using a Raspberry Pi is what makes it a clever terminal &#8211; it has the serial I/O you&#8217;d get on a dumb terminal but running Linux enables SSH, firmware flashing, development, even a desktop shell. The screen is the official Raspberry Pi 7&#8243; touch screen. It was dearer than other screens but since it uses an FPC connection rather than HDMI, it allowed me to create a bezel-less design.

In terms of IO, I have two DB9 connectors for RS232 level serial and TTL, enabling it to interface with industry kit and microcontroller projects (the RS232 levels are provided by a MAX3232 level shifter). Both connect to the hardware UART of the Pi, providing a reliable serial connection that cannot be obtained with USB adaptors. With the 6 free pins on the TTL DB9, I brought out GPIO from the Pi for internal/external driving of projects. Additionally there are two USB ports and a DC jack connecting to the input of a LM2596 buck converter, providing the Pi with a stable 5V on a range of input voltages.

<figure id="attachment_902" aria-describedby="caption-attachment-902" style="class=wp-caption aligncenter">
<img loading="lazy" class="size-medium wp-image-902" src="/assets/img/uploads/2016/06/IMG_1654.jpg" alt="The three forward most layers sit around the LCD and include RX/TX led indicators, illuminating an acrylic layer sandwiched in the middle." />
<figcaption id="caption-attachment-902" class="wp-caption-text">The three forward most layers sit around the LCD and include RX/TX led indicators, illuminating an acrylic layer sandwiched in the middle.</figcaption>
</figure>

As a power indicator, I sandwiched an acrylic layer with white LEDS at the front, which doubles up as RX and TX activity indicators. These indicators are buffered using a simple Op-Amp circuit (MOSFET would have been better but I had low voltage, rail to rail op-amps to hand), with the ability to force on with a GPIO pin if it becomes distracting.

<figure id="attachment_893" aria-describedby="caption-attachment-893" style="class=wp-caption aligncenter">
<img loading="lazy" class="size-medium wp-image-893" src="/assets/img/uploads/2016/06/Capture.gif" alt="RX and TX are buffered with this circuit to provide the LED indication. A MOSFET would have been better I had op-amps to hand." /><figcaption id="caption-attachment-893" class="wp-caption-text">RX and TX are buffered with this circuit to provide the LED indication. A MOSFET would have been better I had op-amps to hand.</figcaption></figure> 

As I said, it boots into Arch linux, which I&#8217;ve customised to load cool-retro-term &#8211; a terminal CRT emulator. It&#8217;s form over function but I like it. Here&#8217;s HTOP running in CRT

![wt-220 htop gif](http://i.giphy.com/Y2IF5KRg1dRWU.gif) 

To demo the actual purpose of the device &#8211; a serial terminal &#8211; I&#8217;ve created a basic python ping pong script. My Macbook is connected via a TTL serial adaptor and sends &#8216;ping&#8217; every second. The WT-220 waits for ping then sends pong back. Both print the send/receive to the term.

  <figure class='gallery-item'> 
    <img src="/assets/img/uploads/2016/06/DSC_0034.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/DSC_0030.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/DSC_0026.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/DSC_0031.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/DSC_0046.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/DSC_0053.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
  </figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2016/06/IMG_1695.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-26-914" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-26-914'> Being used for it&#8217;s sole purpose, talking to a serial device in development! </figcaption></figure>
