---
id: 795
title: Nixie Tube Energy Meter
date: 2015-12-28T08:45:57+00:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=795
permalink: /2015/12/nixie-tube-energy-meter/
image: assets/img/uploads/2015/12/DSC_0066-1-e1450862704432-825x510.jpg
categories:
  - Electronics
  - Fabrication
  - Mechanical
  - Programming
tags:
  - arduino
  - embedded
  - esp8266
  - featured
  - laser cut
  - nixie
---
<a href="http://hackaday.com/2016/01/04/nixie-tube-energy-meter-dresses-up-front-hall/" target="_blank" rel="noopener">Featured on Hack a Day</a>

Having recently bought a house, project time has been a bit thin on the ground. As a standard terrace house, the consumer unit and electricity meter were in the entrance hallway, exposed and looking a bit naff. I liked the look of the meter so I quickly created a box that allowed the meter to poke through and leave access to the fuses.

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2015/12/IMG_8991-e1451227735242.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-19-850" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-19-850'> We bought the house with no covering or the electricity inlet. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/hj.png" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-19-851" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-19-851'> Flatpack covering I made using my OpenSCAD box script. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/IMG_1520-e1450782204967.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-19-811" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-19-811'> My quick and simple inlet surround did the job but was a bit boring. </figcaption></figure>

The box covering did the job but felt a bit cumbersome with all that spare space; it needed something else to give it more purpose. An energy meter was the obvious thing but I didn&#8217;t want a garish LCD or 7 segment display, it need to match the blown glass electricity meter&#8230; &#8230;[nixie tubes](https://www.google.co.uk/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=nixie%20tube)!

<figure id="attachment_810" aria-describedby="caption-attachment-810" style="class=wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-810" src="/assets/img/uploads/2015/12/IMG_1473.jpg" alt="The Nixie Module runs off 5V and SPI" /><figcaption id="caption-attachment-810" class="wp-caption-text">The Nixie Module runs off 5V and SPI making the project quick to get off the ground</figcaption></figure> 

<!--more-->

# Design

I&#8217;ve wanted to use nixie tubes in a project for a long time &#8211; almost tempted by the bog-standard clock &#8211; so once I had the vision on this one I set about it in zero time! I&#8217;m afraid I didn&#8217;t design the driving circuit myself, instead I went for [this very tidy Nixie Module](http://www.dfrobot.com/index.php?route=product/product&product_id=738). Working off 5V and SPI it is nice and quick to get a project off the ground. It is expensive but the build quality and time saved designing something else made it a worthy investment. An Arduino would be the microcontroller but I wanted the meter to provide some form of data stream for a web based energy history. To make it an IoT, I a paired ESP8266 with it. I used both together because the Arduino ADC has a better resolution and has been tried and tested.

## Display

<figure id="attachment_820" aria-describedby="caption-attachment-820" style="class=wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-820" src="/assets/img/uploads/2015/12/panel.png" alt="An OpenSCAD box meant an OpenSCAD panel. I also modelled the nixie tube for verification." /><figcaption id="caption-attachment-820" class="wp-caption-text">An OpenSCAD box meant an OpenSCAD panel. I also modelled the nixie tube for verification.</figcaption></figure> 

Considering the expense of the Nixie module and the irony of a high energy impact energy meter not lost on me (the tubes draw around 300mA each), I opted to use only two tubes; I was going to require SI notification anyway for full scale display. Handily, the tubes have colon points on the right-hand side (for clock use), which I designed as indicators for x10 and x1. With both SI units and x10 x1 decimals, one can display from 0 to 100MW &#8211; albeit with only 2 significant figures (considering the accuracy of a current transformer system like this, that isn&#8217;t a problem).

  <figure class='gallery-item'> 
    <img src="/assets/img/uploads/2015/12/IMG_1483.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-20-813" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-20-813'> The panel uses inset acrylic digits. By being clever with the laser kerf, once can a perfect tolerance fit. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2015/12/IMG_1494.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-20-815" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-20-815'> Behind I doubled up the digits so they work like light pipes. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2015/12/IMG_1490.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-20-814" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-20-814'> From the front it looks seamless. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2015/12/IMG_1500.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-20-816" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-20-816'> Testing the digits. They are common anode, with the micro asserting LOW to turn the LED on. They are attached in series on PORTC so are simple to control using bit-masking. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2015/12/IMG_1506.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-20-817" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-20-817'> Nixie tubes and strip board circuit for current sensing/distribution. </figcaption></figure><figure class='gallery-item'> 
  
    <img src="/assets/img/uploads/2015/12/IMG_1517.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-20-818" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-20-818'> Testing the panel. There is some slight bleed between characters but it looks fine in person. </figcaption></figure>

The Nixie library and arrangement of the SI indicators made displaying the power very simple

```c
void printPwr(uint16_t Pwr) {
    tube.printf("%02d",Pwr);
    SI_PORT |= (SI_OFF_MASK & SI_WATT_MASK);

    if ((Pwr &gt;= 100) && (Pwr &lt; 1000)) { tube.setColon(1,(Colon) Lower); } else if ((Pwr &gt;= 1000) && (Pwr &lt; 10000)) { SI_PORT &= SI_KILO_MASK; tube.setColon(0,(Colon) Upper); } else if (Pwr &gt;= 10000) {
        SI_PORT &= SI_MEGA_MASK;
        tube.setColon(1,(Colon) Upper);
    } else {
        tube.setColon(1,(Colon) None);
    }

    // set kilowatt hours
    if (display == (rolling_t) hour)
        SI_PORT &= SI_HOUR_MASK;

    tube.display();
}
```

## Power Measurement

The power measurement comes by way of [SCT-013 clip-on current transformer](http://www.ebay.co.uk/itm/SCT-013-000-Non-invasive-AC-Current-Sensor-Transformer-BF-/262194656888?hash=item3d0c04f678:g:toEAAOSwJcZWcUJc) with a current sensing resistor in parallel, biased by VREF/2, then sampled by the Arduino ADC. [Open Energy Monitor have plenty of detail on this](http://openenergymonitor.org/emon/buildingblocks/ct-sensors-interface), which I followed and a [useful library](http://engineer.john-whittington.co.uk/wp-admin/post.php?post=795&action=edit), that I used. In its most basic form, the library samples the ADC reading over a number of samples (in phase with 50Hz mains) and returns the RMS current. With the RMS current and assumed RMS voltage (230V) using $$P = V * I$$, the _apparent_ power is calculated. 

_Apparent_ power is the assumed power and is what a resistive load will draw. _Real_ power is what we&#8217;re billed for and that takes into account non-linear voltage/current relationships and phase lag created by other loads such as motors (which feed power back at certain points in the cycle) and DC converters. The differences are again best [summarised by Open Energy Monitor](http://openenergymonitor.org/emon/buildingblocks/ac-power-introduction).

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2015/12/IMG_1476.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-21-853" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-21-853'> Testing with a long 3.5mm extension cable. </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/IMG_1477.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-21-854" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-21-854'> The current sensing circuit and ADC needs calibrating with the actual current through the transformer. </figcaption></figure>

Building the system I noticed that the bell (already in the box near the consumer unit) uses a step-down transformer, offering outputs or 3, 5 or 8V. I could adapt the system to sample this AC voltage too, to create a more accurate reading rather than using the assumed 230V RMS. I&#8217;m not too bothered though, I mainly want an indicative meter than also looks good! There is already a wide amount of error in the system: transformer tolerance, resistor tolerance, voltage bias drift, ADC resolution etc.

## Control

I didn&#8217;t want any buttons on the panel and I also wanted to generate reports of power usage. For this, I integrated and EPS8266 using standard AT firmware to act as a TCP packet relay over serial. I found the [ESP8266wifi library](https://github.com/ekstrand/ESP8266wifi) suited this usage but required a _blocking_ function call to check for incoming connections/messages &#8211; not suitable for updating the display in a timely manor, ADC sampling or any task other than a pure TCP client!

I [forked the code](https://github.com/tuna-f1sh/ESP8266wifi/tree/connection) with functions that poll the ESP8266 serial buffer instead, checking new connections and maintaining a multi-client connection structure, such that _when_ there are connections, messages can be checked or data sent.

When a connection is made and message recieved, a simple command interpreter then acts upon it:

```c
void processCommand(WifiMessage msg) {
    // return buffer
    char espBuf[MSG_BUFFER_MAX];
    // scanf holders
    int set;
    char str[16];

    // Get command and setting
    sscanf(msg.message,"%15s %d",str,&set);
    /* swSerial.print(str);*/
    /* swSerial.println(set);*/

    // Stream JSON
    if ( !strcmp_P(str,STRM) ) {
        snprintf(espBuf,sizeof(espBuf),json,avg[0],avg[1],avg[2],avg[3]);
        wifi.send(msg.channel,espBuf);
    }
    else if ( !strcmp_P(str,ROLL) ) {
        snprintf(espBuf,sizeof(espBuf),json,roll[0],roll[1],roll[2],roll[3]);
        wifi.send(msg.channel,espBuf,false);
        snprintf(espBuf,sizeof(espBuf),json,count[0],count[1],count[2],count[3]);
        wifi.send(msg.channel,espBuf,true);
    }
    // Change colour
    else if ( !strcmp_P(str,COLOUR) ) {
        tube.setBackgroundColor((Color) set);
        tube.display();
        wifi.send(msg.channel,msg.message);
    }
    // Reset rolling counts
    else if ( !strcmp_P(str,RESET) ) {
        memset(roll, 0, ( (sizeof(roll)/sizeof(roll[0])) * sizeof(roll[0]) ) );
        memset(count, 0, ( (sizeof(count)/sizeof(count[0])) * sizeof(count[0]) ) );
        wifi.send(msg.channel,"COUNT OK");
    }
    // Change Nixie display var
    else if ( !strcmp_P(str,DISP) ) {
        display = (rolling_t) set;
        wifi.send(msg.channel,msg.message);
    }
    // Set ADC calibration
    else if ( !strcmp_P(str,CAL) ) {
        EEPROM.write(EEPROM_CAL,set);
        wifi.send(msg.channel,msg.message);
    }
    // Return what we are
    else if ( !strcmp_P(str,IDN) ) {
        wifi.send(msg.channel,"JBR ENERGY MONITOR V0.1");
    }
    // Reset system by temp enable watchdog
    else if ( !strcmp_P(str,RST) ) {
        wifi.send(msg.channel,"SYSTEM RESET...");
        // soft reset by reseting PC
        asm volatile (" jmp 0");
    }
    // Unknown command
    else {
        wifi.send(msg.channel,"ERR");
    }
}
```

I have commands to stream JSON formated data, with a plan to have a locally running Raspberry Pi Node.js server, requesting the JSON stream and updating a database/presenting a rolling usage graph. That will be something for another project log. The tubes have RGB backlights, so there are commands to change the colour and also change the display between sec, min, hour or even day rolling average.

# Result

<figure style="class=wp-caption aligncenter">
<img loading="lazy" class="" src="http://i.imgur.com/G3UsbNs.gif" /><figcaption class="wp-caption-text">The affect of turning a kettle on and off (~2kW)</figcaption></figure> 

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2015/12/DSC_0038.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/DSC_0052.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/DSC_0040.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/DSC_0039.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/DSC_0068-e1450862949819.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/DSC_0062.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/DSC_0063.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2015/12/DSC_0066-1-e1450862704432.jpg" class="attachment-medium size-medium" alt="" loading="lazy" />
</figure>

<div class="box">
<iframe width="560" height="315" src="https://www.youtube.com/embed/tompoAg-VL8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

If you want to make one yourself or part of the design, the code and OpenSCAD designs are in [this Github](https://github.com/tuna-f1sh/nixie-energy-meter)

**[UPDATED: See the wireless version](http://engineer.john-whittington.co.uk/2016/04/remote-nixie-energy-meter/)**
