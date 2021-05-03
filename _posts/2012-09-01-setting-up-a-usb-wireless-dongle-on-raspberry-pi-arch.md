---
id: 95
title: Setting Up a USB WiFi Dongle on Raspberry Pi Arch
date: 2012-09-01T09:36:35+01:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=95
permalink: /2012/09/setting-up-a-usb-wireless-dongle-on-raspberry-pi-arch/
categories:
  - Programming
tags:
  - arch
  - guide
  - linux
  - networking
  - raspberrypi
  - wireless
---
For my [AirPi](http://engineer.john-whittington.co.uk/2012/08/airpi-diy-airplay-speakers/), I needed to make my Raspberry Pi wireless. Being the man of thrift that I am, I found the cheapest dongle on eBay: a [(Digitaz) RaLink RT5370](http://www.ebay.co.uk/itm/221074985041?ssPageName=STRK:MEWNX:IT&_trksid=p3984.m1497.l2649).

Now Arch isn&#8217;t exactly plug and play, but that&#8217;s part of the fun. Plugging it in, the only way you&#8217;ll know it is there is using:  
<!--more-->

<pre>lsusb
...
Bus 001 Device 004: ID 148f:5370 Ralink Technology, Corp. RT5370 Wireless Adapter 
...
</pre>

Linux includes module for RaLink adaptors: &#8216;rt2x00usb&#8217; and it turns out that they work with this adaptor too. Getting it running is a simple case of installing &#8216;wireless_tools&#8217;, then rebooting and letting udev do its thing and load the module up. Using `lsmod` it appears that &#8216;rt2x00usb&#8217;, &#8216;rt2x00lib&#8217;, &#8216;rt2800lib&#8217; and &#8216;rt2800usb&#8217; are all loaded, so you can use `modprobe` and load this modules manually.

# wpa-supplicant

You&#8217;ve got the adaptor connected, the process of actually using it to join a network require a few more steps. Start by the details of the network that you want to join to _/etc/wpa_supplicant.conf_, this is best achieved using `wpa_passphrase`, which converts the password to hex for you.

<pre>pacman -S wpa_supplicant
wpa_passphrase mywireless_ssid "secretpassphrase" >> /etc/wpa_supplicant.conf</pre>

Now bring the wireless device up (change wlan0 to your device).

<pre>ip link set wlan0 up</pre>

Then get wpa_supplicant to associate the adaptor with the first available network inf _wpa_supplicant.conf_.

<pre>wpa_supplicant -B -Dwext -i wlan0 -c /etc/wpa_supplicant.conf </pre>

The last thing to do is get an ip address using dhcp.

<pre>dhcpcd wlan0</pre>

# Connecting at Boot

<del datetime="2013-01-02T18:51:28+00:00">All of the above will require repeating on each reboot. To do this automatically, add the above to a script and add it to <em>/etc/rc.local</em>. Here is mine, which I placed in <em>/usr/local/sbin/wireless_up.sh</em></del>

<pre>#!/bin/bash
wpa_supplicant -B Dxext -i wlan0 -c /etc/wpa_supplicant.conf
dhcpcd wlan0
</pre>

**UPDATE 02/01/2013**  
The cross-through was pre-systemd being used as the service manager. Follow the instructions on the Arch wiki to set-up boot on current builds: [https://wiki.archlinux.org/index.php/Wireless#Manual\_wireless\_connection\_at\_boot\_using\_systemd](https://wiki.archlinux.org/index.php/Wireless#Manual_wireless_connection_at_boot_using_systemd)

Basically:

<pre>sudo systemctl enable wpa_supplicant@wlan0.service
sudo ln -s /etc/wpa_supplicant.conf /etc/wpa_supplicantwpa_supplicant-wlan0.conf # service looks here
$ cat /etc/systemd/network/wlan0.network
[Match]
Name=wlan0
[Network]
DHCP=yes
</pre>