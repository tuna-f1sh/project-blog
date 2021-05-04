---
id: 680
title: 'Raspberry Pi DAC &#8211; MCP4725 with wiringPi'
date: 2015-03-19T19:45:39+00:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=680
permalink: /2015/03/raspberry-pi-dac-mcp4725-with-wiringpi/
image: assets/img/uploads/2015/03/download1.png
categories:
  - Electronics
  - Programming
tags:
  - c
  - embedded
  - guide
  - raspberrypi
---

The Raspberry Pi lacks a DAC but using the I2C bus, one can easily add a device like the 12bit [MCP4725](http://www.microchip.com/wwwproducts/Devices.aspx?dDocName=en532229). The GPIO library [wiringPi](https://projects.drogon.net/raspberry-pi/wiringpi/i2c-library) provides support for I2C devices, however, getting the MCP4725 working with it isn&#8217;t a simple as one might hope. The device is 12bit but the I2C protocol works on bytes (8bits). To send 12bit data, the Microchip designed the message transfer like this:

<figure id="attachment_682" aria-describedby="caption-attachment-682" style="class=wp-caption aligncenter">
<img loading="lazy" src="/assets/img/uploads/2015/03/22039d.pdf.jpg" alt="The MC4725 expects the 12bit data to be broken into two bytes and sent directly after each other." class="size-full wp-image-682" /><figcaption id="caption-attachment-682" class="wp-caption-text">The MC4725 expects the 12bit data to be broken into two bytes and sent directly after each other.</figcaption></figure> 

Trying to send this 12bit data using the standard commands to send bytes won&#8217;t work because the opening messages will be resent between the bytes. The solution is to write the register to be written (0x40 for standard or 0x60 for saving the output state to EEPROM) followed by the two bytes in a row &#8211; one is bodged in place of the register. One could write a new i2c_smbus function to do this but it&#8217;s useful to incorporate it into the existing wiringPi library.

I started by writing a basic function for using wiringPi:

```c
#include <wiringPi.h>;
#include <wiringPiI2C.h>;

#include "mcp4725.h"

void setVoltage(int fd, int voltage, int persist) {
  // 2 byte array to hold 12bit data chunks
  int data[2];

  // limit check voltage
  voltage = (voltage &gt; 4095) ? 4095 : voltage;

  // MCP4725 expects a 12bit data stream in two bytes (2nd & 3rd of transmission)
  data[0] = (voltage &gt;&gt; 8) & 0xFF; // [0 0 0 0 D12 D11 D10 D9 D8] (first bits are modes for our use 0 is fine)
  data[1] = voltage; // [D7 D6 D5 D4 D3 D2 D1 D0]

  // 1st byte is the register
  if (persist) {
    wiringPiI2CWrite(fd, WRITEDACEEPROM);
  } else {
    wiringPiI2CWrite(fd, WRITEDAC);
  }

  // send our data using the register parameter as our first data byte
  // this ensures the data stream is as the MCP4725 expects
  wiringPiI2CWriteReg8(fd, data[0], data[1]);
}
```

With this working, I integrated it with the wiringPi methods. I&#8217;ve hosted my fork of the library on github:

<https://github.com/tuna-f1sh/wiringPi-mcp4725>

Installing this library, one can then use the chip like any other wiringPi chip, here the example I&#8217;ve put in &#8216;/examples&#8217;:

```c
/*
 * MCP4725 driver for wiringPi:
 *    https://projects.drogon.net/raspberry-pi/wiringpi/
 *
 * March 2015 John Whittington http://www.jbrengineering.co.uk @j_whittington
 *
*==============================================================*/

#include <stdio.h>;
#include <stdint.h>
#include <stdlib.h>
#include <wiringPi.h>

#include "mcp4725.h"

int main(int argc, char *argv[]) {
  int output, i;

  if (argc == 2) {
    output = atoi(argv[1]);
  } else {
    printf("No input, producing sine wave");
    output = 0; // squash compiler warning
  }

  int sine[256]= {
    2048, 2098, 2148, 2198, 2248, 2298, 2348, 2398,
    2447, 2496, 2545, 2594, 2642, 2690, 2737, 2784,
    2831, 2877, 2923, 2968, 3013, 3057, 3100, 3143,
    3185, 3226, 3267, 3307, 3346, 3385, 3423, 3459,
    3495, 3530, 3565, 3598, 3630, 3662, 3692, 3722,
    3750, 3777, 3804, 3829, 3853, 3876, 3898, 3919,
    3939, 3958, 3975, 3992, 4007, 4021, 4034, 4045,
    4056, 4065, 4073, 4080, 4085, 4089, 4093, 4094,
    4095, 4094, 4093, 4089, 4085, 4080, 4073, 4065,
    4056, 4045, 4034, 4021, 4007, 3992, 3975, 3958,
    3939, 3919, 3898, 3876, 3853, 3829, 3804, 3777,
    3750, 3722, 3692, 3662, 3630, 3598, 3565, 3530,
    3495, 3459, 3423, 3385, 3346, 3307, 3267, 3226,
    3185, 3143, 3100, 3057, 3013, 2968, 2923, 2877,
    2831, 2784, 2737, 2690, 2642, 2594, 2545, 2496,
    2447, 2398, 2348, 2298, 2248, 2198, 2148, 2098,
    2048, 1997, 1947, 1897, 1847, 1797, 1747, 1697,
    1648, 1599, 1550, 1501, 1453, 1405, 1358, 1311,
    1264, 1218, 1172, 1127, 1082, 1038,  995,  952,
     910,  869,  828,  788,  749,  710,  672,  636,
     600,  565,  530,  497,  465,  433,  403,  373,
     345,  318,  291,  266,  242,  219,  197,  176,
     156,  137,  120,  103,   88,   74,   61,   50,
      39,   30,   22,   15,   10,    6,    2,    1,
       0,    1,    2,    6,   10,   15,   22,   30,
      39,   50,   61,   74,   88,  103,  120,  137,
     156,  176,  197,  219,  242,  266,  291,  318,
     345,  373,  403,  433,  465,  497,  530,  565,
     600,  636,  672,  710,  749,  788,  828,  869,
     910,  952,  995, 1038, 1082, 1127, 1172, 1218,
    1264, 1311, 1358, 1405, 1453, 1501, 1550, 1599,
    1648, 1697, 1747, 1797, 1847, 1897, 1947, 1997 };

  // setup chip
  mcp4725Setup(100,MCP4725);

  if (argc &gt; 1) {
    analogWrite(100, output);
  } else {
    for (;;) {
      for (i = 0; i &lt; sizeof(sine)/sizeof(sine[1]); ++i) {
        analogWrite(100, sine[i]);
      }
    }
  }

  return 0;
}
```

build and run in the examples directory with:

```bash
make dac<br />
./dac 4095 #output Vdd<br />
./dac #output repeating sine wave
```

<figure id="attachment_691" aria-describedby="caption-attachment-691" style="class=wp-caption aligncenter">
<img loading="lazy" src="/assets/img/uploads/2015/03/download.png" alt="Using my driver for wiringPi, a sine wave being produced by the MCP4725" class="size-large wp-image-691" /><figcaption id="caption-attachment-691" class="wp-caption-text">Using my driver for wiringPi, a sine wave being produced by the MCP4725</figcaption></figure>
