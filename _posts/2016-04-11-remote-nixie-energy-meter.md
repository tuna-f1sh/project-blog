---
id: 877
title: Remote Nixie Energy Meter
date: 2016-04-11T11:56:41+01:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=877
permalink: /2016/04/remote-nixie-energy-meter/
image: assets/img/uploads/2016/04/IMG_4674-e1460371544341-480x510.jpg
categories:
  - Electronics
  - Programming
tags:
  - NRF24l01
format: gallery
---
My dad was impressed by my [nixie tube energy meter project](http://engineer.john-whittington.co.uk/2015/12/nixie-tube-energy-meter/) and expressed interest in his own. Unfortunately, the power inlet for his house was under the stairs and out of view, unlike mine in the corridor. Undeterred and with his birthday coming, I revised the design to be stand-alone with a remote sensor unit.

<!--more-->

I won&#8217;t go into too much detail but the data transfer is based around a couple of NRF24l01 modules. I had not come across these before and initially started using two ESP8266 with an Ad-hoc wifi network acting as a serial relay. The NRF24l01 is much simpler; still using 2.4Ghz wifi but without the consumer wifi infrastructure. It allows data packet transfer between modules and has a well developed library. I&#8217;ll certainly be using them in the future for device to device communication. The code is in a branch of my original repo: https://github.com/tuna-f1sh/nixie-energy-meter/tree/nrf24

Little has changed beyond that, [see the original project for full details](http://engineer.john-whittington.co.uk/2015/12/nixie-tube-energy-meter/). The remote sensor unit has a single LED indicator: RED when disconnected from display/error; GREEN when connected. It is contained in a simple laser cut box.

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2016/04/IMG_4674-e1460371544341.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-23-878" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-23-878'> My dad mounted the meter on next to the door in the entrance area </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/04/IMG_1659.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-23-879" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-23-879'> The sensor unit is simple with a power inlet, transformer sense input and a single bi-colour LED status indicator. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/04/IMG_1655.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-23-881" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-23-881'> An Arduino Pro Mini, NRF24l01 and breadboard current sense resistor </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/04/IMG_1660.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-23-880" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-23-880'> The display panel remains the same, with added layers to create an shallow enclosure. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/04/IMG_1656.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-23-882" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-23-882'> I added indication for when connection from the sensor unit is lost. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/04/IMG_1658.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-23-883" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-23-883'> Just a power inlet at the rear. </figcaption></figure>
