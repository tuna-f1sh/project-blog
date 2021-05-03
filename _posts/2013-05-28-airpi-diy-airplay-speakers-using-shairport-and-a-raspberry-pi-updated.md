---
id: 270
title: 'AirPi: DIY Airplay Speakers using Shairport and a Raspberry Pi Updated'
date: 2013-05-28T09:36:06+01:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=270
permalink: /2013/05/airpi-diy-airplay-speakers-using-shairport-and-a-raspberry-pi-updated/
categories:
  - Programming
tags:
  - guide
  - ios
  - linux
  - raspberrypi
---
[My last AirPi post](http://engineer.john-whittington.co.uk/2012/08/airpi-diy-airplay-speakers/) has been popular &#8211; and still is &#8211; but part of why of like Arch linux is that it is constantly updating so you must be hands on, learning a new part of the OS the hard way!

Since my post a year ago, Shairport has some new features and dependencies, and Arch has moved to the _systemd_ service manager, changing the tutorial process somewhat. In order to update it, I have run through the process with the current build (2013-02-11).

<!--more-->

The initial steps are the same:

# Install Pacman Packages

<pre>pacman -Syu</pre>

Next you&#8217;ll need to install the tools required to compile in Arch.

<pre>pacman -S kernel26-headers file base-devel abs</pre>

Then git to clone the Shairport repo.

<pre>pacman -S git</pre>

Shairport has a number of dependencies so we&#8217;ll install them and there dependencies too.

<pre>pacman -S avahi libao openssl perl-crypt-openssl-rsa perl-io-socket-inet6 perl-libwww</pre>

A new dependency for Shairport is _perl-net-sdp_. This isn&#8217;t a package yet in the pacman repos so must be installed from the [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository#Installing_packages).

**READ THE UPDATES BELOW IF YOU HAVE PROBLEMS AT THIS STEP**

<pre>pacman -S wget
wget https://aur.archlinux.org/packages/pe/perl-net-sdp/perl-net-sdp.tar.gz
tar -zxvf perl-net-sdp.tar.gz
cd perl.net.sdp
makepkg -s
pacman -U perl.net.sdp.pkg.tar.gz</pre>

Finally, alsa is required to get sound output in Arch on the RPi.

<pre>pacman -S alsa-utils alsa-firmware alsa-lib alsa-plugins</pre>

Change the default output to the 3.5mm jack

<pre>amixer cset numid=3 1</pre>

After all the installs, best to reboot

<pre>shutdown -r now</pre>

# Make Shairport

Create a directory to do the build

<pre>mkdir shairport</pre>

Now clone the repo, `cd` into it and `make`.

<pre>git clone https://github.com/albertz/shairport.git shairport
cd shairport
make</pre>

All being well, Shairport should have built and you can now run it with the name &#8216;AirPi&#8217;.

<pre>./shairport.pl -a AirPi</pre>

If all is well, install

<pre>make install</pre>

# Systemd

The biggest change is dropping `rc.conf` in favour of _systemd_. The sound module `snd-bcm2835` now autoloads but `Avahi` must be enabled as a service.

<pre>systemctl enable avahi-daemon</pre>

A .service file needs creating for _systemd_ to start Shairport as a service at boot. Create this using `vi` in `/etc/systemd/system/`

<pre>vi /etc/systemd/system/shairport.service</pre>

Copy this code

<pre>[Unit]
Description=Startup ShairPort (Apple AirPlay)
After=network.target
After=avahi-daemon.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/shairport -a AirPi -b 256 -d
ExecStop=/usr/bin/killall shairport
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target</pre>

Or you get use `wget` again and download mine:

<pre>wget http://engineer.john-whittington.co.uk/wp-content/uploads/2013/05/shairport.service -O /etc/systemd/system/shairport.service</pre>

Now enable the new service

<pre>systemctl enable shairport</pre>

## UPDATE MARCH 2014

I recently created another &#8216;AirPi&#8217; for my sister so went through these steps. As before, ArchPi has changed a few things. The main problem I came across was ivp6 being disabled, preventing Shairport binding to the socket. To enable it, change `ipv6.disable=1` in _/boot/cmdline.txt_ to false (0).

## UPDATE FEBRUARY 2015

More updates a year on. As a commenter has said, this tutorial is done as root (because that&#8217;s the default for the Arch ARM image). You can&#8217;t `makepkg` as root anymore. The solution is to create a build folder and sudo as a lower user:

`pacman -S sudo<br />
mkdir /home/build<br />
chgrp nobody /home/build<br />
chmod g+ws /home/build<br />
setfacl -m u::rwx,g::rwx /home/build<br />
setfacl -d --set u::rwx,g::rwx,o::- /home/build<br />
cd /home/build`

Copy extract the perl package from the AUR here then `sudo -u nobody makepkg` to make the package.

I also had issues with my file system becoming read only. To fix this edit &#8216;/boot/cmdline.txt&#8217; and add &#8216;rw&#8217; at the end of the line before &#8216;rootwait&#8217;, reboot.

Finally, James picked up that the audio quality is off now by default. To fix it:

`echo “use_mmap=no” >> /etc/libao.conf`