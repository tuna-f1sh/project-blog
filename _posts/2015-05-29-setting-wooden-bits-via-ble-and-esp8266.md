---
id: 714
title: Setting Wooden Bits via BLE and ESP8266
date: 2015-05-29T14:40:32+01:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=714
permalink: /2015/05/setting-wooden-bits-via-ble-and-esp8266/
categories:
  - Electronics
  - Programming
tags:
  - arduino
  - ble
  - esp8266
  - IoT
---
My [laser cut binary clock, Wooden Bits](http://engineer.john-whittington.co.uk/2014/12/wooden-bits-binary-clock/), originally had no means to set the clock, other than at compile time. I later added a tactile button and ISR to provide this function (increment the time until the correct time is shown) but I wanted a way to tap into the extra features of the [DS3231](http://datasheets.maximintegrated.com/en/ds/DS3231.pdf) (alarm, temperature) and also to experiment in wireless control.

<!--more-->

First I tried a [Bluetooth LE module](http://www.adafruit.com/products/1697) that provided a UART link over BLE. Implementing this was as simple as adding a data callback function with command interpreter. I used the first char as a setting type ID (&#8216;s&#8217; set, &#8216;t&#8217;, temp, &#8216;a&#8217; alarm, &#8216;c&#8217; colour), followed by the data  to set. For example, to set the time to 09:34, one would send &#8216;s0934&#8217;. I also added visual feedback upon receipt of these commands.

To test the implementation, I used the Nordic BLE UART iOS app, which allows connection to a Nordic chip and a terminal to send/receive commands. In the long term I would design an app with GUI, which would invoke the serial commands behind the scenes.

Second I wanted to use an ESP8266 I had ordered a while ago with all the hype surrounding it. For the uninitiated, it&#8217;s a < £4 SoC with WiFi that provides wireless access to a microcontroller via serial in its most basic form. It is based around a 32-bit microcontroller with spare GPIO too, so can form projects on its own. For this project, I hooked it up to the serial of the Arduino.

Set-up as an access point, one can connect to the device and send HTTP get requests. These requests can then be read from the chip with the Arduino serial link, and the buffered data processed and acted upon. Similar to the BLE UART but with a bit more data handling due to the included HTTP header information and interfacing with the chip.

[<img loading="lazy" class="aligncenter size-full wp-image-720" src="http://engineer.john-whittington.co.uk/wp-content/uploads/2015/05/Capture.png" alt="Capture" width="800" height="835" srcset="/assets/img/uploads/2015/05/Capture.png 800w, /assets/img/uploads/2015/05/Capture-287x300.png 287w" sizes="(max-width: 800px) 100vw, 800px" />](http://engineer.john-whittington.co.uk/wp-content/uploads/2015/05/Capture.png)

To send the HTTP requests, I created a basic [Bootstrap](http://getbootstrap.com/) GUI, with a small amount of Javascript to parse the actual requests, eg:

`http://192.168.4.1/?set=1&amp;hour=13&amp;min=26`

The result is the same as using the BLE solution but the webpage makes it instantly cross-compatible. Here&#8217;s a video demonstrating both methods:



My initial experiences with both is that the BLE is much more reliable &#8211; it works 100% of the time &#8211; but is considerably more expensive. <del datetime="2015-07-18T17:26:25+00:00">The ESP8266 solution doesn&#8217;t always seem to receive the requests. I have ideas as to why this might be but need to perform more debugging.</del> This was due to using bit-banged serial rather than a hardware one &#8211; use a hardware serial and save software serial for debug.

I&#8217;ve branched the original code on GitHub for each solution:

  * [BLE Code](https://github.com/tuna-f1sh/wooden-bits/tree/bluetooth)
  * [ESP8266 Code](https://github.com/tuna-f1sh/wooden-bits/tree/esp8266)

&nbsp;

&nbsp;