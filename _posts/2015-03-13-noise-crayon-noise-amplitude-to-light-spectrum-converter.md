---
id: 649
title: 'Noise Crayon &#8211; Noise Amplitude to Light Spectrum Converter'
date: 2015-03-13T18:51:13+00:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=649
permalink: /2015/03/noise-crayon-noise-amplitude-to-light-spectrum-converter/
image: assets/img/uploads/2015/03/IMG_1129-825x510.jpg
categories:
  - Electronics
  - Fabrication
  - Mechanical
  - Programming
tags:
  - acoustics
  - acrylic
  - arduino
  - c
  - concept
  - embedded
  - environment
  - featured
  - laser cut
---
Continuing on from my [Ambient Noise Level Indicator](http://engineer.john-whittington.co.uk/2014/05/ambient-noise-level-indicator/), I wanted to create an enclosure and make it stand-alone &#8211; not requiring a computer to do the processing. I ended up with a little device that converts noise amplitude to the light spectrum: Noise Crayon.

The [Ambient Noise Level Indicator](http://engineer.john-whittington.co.uk/2014/05/ambient-noise-level-indicator/) used the MCU serial host [Processing](https://processing.org/) to perform a FFT and various averaging routines to create an indicator for ambient noise. The idea being that it would change colour when background levels rise above a threshold. Moving to an ATMEGA328, performing this processing &#8211; especially the FFT &#8211; is asking a little too much of it. There are libraries but I&#8217;ve heard of limited successes.

<!--more-->

I decided all the processing wasn&#8217;t really required anyway and the device could just read to the instantaneous amplitude, with the colour change rate slewed to control the sensitivity to noise. The hardware is simply an Arduino (ATMEGA328), an RGB LED and an electrolytic mic paired with the [MAX9814](http://datasheets.maximintegrated.com/en/ds/MAX9814.pdf); I used a handy [breakout by Adafruit](http://www.adafruit.com/product/1713). I did initially try an amp without adjustable gain. The results were good but not great for measuring noise at varying distance. The code is fairly basic too:

  1. Sample the voltage from the MAX9814 for 50ms. 50ms will capture down to a 20Hz wave &#8211; ~the lower limit of the human ear. By reducing the sample period, one can create a high pass filter. Low pass could also be done but it would require timing between peaks.
  2. Whilst sampling, record the maximum and minimum value. Find the peak-to-peak (max &#8211; min) &#8211; the amplitude of the noise.
  3. Map the noise to a colour scale.
  4. Fade the RGB LED colour to the desired colour &#8211; the fading, rather than instantly setting the colour &#8211; is what affects the sensitivity to the noise levels being picked up.

The result is conversion from noise amplitude to light spectrum. I&#8217;ve designed it to match the [light spectrum](http://en.wikipedia.org/wiki/Light#/media/File:EM_spectrum.svg), with light wavelength increasing with amplitude: blue is quiet with more yellow being added as noise level increases; blue, green, yellow, red. Red is _angry_ &#8211; high levels of noise.

A potentiometer allows me to change the rate of colour change or gain of the amplitude reading on the fly &#8211; controlling the reactivity to noise and sensitivity.

## Enclosure<figure id="attachment_668" aria-describedby="caption-attachment-668" style="width: 660px" class="wp-caption aligncenter">

[<img loading="lazy" class="wp-image-668 size-large" src="http://engineer.john-whittington.co.ukassets/img/uploads/2015/03/sound-bits-crop-1024x577.jpg" alt="" width="660" height="372" srcset="/assets/img/uploads/2015/03/sound-bits-crop-1024x577.jpg 1024w, /assets/img/uploads/2015/03/sound-bits-crop-300x169.jpg 300w" sizes="(max-width: 660px) 100vw, 660px" />](http://engineer.john-whittington.co.ukassets/img/uploads/2015/03/sound-bits-crop.jpg)<figcaption id="caption-attachment-668" class="wp-caption-text">Sketch of my first enclosure idea, constructed from wood and acrylic sections. I opted for a simpler single material design.</figcaption></figure> 

The enclosure needed to diffuse the light from the LED, contain the electronics and also allow noise to easily penetrate to the mic. I considered a perforated square enclosure &#8211; like a microphone cover &#8211; but to make it look more interesting I decided to employ kerf bending to create a curved shape. The kerf bend provides the opening for the air to move whilst creating an interesting enclosure design. Form and function! I actually found enclosing the mic helped increase the range of the microphone and effectiveness &#8211; presumably due to the smaller air space and resonance of the plastic.<figure id="attachment_653" aria-describedby="caption-attachment-653" style="width: 660px" class="wp-caption aligncenter">

[<img loading="lazy" class="size-large wp-image-653" src="http://engineer.john-whittington.co.ukassets/img/uploads/2015/03/DSC_0020-1024x681.jpg" alt="Long gaps allow the acrylic to bend due to the greater spread of the torsional loading." width="660" height="439" srcset="/assets/img/uploads/2015/03/DSC_0020-1024x681.jpg 1024w, /assets/img/uploads/2015/03/DSC_0020-300x199.jpg 300w" sizes="(max-width: 660px) 100vw, 660px" />](http://engineer.john-whittington.co.ukassets/img/uploads/2015/03/DSC_0020.jpg)<figcaption id="caption-attachment-653" class="wp-caption-text">Long gaps allow the acrylic to bend due to the greater spread of the torsional loading.</figcaption></figure> 

I hadn&#8217;t tried kerf bending acrylic until this project. It is stiffer and more brittle than plywood so is much less forgiving, requiring thought into the gap size/link spacing and some trial and error. I&#8217;m going to cover what I found and my results in another post.

## Result

I&#8217;m pleased with the result. I find it quite entertaining to have on my desk and talk to! Playing music is also quite interesting. I&#8217;m talking with [MACH Acoustics](http://www.machacoustics.com) about possible ways to use them in schools as a classroom tool and also a learning tool, with some more refinement of the enclosure and code. We might add a USB connection for example so that students could see the noise levels both visually in colour but also as a waveform. For a classroom it could be tuned to trigger a colour change at a certain noise level.

Here&#8217;s a video going over the project and a gallery:



<div id='gallery-14' class='gallery galleryid-649 gallery-columns-3 gallery-size-thumbnail'>
  <figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='http://localhost/2015/03/noise-crayon-noise-amplitude-to-light-spectrum-converter/img_1129/'><img width="150" height="150" src="/assets/img/uploads/2015/03/IMG_1129-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-14-654" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-14-654'> Blue with a bit of green shows reasonably quiet </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='http://localhost/2015/03/noise-crayon-noise-amplitude-to-light-spectrum-converter/img_1130/'><img width="150" height="150" src="/assets/img/uploads/2015/03/IMG_1130-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-14-655" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-14-655'> Full red saturation is high noise. </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='http://localhost/2015/03/noise-crayon-noise-amplitude-to-light-spectrum-converter/dsc_0020-2/'><img width="150" height="150" src="/assets/img/uploads/2015/03/DSC_0020-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-14-653" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-14-653'> Long gaps allow the acrylic to bend due to the greater spread of the torsional loading. </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='http://localhost/2015/03/noise-crayon-noise-amplitude-to-light-spectrum-converter/dsc_0018-4/'><img width="150" height="150" src="/assets/img/uploads/2015/03/DSC_0018-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-14-652" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-14-652'> Prototype acrylic enclosure with kerf bending for form and function! </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='http://localhost/2015/03/noise-crayon-noise-amplitude-to-light-spectrum-converter/img_1131/'><img width="150" height="150" src="/assets/img/uploads/2015/03/IMG_1131-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-14-656" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-14-656'> For the prototype, it&#8217;s in modular form and battery powered to demonstrate without external power. </figcaption></figure>
</div>