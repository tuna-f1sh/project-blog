---
id: 16
title: Musical Rainbows in the Van
date: 2012-06-25T14:02:47+01:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=16
permalink: /2012/06/musical-rainbows-in-the-van/
image: assets/img/uploads/2012/06/IMG_1169-1000x288.jpg
categories:
  - Electronics
  - Fabrication
  - Programming
tags:
  - arduino
  - LED
  - music
---
I always intended on creating my own driver for the [LED lights in my van](http://blog.john-whittington.co.uk/post/18995881368/bringing-big-things-to-races-in-2012) but with the [thieving skum](http://road.cc/content/news/59681-thieves-target-bristol-pro-cyclist-and-roadcc-tester-steal-high-end-road-and-mtb) pointlessly taking the remote for the included unit, I was spurred into action. Having installed a sound system, a musical light system was a given, to enable the van to live up to the Bang Bus name it has acquired (of certain definition!).  
<!--more--><figure id="attachment_211" aria-describedby="caption-attachment-211" style="width: 584px" class="wp-caption aligncenter">

<a href="http://engineer.john-whittington.co.uk/2012/06/musical-rainbows-in-the-van/musicalcolours_bb-2/" rel="attachment wp-att-211"><img loading="lazy" class="size-large wp-image-211" src="http://engineer.john-whittington.co.ukassets/img/uploads/2012/06/MusicalColours_bb1-1024x590.jpg" alt="Figure 1: Circuit diagram. Transistor amp on left of breadboard is only used for non-serial musical display, to boost audio input to Arduino (can use it for serial too as preamp). Transistors on the right are used to drive the RGB strip from the 12V DC. If you are just using a few LEDs you don’t need this either." width="584" height="336" srcset="/assets/img/uploads/2012/06/MusicalColours_bb1-1024x590.jpg 1024w, /assets/img/uploads/2012/06/MusicalColours_bb1-300x172.jpg 300w, /assets/img/uploads/2012/06/MusicalColours_bb1-500x288.jpg 500w" sizes="(max-width: 584px) 100vw, 584px" /></a><figcaption id="caption-attachment-211" class="wp-caption-text">Figure 1: Circuit diagram (updated Jan.13). Transistor amp on left of breadboard is only used for non-serial musical display, to boost audio input to Arduino (can use it for serial too as preamp). Transistors on the right are used to drive the RGB strip from the 12V DC. If you are just using a few LEDs you don’t need this either. [Here&#8217;s the .fzz](http://www.john-whittington.co.uk/MusicalColours.fzz)</figcaption></figure> 

## Stand Alone Arduino

I started out looking at taking the analogue voltage variation created by music, analysing it in some way, then using it as an output for the LEDs. &#8216;In some way&#8217; was the issue here, I hadn&#8217;t really considered what I could do with on a small microcontroller. I thought maybe I could look for spikes of a beat or get the frequency but that was becoming too complex for the Arduino. I decided I would take the signal amplitude and simply translate it to LED brightness so you still see the beat in effect but it wouldn&#8217;t take advantage of the RGB.

What to do with the signal was the least of my problems as I quickly found the analogue inputs aren&#8217;t sensitive enough to take a audio signal. A quick delve into my A-level electronics, along with some web refreshers, and I created [a transistor amplifier](http://hackaweek.com/hacks/?p=327) using the TIP122 that I used to drive the 5050 RGB strip \[left-side of Figure 1\] (more on that below).

The Arduino code is extremely simple. I take the reference (no music) of the audio input, take this away from the music signal, get the maximum amplitude, then divide 255 by this max to find a scale to apply to the amplitude. 255 is used as this is the number of values available to the 8 bit DAC, creating the output voltage for the LEDs.



Results are good, it does what it says on the tin really; the LED’s brightness varies according to the music intensity. It make use of RGB though, so I set about looking at what my computer could do as the processor, feeding via serial.

## Computer Processing via Serial

Turning to Minim, a library included with [Processing](http://www.processing.org) for analysis of audio. In particular the [Fast Fourier Transform (FFT)](http://code.compartmental.net/minim/javadoc/ddf/minim/analysis/FourierTransform.html), which I use to extract the amplitude of parts of the frequency spectrum rather than the complete waveform as before, and [BeatDetect](http://code.compartmental.net/minim/javadoc/ddf/minim/analysis/BeatDetect.html) to&#8230;detect the beat!<figure id="attachment_20" aria-describedby="caption-attachment-20" style="width: 300px" class="wp-caption aligncenter">

[<img loading="lazy" class="size-medium wp-image-20" title="The Prototype" src="http://engineer.john-whittington.co.ukassets/img/uploads/2012/06/IMG_1169-300x225.jpg" alt="" width="300" height="225" />](http://engineer.john-whittington.co.ukassets/img/uploads/2012/06/IMG_1169.jpg)<figcaption id="caption-attachment-20" class="wp-caption-text">The Prototype</figcaption></figure> 

It is worth noting I actually went down this avenue before completing the non-serial method above so I’ll talk about the circuitry now. I’m driving a 5050 RGB LED strip, constructed of 30 RGB LEDs per 1m, each drawing 60mA. With 5m of the stuff in my van, the maximum draw is 9A &#8211; far more than the Atmega can supply. Using the TIP122 transistor, with the base connected to the arduino output, the strip connected to the collector and drain sunk to the 12V ground solves this. If using a few LEDs or single RGB package you can remove this part.

Onto the software. To get an idea of how to use Processing, I started with the examples. BeatDetect can differentiate between musical beats (snare, high hat, kick) so I used this to output each to a different colour. <a href="http://youtu.be/UswU91Kjg_I" target="_blank" rel="noopener">It was cool</a> but still not the dynamic, rainbow effect I wanted. FFT applies a fast fourier transform to the music and outputs the spectrum as a number of lines whose length depends on the amplitude. This was more my ball park. Breaking the spectrum into ranges for the bass (green), mid (blue) and treble (red) and I had my dynamic musical lights. Looking at the code will explain this further.<figure id="attachment_35" aria-describedby="caption-attachment-35" style="width: 300px" class="wp-caption aligncenter">

[<img loading="lazy" class="size-medium wp-image-35" title="Script GUI" src="http://engineer.john-whittington.co.ukassets/img/uploads/2012/06/Screen-shot-2012-06-29-at-09.47.38-300x153.jpg" alt="" width="300" height="153" srcset="/assets/img/uploads/2012/06/Screen-shot-2012-06-29-at-09.47.38-300x153.jpg 300w, /assets/img/uploads/2012/06/Screen-shot-2012-06-29-at-09.47.38-500x255.jpg 500w, /assets/img/uploads/2012/06/Screen-shot-2012-06-29-at-09.47.38.jpg 592w" sizes="(max-width: 300px) 100vw, 300px" />](http://engineer.john-whittington.co.ukassets/img/uploads/2012/06/Screen-shot-2012-06-29-at-09.47.38.jpg)<figcaption id="caption-attachment-35" class="wp-caption-text">An overlay of the Java applet output showing roughly how I have broken the spectrum up.</figcaption></figure> 

I converted the code to use `get.LineIn` rather than a sample file, involving changing `BeatListener` to use `AudioInput` rather than `AudioPlayer`. Then, to make the line in of my Macbook the output of the sound card, [SoundFlower](http://code.google.com/p/soundflower/) is required to create a software device that is then defined in the MIDI setup to be the output and input device.

The results once connect to the van lighting are great. The dynamic colours are a lot nicer to look at than the pulsing single colour or flash to a beat.



# Code and Parts

[Code on GitHub](https://github.com/tuna-f1sh/Musical-Colours)

****UPDATE 16/01/13**** I re-used the code in <a title="halo colours" href="http://engineer.john-whittington.co.uk/2013/01/playing-halo-with-an-arduino/" target="_blank" rel="noopener">another project</a>, and think the version there is better; you can fine tune the frequency bands.

[Parts List](http://engineer.john-whittington.co.ukassets/img/uploads/2012/06/MusicalColours_bom.html)

# Future Work

  * I&#8217;ve got the parts on the way to convert this from prototype to a contained unit. I&#8217;m going to make it stand alone to sit by the AUX in the van, with a USB jack for when I have my laptop. I&#8217;ll probably tweak the code a bit before this, and include a button input to cycle functions, along with a pot to vary sensitivity.
  * I&#8217;m not done with the LED strip, I&#8217;ve got some neat ideas once I can get my ANT+ receiver working&#8230;

****UPDATE**** [I&#8217;ve now finalised this project](http://engineer.john-whittington.co.uk/2012/08/musical-colours-update/)