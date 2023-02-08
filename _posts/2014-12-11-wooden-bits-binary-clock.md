---
id: 487
title: 'Wooden Bits &#8211; Binary Clock'
date: 2014-12-11T09:44:44+00:00
author: John
layout: post
guid: /?p=487
permalink: /2014/12/wooden-bits-binary-clock/
image: assets/img/uploads/2014/12/concept.jpg
categories:
  - Electronics
  - Fabrication
  - Mechanical
  - Programming
  - Clock
tags:
  - arduino
  - c
  - CAD
  - design
  - embedded
  - featured
  - laser cut
  - raspberrypi
  - wood
  - ws2812
---

![Wooden Bits Gif](http://i.imgur.com/n8bL5TM.gif)

I&#8217;ve been meaning to make a binary wall clock for a while and to also try out [kerf bending](https://www.google.co.uk/search?q=kerf+bend&espv=2&biw=1920&bih=1139&source=lnms&tbm=isch&sa=X&ei=tnSIVKGhH8O9Ue2MgOgC&ved=0CAYQ_AUoAQ) with the laser cutter. What put me off creating kerf bends before I found [OpenSCAD](http://www.openscad.com), was the manual creation of all the lines in the right places. It&#8217;s the kind of repetitive, uniform task computers were made to do.

# Design

<figure id="attachment_515" aria-describedby="caption-attachment-515" class="wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-515" src="/assets/img/uploads/2014/12/wooden-bits.jpg" alt="My idea sketched out" /><figcaption id="caption-attachment-515" class="wp-caption-text">My idea sketched out</figcaption></figure> 

Above was what I wanted to create; a square matrix formed from one length of plywood, with the curves creating some organic interest to an otherwise boring shape. I opened Vim and started away in lines of _OpenSCAD_.

<img loading="lazy" class="aligncenter size-large wp-image-505" src="/assets/img/uploads/2014/12/Untitled.png" alt="Wooden Bits Print Sheet" />

I ended up creating script that could create a one-piece design but would also split the length into divisions. I did this because the length was too big for the cutter bed. For the initial build, each (of four rows) row is separate and then they are all glued together.  If I make another I&#8217;ll add a _dovetail_ so that each section can be joined, it&#8217;s more complicated because you have to alternate the teeth/dents on the middle male components.

# Make

There was some tweaking involved of the kerf spacing to get it strong yet bendable but overall it was a relatively pain-free construction.

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2014/12/IMG_0892.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-11-511" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-11-511'> Sections laid out on the bench during construction. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/IMG_0889.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-11-513" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-11-513'> One of the rows complete. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/IMG_0890.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-11-512" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-11-512'> I created the rows of pixels in 4 LED chains then connected them once in the clock. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/IMG_0893.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-11-510" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-11-510'> All wired up with only the acrylic diffusers to install </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/IMG_0894.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-11-509" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-11-509'> The components sit in the bottom left corner </figcaption></figure>

# Electronics

<del datetime="2016-10-30T08:37:03+00:00">The controller is an Arduino Micro with a <a href="http://www.ebay.co.uk/itm/DS1307-I2C-RTC-AT24C32-Real-Time-Clock-Board-Module-Arduino-ARM-PIC-UK-SELLER-/400851057029?pt=LH_DefaultDomain_3&hash=item5d5495b985">DS1307 RTC module</a> and the W2812B LED chain connected to pin 6.</del>

**UPDATE** I have now created a custom PCB, the size of a single cell.

<img loading="lazy" class="aligncenter size-medium wp-image-949" src="/assets/img/uploads/2014/12/wooden-bits.png" alt="wooden-bits" />



# Code

### Features

  * Version for Arduino/Attiny328 and Raspberry Pi.
  * Scales to any size WS2812 matrix.
  * Ability to rotate display.
  * Ability to set second indicator pulsing.
  * Quarter hour indicator fills n/quarter rows of the display blue (n is the  
    quarter multiple).
  * Full rainbow and midday and midnight.
  * `setMatrix` for sending any binary size to display; not just time.
  * `initMatrixMap` for creating lookup map of display.

I had a quick Google for Arduino binary clock code and the top hits weren&#8217;t all the elegant. They employed a brute force method of creating `if`/`else` for each digit possibility and resulting GPIO set. Due to this they couldn&#8217;t scale beyond their original project.

My method is to create an 4 element array of binary nibbles, one for each clock digit. 13:40 would look like this:

```assci
{0}{1}{2}{3}
[0][0][0][0]
[0][0][1][0]
[0][1][0][0]
[1][1][0][0]
```

One can then loop through each binary nyble and use a bit-shift on each bit to set the pixel on or off (there are twice as many `for` to allow the clock to scale and fill any size matrix):

```c
uint8_t x; // row inc.
  uint8_t y; // height inc.
  uint8_t i; // binary set matrix
  uint8_t yy; // full column inc.
  uint8_t xx = 0; // full row inc.

  for ( i = 0; i < size; i++) {
    for (yy = 0;yy < PIXEL_COLUMN; yy += height) {
      for (y = 0; y < height; y++) {
        for (x = 0; x < {
          if (x == 0 && y == 0) {
            setPixel(pixelMap[xx+x][yy+y],((bMatrix[i] >> yy/height) & 1),color1);
          } else {
            setPixel(pixelMap[xx+x][yy+y],((bMatrix[i] >> yy/height) & 1),color2);
          }
        }
      }
    }
    xx += 
```

Wiring an LED matrix creates a _snakes and ladders_ index, which is hard to reference without a map. The pixelMap is created like so:

```c
uint8_t i; // row inc.
  uint8_t j; // column inc.
  uint16_t pixel_inc; // pixel number inc.

  /* What we're trying to draw (64 pixel unicorn hat grid) */
  /* It's a snakes and ladders type arrangement for any matrix */
  /*   {7 ,6 ,5 ,4 ,3 ,2 ,1 ,0 },*/
  /*   {8 ,9 ,10,11,12,13,14,15},*/
  /*   {23,22,21,20,19,18,17,16},*/
  /*   {24,25,26,27,28,29,30,31},*/
  /*   {39,38,37,36,35,34,33,32},*/
  /*   {40,41,42,43,44,45,46,47},*/
  /*   {55,54,53,52,51,50,49,48},*/
  /*   {56,57,58,59,60,61,62,63}*/
  /* */

  // The cord either starts at 0 or length of row depending on whether it's rotated
  pixel_inc = rotate ? PIXEL_ROW : 0;

  for (i = 0; i < PIXEL_COLUMN; i++) {
    for (j = 0; j < PIXEL_ROW; j++) {
      // We either increment or decrement depending on column due to snakes and ladders arrangement
      if (rotate) {
        pixelMap[i][j] = (i % 2 == 0) ? --pixel_inc : ++pixel_inc;
      } else {
        pixelMap[j][i] = (i % 2 != 0) ? pixel_inc-- : pixel_inc++;
      }
    }
    pixel_inc += PIXEL_ROW;
    (i % 2 == 0) ? pixel_inc-- : pixel_inc++;
  }
```

The binary nybles are created using bit-wise comparison on the decimal digit. For the power of ten times, one has to do a extract each digit using a mix of flooring and division/multiplication:

```c
// convert the time into 4 nybles for each column of matrix
  if (hour >= 0 && hour < 10) { bTime[1] = hour | 0b0000; bTime[0] = 0b0000; // 2nd digit still needs clearing } else { bTime[1] = (uint8_t) (hour-(floor(hour/10)*10)) | 0b0000; bTime[0] = (uint8_t) (floor(hour-(hour-floor(hour)))/10) | 0b0000; } if (minute >= 0 && minute < 10) {
    bTime[3] = minute | 0b0000;
    bTime[2] = 0b0000; // 2nd digit still needs clearing
  } else {
    bTime[3] = (uint8_t) (minute-(floor(minute/10)*10)) | 0b0000;
    bTime[2] = (uint8_t) (floor(minute-(minute-floor(minute)))/10) | 0b0000;
  }
```

The code is on GitHub: [**https://github.com/tuna-f1sh/wooden-bits**](https://github.com/tuna-f1sh/wooden-bits)

# Raspberry Pi

<div class="box">
<iframe width="560" height="315" src="https://www.youtube.com/embed/NP-Fatqpo6w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

After I&#8217;d completed it I felt like porting it to the Raspberry Pi and [Pimoroni&#8217;s Unicorn Hat](http://shop.pimoroni.com/products/unicorn-hat). I was already using the [Arduino Make](https://github.com/sudar/Arduino-Makefile) Makefile so had a header with declarations unlike most Arduino projects. The main changes were the GPIO functions to actually set the matrix. Thankfully a [WS2812 Driver](https://github.com/626Pilot/RaspberryPi-NeoPixel-WS2812) exists with the same functions as the _NeoPixel_ library, so the task wasn&#8217;t all the difficult. Rather than referencing the _pixels_ object, the functions are directly called since it&#8217;s straight C.

Because the _Unicorn Hat_ is an 8&#215;8 (twice the size of mine), it allowed me to ensure the code scaled to any size matrix and the process created improvements that I carried back to the Arduino code.

# Result

<div class="box">
<iframe width="560" height="315" src="https://www.youtube.com/embed/H8aTMaAC5_s" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

I&#8217;m pleased with the result. The clock is stable and has so far been running for days without issue. It&#8217;s a Christmas present for the lab but my parents want one too so I&#8217;ll make another. The next one will be one piece with _dovetail_ joints between sections amongst other points I&#8217;d like to improve on:

  * Clock set routine invoked from tactile switch or even better a hand wave across one of the cells (the one with the controller in).
  * Alarm routine that can be remotely set via phone app &#8211; I&#8217;d use a bluetooth module for this.

_UPDATE:_ [I&#8217;ve added both!](/2015/05/setting-wooden-bits-via-ble-and-esp8266/)

### [Click if you like what you see and want to buy one.](https://shop.jbrengineering.co.uk/product/wooden-bits-binary-wall-clock/)

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2014/12/DSC_0034.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0035.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0036.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0030.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-12-523" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-12-523'> 08:33 </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0037.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-12-527" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-12-527'> 08:36 </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0043.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-12-529" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-12-529'> 07:59 </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0039.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-12-528" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-12-528'> 07:59 </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0044.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-12-530" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-12-530'> Full blue rows on the hour for 10s </figcaption></figure>

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2014/12/DSC_0048.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0009.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0018.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0027.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-13-641" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-13-641'> Pressing the tactile button runs an ISR that flags a setting routine. The display goes red and pressing the button increments the minutes. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2014/12/DSC_0033.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-13-640" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-13-640'> Rainbow colours! </figcaption></figure>
