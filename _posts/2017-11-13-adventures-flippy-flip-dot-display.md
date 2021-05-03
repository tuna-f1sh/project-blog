---
id: 1108
title: Adventures with Flippy the Flip-dot Display
date: 2017-11-13T08:56:02+00:00
author: John
layout: post
guid: /?p=1108
permalink: /2017/11/adventures-flippy-flip-dot-display/
image: assets/img/uploads/2017/11/DSC_0007-825x510.jpg
categories:
  - Electronics
  - Modification
  - Programming
tags:
  - flip-dot
  - hacking
---
Considering my next project, I wanted to make an electromechanical display using magnets. I turned to the internet for inspiration and quickly came across Flip-dot displays; solenoid driven pixels. A good starting point for what I wanted to do, I looked further.

I found a 900mm, 56&#215;7 display on eBay from a bus salvager (who know such a thing existed!). The displays used to be common on public transport &#8211; prior to being replaced my dot matrix LEDs &#8211; to display the route number and destination. It cost me £170, which may seem expensive to some, but for 392 individually mechanically actuated pixels that are quite a feat of engineering, I thought it cheap.

Manufactured by _Hanover Displays_ and with a [basic datasheet](http://www.destination-blinds.co.uk/HanoverDisplays/Flip_Dot_Manual_vB.pdf) to hand, I took the plunge.<!--more-->

## Software

Upon arriving and having acquired a USB-RS485 dongle, I tried out a [Python module](https://github.com/ks156/Hanover_Flipdot) someone had written for their own _Hanover_ display. It demonstrated my display worked but I quickly decided rolling my own driver would be better for my needs &#8211; and part of the fun of getting the display in the first place! Most importantly, the module developer had reverse engineered (or somehow knew) the messaging protocol for the displays:

The Hanover Flip-Dot display expects ascii chars representing the hexadecimal bytes; bytes being every 8 rows of dots. For example, an eight row column:

    . = 1 => 0xF5 => ['F', '5'] => [0x46, 0x35]
    | = 0
    . = 1
    | = 0
    . = 1
    . = 1
    . = 1
    . = 1
    

Along with a header (containing display resolution and address) and footer (containing CRC). I can only imagine the designers went designers went down this route due to hardware limitations at the time; perhaps they only had access serial controllers that would send ascii characters for use in terminals. Or perhaps there is a reason I am missing?<figure id="attachment_1113" aria-describedby="caption-attachment-1113" style="width: 660px" class="wp-caption aligncenter">

[<img loading="lazy" class="size-large wp-image-1113" src="/assets/img/uploads/2017/11/screenshot-1-1024x257.png" alt="" width="660" height="166" srcset="/assets/img/uploads/2017/11/screenshot-1-1024x257.png 1024w, /assets/img/uploads/2017/11/screenshot-1-300x75.png 300w, /assets/img/uploads/2017/11/screenshot-1-768x193.png 768w, /assets/img/uploads/2017/11/screenshot-1.png 1511w" sizes="(max-width: 660px) 100vw, 660px" />](assets/img/uploads/2017/11/screenshot-1.png)<figcaption id="caption-attachment-1113" class="wp-caption-text">Message for single dot in second column: B0 &#8216;2&#8217; fixed, B1 &#8216;1&#8217; fixed, B2 &#8216;5&#8217; display addr, B3/4 resolution, B5/6 col 0, B7/8 col 1</figcaption></figure> 

Having a logic analyser to scope the hardware output become invaluable when the driver didn&#8217;t work at first. Despite apparently unloading the full buffer, the node-serialport was clipping the data. A bit of debugging and a [pull-request](https://github.com/node-serialport/node-serialport/issues/1229) later and that hitch was solved.

This conversion from hex bytes to ascii characters can quickly become confusing, so I designed my driver to work a 2d matrix of rows and columns, only being encoded to the display format when buffering to the serial port. The matrix means one can intuitively flip a bit at the \[x\]\[y\] and flip that dot on the display.

Secondly, the Python module used constant pre-defined character arrays encoded for the display. It meant that they didn&#8217;t scale well to different size displays. With my matrix implementation, I quickly realised that ascii art would be the perfect font renderer, as one can quickly parse the text strings and set any non-space character as on.  Here&#8217;s the debug output of my driver sending &#8220;hello&#8221;:

<pre class="lang:sh decode:true">ascii
  ascii  #    # ###### #      #       ####
  ascii  #    # #      #      #      #    #
  ascii  ###### #####  #      #      #    #
  ascii  #    # #      #      #      #    #
  ascii  #    # #      #      #      #    #
  ascii  #    # ###### ###### ######  ####
  ascii                                      +1s
  flipdot Encoded Data: 48,48,55,69,48,56,48,56,48,56,48,56,55,69,48,48,55,69,52,65,52,65,52,65,52,65,52,50,48,48,55,69,52,48,52,48,52,48,52,48,52,48,48,48,55,69,52,48,52,48,52,48,52,48,52,48,48,48,51,67,52,50,52,50,52,50,52,50,51,67,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48 +1ms
  flipdot Writing serial data, size: 120 B : 023135333830303745303830383038303837453030374534413441344134413432303037453430343034303430343030303745343034303430343034303030334334323432343234323343303030303030303030303030303030303030303030303030303030303030303030303030303030303030034241 +0ms</pre>

Finally, I added a queue and automatic frame/string scrolling. Once I had all this functionality, it was begging for a GUI!<figure id="attachment_1114" aria-describedby="caption-attachment-1114" style="width: 660px" class="wp-caption aligncenter">

[<img loading="lazy" class="wp-image-1114 size-large" src="/assets/img/uploads/2017/11/preview-1024x608.png" alt="" width="660" height="392" srcset="/assets/img/uploads/2017/11/preview-1024x608.png 1024w, /assets/img/uploads/2017/11/preview-300x178.png 300w, /assets/img/uploads/2017/11/preview-768x456.png 768w, /assets/img/uploads/2017/11/preview.png 1446w" sizes="(max-width: 660px) 100vw, 660px" />](assets/img/uploads/2017/11/preview.png)<figcaption id="caption-attachment-1114" class="wp-caption-text">The GUI was quite quick to develop as the driver was written in node.js &#8211; which is primarily a web technology &#8211; creating a web app was not a problem. By adding a HTML \*canvas\* element to emulate the flip-dot display, one can quickly toggle dots on the display to draw any shapes. One can send text with any Figlet font, fill the display, enable the clock and show Twitter streams.</figcaption></figure> 

## Hardware

I go into the hardware more in my video, but I&#8217;ll briefly discuss the electromechanical pixel operation. On my _Hanover_ display, the dots have a magnet inset on one side and an exposed crescent on on the other. Two posts either side are the two poles of a solenoid, hidden below. On my diagram and up close, one can see that the magnet is attracted/repelled from each pole by alternating the current direction in the solenoid coil &#8211; this allows control of the exposed dot surface.<figure id="attachment_1116" aria-describedby="caption-attachment-1116" style="width: 660px" class="wp-caption aligncenter">

[<img loading="lazy" class="size-large wp-image-1116" src="/assets/img/uploads/2017/11/DSC_0033-1024x683.jpg" alt="" width="660" height="440" srcset="/assets/img/uploads/2017/11/DSC_0033-1024x683.jpg 1024w, /assets/img/uploads/2017/11/DSC_0033-300x200.jpg 300w, /assets/img/uploads/2017/11/DSC_0033-768x512.jpg 768w" sizes="(max-width: 660px) 100vw, 660px" />](assets/img/uploads/2017/11/DSC_0033.jpg)<figcaption id="caption-attachment-1116" class="wp-caption-text">Diagram showing how a flip-dot display can toggle the dot with a single solenoid by alternating the current direction.</figcaption></figure> 

Residual magnetism in the high remanence core, holds the dot in the last position without the solenoid energised. The un-powered, luminous stable state of the display is what made them great as low-power daylight displays.

<blockquote class="imgur-embed-pub" lang="en" data-id="brHT90x">
  <p>
    <a href="//imgur.com/brHT90x">View post on imgur.com</a>
  </p>
</blockquote>



The solenoids are arranged in a multiplexed grid pattern as you&#8217;d expect. To raster a frame, the driver appears to enable a row, followed by each column, then the next row&#8230; There does not seem to be any frame optimisation &#8211; only firing dots that have changed since the last frame for example &#8211; causing the display to raster a full frame each time. This fixes the maximum refresh rate to around 2 Hz &#8211; slow but enough to display a HH:MM:SS clock!

Considering the electronic area is so large and accessible, one could relatively easily upgrade the driving hardware by hoping directly onto the driver ICs to potentially increase this refresh rate, increase the buffer, better message structure etc. As an electromechanical pixel rather than electrochemical like modern displays, the upper refresh rate would probably be limited by the physical movement of the dot however, along with the solenoid losses.

The display had flying leads for the RS485 and 24 V power that I used for development, but I&#8217;ve since been able to install a AC/DC 24 V supply within the enclosure and a Raspberry Pi hosting the node.js web controller. I can now simply plug in an IEC lead, then control the display from any web browser.

<div id='gallery-31' class='gallery galleryid-1108 gallery-columns-2 gallery-size-thumbnail'>
  <figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='http://localhost/2017/11/adventures-flippy-flip-dot-display/dsc_0014/'><img width="150" height="150" src="/assets/img/uploads/2017/11/DSC_0014-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-31-1126" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-31-1126'> The main PCB features a microcontroller (big package), some CMOS RAM and line decoders that output to drivers firing the solenoids, along with a power stage for the solenoids. </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon portrait'>
    <a href='http://localhost/2017/11/adventures-flippy-flip-dot-display/wbqwucmwtjwmsa3v7xlew/'><img width="150" height="150" src="/assets/img/uploads/2017/11/WbQWuCmWTJWMsA3v7Xlew-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-31-1138" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-31-1138'> New school with old school! </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='http://localhost/2017/11/adventures-flippy-flip-dot-display/dsc_0018-5/'><img width="150" height="150" src="/assets/img/uploads/2017/11/DSC_0018-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-31-1128" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-31-1128'> I managed to squeeze an AC/DC 24 V supply into the enclosure, with a IEC inlet cut on one side. Adding a Raspberry Pi means the whole display can be controlled remotely from a single IEC lead. </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon portrait'>
    <a href='http://localhost/2017/11/adventures-flippy-flip-dot-display/akl0baintry0cn9whupgda/'><img width="150" height="150" src="/assets/img/uploads/2017/11/AKl0bainTRy0CN9whUPGdA-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-31-1136" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-31-1136'> Made some fancy side panels: partly to make it look less industrial, partly to cover up dremel cuts! </figcaption></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon portrait'>
    <a href='http://localhost/2017/11/adventures-flippy-flip-dot-display/qnpdmumlsey7rvf1gbq9a/'><img width="150" height="150" src="/assets/img/uploads/2017/11/qnPDMUmlSey7RVf1gbq9A-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-31-1137" /></a>
  </div><figcaption class='wp-caption-text gallery-caption' id='gallery-31-1137'> The display features a Twitter stream display so people can tweat the display. </figcaption></figure>
</div>

## Wrap Up

Writing the software and understanding the electromechanical operation of this display has been well worth it. My packages are open-source with links below. They should work for any Hanover Flip-dot display by changing the row and column values at initiation. Even if you don&#8217;t have a display, the web controller is setup to emulate by default so you can still have a play!



# Links

[NPM Package](https://www.npmjs.com/package/flipdot-display)  
[Package Github](https://github.com/tuna-f1sh/node-flipdot)  
[Web controller](https://github.com/tuna-f1sh/flippy-flipdot-web)