---
id: 945
title: 'Nixie Pipe &#8211; Modern Day LED Nixie Tube'
date: 2016-12-14T13:40:16+00:00
author: John
layout: post
guid: /?p=945
permalink: /2016/12/nixie-pipe-modern-day-led-nixie-tube/
image: assets/img/uploads/2016/12/Nixie-Pipe-Design-Blog-825x510.png
categories:
  - Electronics
  - Fabrication
  - Mechanical
  - Programming
tags:
  - acrylic
  - CAD
  - clock
  - embedded
  - laser cut
  - LED
  - pcb
  - ws2812
---
Nixie Pipe is my interpretation of a modern day Nixie Tube &#8211; the cold-cathode <del datetime="2016-12-03T17:07:49+00:00">vacuum</del> gas-filled tubes from the 1960s.

<div class="box">
<iframe width="560px" height="315px" src="https://www.youtube.com/embed/2T2dwJ4tU8w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

The project came about when I decided to make a clock for my kitchen, with specific requirement for an egg timer function! I&#8217;ve always wanted to make a Nixie Tube clock but having completed a [Nixie Tube](/2015/12/nixie-tube-energy-meter/) project recently and one pipe failing after around 6,000 hours, I wanted to come up this something better. Something that didn&#8217;t require high voltages, special driving circuitry, could be easily interfaced and was modular, but which maintained the unique visual depth of a Nixie Tube.

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2016/12/fullsizeoutput_1a9e.jpeg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-29-1023" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-29-1023'> This unit salvaged from a telephone exchange confirmed that a engraved light pipe technique would work. </figcaption></figure>
<figure class='gallery-item'> 
<img src="/assets/img/uploads/2016/12/IMG_2318.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-29-1022" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-29-1022'> It&#8217;s depth is due to the filament bulbs used for illumination. With LEDs available now, I was able to refine the concept into a much smaller package. </figcaption></figure>

At around the same time, my dad showed me the above from an old telephone exchange. It&#8217;s a 70s way of displaying digits by using engraved light pipes, lit by channeling emission from filament bulbs within. Putting the two together, Nixie Pipe is the design I came up with. I&#8217;ve called it Nixie Pipe because it uses _light pipes_. Each Nixie Pipe contains ten individually controlled RGB LEDs, which sit below channelled layers of acrylic acting as light pipes. By laser engraving the acrylic layers, the piped light diffracts, creating controlled illumination.

Nixie Pipes are modular and can be chained together to form displays. A _Master_ module features an AVR Atmega328p microcontroller allowing it to drive _Slave_ units, which only features LEDs. The pipes connect via three pins and inter-locking nodes on the rear. It means the pipes are constrained enough to require no further fixing. The _Master_ also features a USB serial converter and I2C breakout, allowing a host computer or chip to drive the Nixie Pipe array with dynamic content &#8211; using either the [Python package](https://github.com/tuna-f1sh/py-nixiepipe) , [Node.js module](https://github.com/tuna-f1sh/node-nixiepipe) or [Electron GUI](https://github.com/tuna-f1sh/electron-nixiepipe) I developed. The LEDs are WS2812B, which operate on the single wire interface so _Slaves_ can be directly driven by any external microcontroller such as an Arduino.

You might be wondering what the pills on the front are for. They are touch buttons on the _Master_ pipe, which allow control of the clock for instance or just incrementing or decrementing the display. My main design requirement was an egg timer after all and without a means to set and start a timer the design would not be self-contained.

Using the Atmega328p lead to me create a fully compatible [Arduino library API](https://github.com/tuna-f1sh/NixiePipe) for controlling the Nixie Pipe, either for creating custom _Master_ firmware for external driving with another microcontroller; I did much of my development using an Arduino connected via the three input wires to Nixie Pipes for ease of programming &#8211; a key stage in developing products is having an easy to use test bed.

# Design Development

## Ideas

  * Use engraved light pipe technique from telephone exchange module but using LEDs. The space saved would allow lighting directly from the button without any bending and a much more complex form.
  * Modular design 0-9 per module allowing display of _any_ number size.
  * Self-contained with no requirement for external driver.
  * Single module with microcontroller driving dumb modules.
  * Symbols as well as digit.
  * User IO on the main module.

## Prototyping

The development took around 4 months on and off before coming to my final design. There were lots of small refinements mechanically and electronically along the way, but below is a brief summary.

### Basic Feasibility

First thing I did was cut some layers, engraved them, then lit them from below. The basic principle worked so I went ahead.

[![](http://i.imgur.com/UXJKV3Z.gif "source: imgur.com")](http://imgur.com/UXJKV3Z)

### Hardware

<figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/12/IMG_2310.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-30-1013" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-30-1013'> My initial design was a self-enclosed box holding the acrylic layers and pcb. It was ugly and too cumbersome. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/12/fullsizeoutput_1a9f.jpeg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-30-1027" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-30-1027'> Prototypes in a line. There were obviously more changes along the way but this photo shows the main physical design changes. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/12/IMG_2019.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-30-1026" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-30-1026'> I experimented with acrylic paint to &#8216;black out&#8217; the exposed layers. It didn&#8217;t really help increase clarity but did make the display dimmer. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/12/fullsizeoutput_1aa0.jpeg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-30-1028" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-30-1028'> I developed an mechanical joint to vertically constrain the modules and prevent the electrical connection taking all the *physical* load. With both vertical and horizontal joints, the modules are well fixed but can be easily pulled apart. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/12/Screen-Shot-2016-12-15-at-08.17.44.png" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-30-1081" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-30-1081'> I used OpenSCAD for the mechanical design as it allows easy exporting of 2d DXF and the spacing of the LEDs owed to variable based design. </figcaption></figure>

My initial design was enclosure based with the layers &#8216;wedged&#8217; inside on top of a PCB. It was all a bit bulky, cumbersome and not very elegant. I ditched the sides, tooth/dent construction and went for a design whereby the layers are clamped together, with slots to suspend the PCB below. The mechanical design remained largely untouched after that, other than addition of strain relief around the slotting and the inter-locking nodes.

### Electrical

<figure id="attachment_1015" aria-describedby="caption-attachment-1015" style="class=wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-1015" src="/assets/img/uploads/2016/12/IMG_2175-1024x768.jpg" alt="I had four PCB iterations before coming to my final design. Mostly small functional changes other than adding the forgotten zero LED." srcset="/assets/img/uploads/2016/12/IMG_2175-1024x768.jpg 1024w, /assets/img/uploads/2016/12/IMG_2175-300x225.jpg 300w, /assets/img/uploads/2016/12/IMG_2175-768x576.jpg 768w" /><figcaption id="caption-attachment-1015" class="wp-caption-text">I had four PCB iterations before coming to my final design. Mostly small functional changes other than adding the forgotten zero LED.</figcaption></figure> 

  1. **PCB 1.0**: The design worked great with only one issue&#8230;I forgot a zero!! Funny how double checking the design a million times one misses the obvious. My mind was obviously still in [binary clock](/2014/12/wooden-bits-binary-clock/) mode, assuming off would be zero &#8211; I quickly realised that wouldn&#8217;t be obvious enough and just looked like I&#8217;d forgotten a zero&#8230;
  2. **PCB 1.1**: I got rid of the QFN package because I was hand-soldering prototypes and added one more LED for zero. 45deg skew on the QFP actually made the routing easier due to space in the middle.
  3. **PCB 1.2**: Regulator on-board went (not sure what I was thinking) and since the current was low (< 500mA) I opted for micro USB connector rather than terminal block. This made connection and power availability much more friendly.
  4. **PCB 1.3**: With the USB interface, why not add USB serial so that the display can be set via a host? On went an FTDI FT230XS USB serial. 1.2 did actually have USB D+/- going to INT. pins on the Atmega328p as I had intention of using [VUSB](https://www.obdev.at/products/vusb/index.html) rather an a USB serial. Once I got a basic firmware enumerating however, I decided the additional development time and potential driver issues weren&#8217;t worth the saving over using a USB serial converter IC.

### Software

I got quite carried away with the software side and ended up developing four code projects! They came in logical phases:

#### 1. Hardware Driver

I started with an [Arduino compatible C++ Nixie Pipe class](https://github.com/tuna-f1sh/NixiePipe). Time spent being thorough here proved invaluable when it came to developing the high language APIs.

The class uses the [FastLED library](https://github.com/FastLED/FastLED) to manage the daisy chained WS2812B on each Nixie Pipe PCB. The LEDs are split into &#8216;pipes&#8217; using pointer offset addressing of 10 LEDs. Each pipe can then index the correct LED index for the current number to be displayed. The class manages the current display number and colour for easy updating.

Pipes are `set` (display number, colour changed) prior to manipulation of the LED array using `write`. Reasoning behind this is to allow an array of pipes to be setup prior to the FastLED array changing. This allows fading and rainbow effects on the complete pipe array.

#### 2. Python Package

For quick scripting I made a [Python class](https://github.com/tuna-f1sh/py-nixiepipe) that interfaces with the firmware using SYS_EX like commands. I actually developed the interrupter firmware and Python package in parallel so you could call that five code projects!

```python
import nixiepipe

# Create pipe object from nixiepipe class. Will auto find serial port using device descriptor
pipe = nixiepipe.pipe()

pipe.setNumberUnits(0) # Set number of Nixie Pipe Unit modules
pipe.setColour(0,0,255) # Set array colour blue
pipe.setNumber(9999) # Set array number to 9999

# Write and show new settings
pipe.show()
```

#### 3. [Node Module](https://github.com/tuna-f1sh/node-nixiepipe)

I started looking at making a GUI as most people I showed the Nixie Pipes to loved it but had no knowledge of programming. [Electron](http://electron.atom.io/) caught my eye and having first considering using it with a Python backend, I decided against mixing the two and so ported my Python class to Node. My Node was a bit rusty having not developed with it for a few years so it ended up being the perfect refresher.

```javascript
var pipes = new NixiePipe();

pipes.once("connected", function() {
pipes.setNumber(9999); // Set array number 9999
pipes.setColour(0,0,255); // Set blue
pipes.show(); // Write and set new settings
pipes.getNumber( function() { console.log(pipes.number); }); // Return display number
});
```

#### 4. Electron App

<figure id="attachment_1078" aria-describedby="caption-attachment-1078" style="class=wp-caption aligncenter" >
<img loading="lazy" class="wp-image-1078 size-full" src="/assets/img/uploads/2016/12/screenshot.png" srcset="/assets/img/uploads/2016/12/screenshot.png 912w, /assets/img/uploads/2016/12/screenshot-300x201.png 300w, /assets/img/uploads/2016/12/screenshot-768x515.png 768w" /><figcaption id="caption-attachment-1078" class="wp-caption-text">I put this app together over a weekend to trial Electron development. I&#8217;ll be using it again in the future.</figcaption>
</figure>

With the Node module developed, I went to work making an [Electron app](https://github.com/tuna-f1sh/electron-nixiepipe) &#8211; having not used Electron before I saw it as the project as the perfect test bed. The experience only took a couple of days as I&#8217;m familiar with web design methods and Javascript. Overall I was impressed with Electron and would use it again.

## Demo Video

<div class="box">
<iframe width="560px" height="315px" src="https://www.youtube.com/embed/kQZ-W9qw2LU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Thanks for reading. If you like the Nixie Pipes, I&#8217;m [selling a limited number through my shop](http://shop.jbrengineering.co.uk/product-category/nixie-pipe/). I&#8217;m currently making them myself but if interest is high may run a Kickstarter to outsource production. If you know what you&#8217;re doing, you can [download the project files](https://github.com/tuna-f1sh/nixiepipe-hardware) and build one yourself. All aspects of the project are licensed under GPL 3.0.
