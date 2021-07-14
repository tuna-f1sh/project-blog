---
id: 1362
title: Pi-Hole and Smokeping using Same lighttpd Service
date: 2019-12-09T17:10:03+00:00
author: John
layout: post
guid: /?p=1362
permalink: /2019/12/pi-hole-and-smokeping-using-same-lighttpd-service/
categories:
  - Programming
---
I was having random &#8211; or not so random &#8211; internet dropouts on a 4G WiFi router. I wanted to ascertain when they occur and if it&#8217;s internal wireless or WAN to troubleshoot. `smokeping` is an old but useful tool to capture this as it sits in the background constantly pinging pre-defined servers.

Since I had a Pi-Hole on the network, this seemed the best tool. Getting the web-portal up and running requires some tinkering however to run as part of the existing Pi-Hole lighttpd web server.

Turns out the correlation is with trains and rush hour! I live near a train station and as a train comes to the station at peak times, the contention ratio on the 4G mast must go through the roof and my internet crawls…Either that or the electric train lines are EMC bandits!

**Warning: Steps below worked on PiHole 4.0 and were captured post-process for my own documentation; it is not a concrete guide and some system knowledge is probably required**

## Install Smokeping

```bash
sudo apt install smokeping
```

## Smokeping Setup With Pihole Lighttpd

```bash
# enable cgi
sudo ln -s /usr/share/smokeping/www /var/www/html/smokeping
sudo cp /var/www/html/smokeping/smokeping.fcgi.dist /var/www/html/smokeping/smokeping.fcgi
echo 'exec /usr/lib/cgi-bin/smokeping.cgi /etc/smokeping/config' >> /var/www/html/smokeping/smokeping.fcgi
```

## Setup Fast cgi /etc/lighttpd/conf-available/10-fastcgi.conf

```bash
fastcgi.server += (
  "smokeping.fcgi" => ((
    "socket"   => "/var/run/lighttpd/fcgi.socket",
    "bin-path" => "/usr/share/smokeping/www/smokeping.fcgi"
  ))
)
```

```bash
sudo lighttpd-enable-mod fastcgi
sudo /etc/init.d/lighttpd force-reload
```

## Check Route

<http://localhost/smokeping/smokeping.fcgi>

## Redirect Smokeping Route to Fast cgi File

In _/etc/lighttpd/lighttpd.conf_

```bash
$HTTP["url"] =~ "^/smokeping/" {
         url.redirect  = ("^/smokeping/?$" => "/smokeping/smokeping.fcgi")}
```

Now one can simply navigate to [pihole.local/smokeping](pihole.local/smokeping)
