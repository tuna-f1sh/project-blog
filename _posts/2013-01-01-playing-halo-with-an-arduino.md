---
id: 186
title: 'Light Feedback &#8211; Playing Halo with an Arduino'
date: 2013-01-01T09:33:28+00:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=186
permalink: /2013/01/playing-halo-with-an-arduino/
image: assets/img/uploads/2013/01/2013-01-01-08.53.18-copy-1000x288.jpg
categories:
  - Electronics
  - Programming
tags:
  - arduino
  - halo
  - LED
  - music
  - rgb strip
---
<!--more-->

An update of my [MusicalColours](http://engineer.john-whittington.co.uk/2012/06/musical-rainbows-in-the-van/ "MusicalColours") script to provide lighting feedback for my TV! Demo&#8217;d by playing Halo 4. 

The circuit used is the same as before but I have tweaked the code somewhat. I decided I wanted a way of tuning the frequency bands used for the RGB lights, as the previous code required trail and error. I found a Processing library called [ControlP5](http://www.sojamo.de/libraries/controlP5/) that provides a GUI, which can be used to control variables. Using it, I have developed sliders, which control the upper and lower boundary of treble, mid and bass. 

Unfortunately, the graphical FFT does not work with the sliders due to a different rendering method used. I think it may be fixed in the current version of Processing (2.0) but I found this not to work with the Arduino library (a known bug).

I also started playing around with the linear averages function of the FFT:

<pre>fftLin.linAverages(n)</pre>

It reduces the number of bands and should reduce noise that can cause the lights to flicker. It is also something I was looking at to try and level out the ranges a bit, so they correspond to the analogue voltage better (I&#8217;ve also messed around with `map` but it doesn&#8217;t really work when you don&#8217;t know the max value of the input). I didn&#8217;t use either in the video above though as I am still trying to get the right number of averages. Current code is attached below (you need to download the [ControlP5 Library](http://www.sojamo.de/libraries/controlP5/) to use this version)

<a href="http://engineer.john-whittington.co.uk/2013/01/playing-halo-with-an-arduino/halocolours/" rel="attachment wp-att-193">HaloColours</a>