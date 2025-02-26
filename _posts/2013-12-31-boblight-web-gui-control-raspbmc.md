---
id: 310
title: Boblight Web GUI Control RaspBMC
date: 2013-12-31T10:44:33+00:00
author: John
layout: post
guid: /?p=310
permalink: /2013/12/boblight-web-gui-control-raspbmc/
categories:
  - Programming
tags:
  - guide
  - linux
  - raspberrypi
---
<img loading="lazy" src="/assets/img/uploads/2013/12/Screen-Shot-2013-12-31-at-10.21.22.png" alt="Boblight GUI Control" class="aligncenter size-full wp-image-312" />

Since [setting up an boblight on my RaspBMC](/2013/08/boblight-with-raspbmc-ambilight-clone/ "Boblight with Raspbmc – Ambilight Clone"), I&#8217;ve been wanting a nice gui to manage it; turn it on and off, change colours.

I was going to make a plugin to improve my Python knowledge but decided a web plugin would be more flexible as it would be controllable from any device. Using [Chris Oattes&#8217; TV Control page](http://www.cjo20.net/blog/?p=73) as base, I moulded the PHP to be compatible with the standard RaspBMC setup, which currently uses the `boblight-dispmanx` service. The standard XBMC web server doesn&#8217;t support PHP and I couldn&#8217;t figure a way of getting it to, so my solution requires setup of another lightweight webserver: `lighttpd`:

```bash
sudo apt-get update
sudo apt-get install lighttpd
sudo apt-get install php5-common php5-cgi php5
sudo lighty-enable-mod fastcgi-php
```

You&#8217;ll get an error as `lighttpd` will try to assign to the default web port 80 but `libmicrohttpd` will already be running on that. You could disable it but I use for remote control. Instead change the default port to something else, I use 3000:

```
vi /etc/lighttpd/lighttpd.conf
```

Change `server.port = 80` to 3000. Then `sudo service lighttpd force-reload`

Set the permissions for the server folder:

```bash
sudo chown www-data:www-data /var/www
sudo chmod 775 /var/www
sudo usermod -a -G www-data pi
```

Now all that is left is to copy my boblight control page to the `/var/www` directory:

```bash
wget /boblight.tar.gz
tar -zxvf boblight.tar.gz
mv -r boblight /var/www
chmod -R 775 /var/www/boblight
```

Visit http://[your raspbmc ip]:3000/boblight to set any static LED colour, disable the dynamic lights or turn off the lights all together. I plan on adding function to edit the `boblight.conf` settings and implementing some more visual effects.
