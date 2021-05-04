---
id: 71
title: 'AirPi: DIY Airplay Speakers using Shairport and a Raspberry Pi'
date: 2012-08-28T10:20:02+01:00
author: John
layout: post
guid: /?p=71
permalink: /2012/08/airpi-diy-airplay-speakers/
categories:
  - Programming
tags:
  - guide
  - ios
  - linux
  - raspberrypi
---
We have speakers in all the ground floor rooms of our house, all driven from the same amp. It&#8217;s neat but controlling the input requires going back to the amp.

Surrounded by iDevices too and with apps like iPlayer, Spotify and home share on iTunes, being able to throw audio to the speaker system had to be done. Que [Airplay](http://www.apple.com/uk/itunes/airplay/), however, this requires a nice Airplay amp or getting an AirPort. I then found out about [Shairport](https://github.com/albertz/shairport), a program that emulates an AirPort&#8217;s Airplay function. With a Raspberry Pi kicking around, I had just found its new job.  
<!--more-->

**_Quite a lot has changed in the year since I did this and rather than try and add more updates to this, I have run through the process again and created a [new tutorial](/2013/05/airpi-diy-airplay-speakers-using-shairport-and-a-raspberry-pi-updated/)._**

# Setting Up Arch ARM

I opted for the Arch Pi distribution for this, simply because it is my Linux of the moment and with no window manager, is perfect for a standalone device. The first thing you&#8217;re going to want to do is a system update with pacman (you&#8217;ll probably need to update pacman on first run so need to do this twice).

<pre>pacman -Syu</pre>

Next you&#8217;ll need to install the tools required to compile in Arch.

<pre>pacman -S kernel26-headers file base-devel abs</pre>

Then git to clone the Shairport repo.

<pre>pacman -S git</pre>

Shairport has a number of dependencies so we&#8217;ll install them and there dependencies too.

<pre>pacman -S avahi libao openssl perl-crypt-openssl-rsa perl-io-socket-inet6 perl-libwww</pre>

Finally, alsa is required to get sound output in Arch on the RPi. Install this and then load the sound driver using `modprobe`.

<pre>pacman -S alsa-utils alsa-oss
modprobe snd-bcm2835</pre>

Alsa mutes the channels by default so open the mixer and raise the volume to 0dB gain. Test the output using `speaker-test`.

<pre>alsamixer
speaker-test -c 2</pre>

I&#8217;m using the 3.5mm jack as an audio output and at this stage I failed to get audio. I realised that with the HDMI plugged in, audio was going through that and not through the jack (it doesn&#8217;t seem to do both at once). You need to disconnect the HDMI and reboot the RPi. If you&#8217;re connected via monitor and want 3.5mm jack, there is no option but to continue via `ssh` or use the phono. I was doing it all via `ssh` so it didn&#8217;t really matter. If you do reboot, don&#8217;t forget to reload drivers using `modprobe` before testing again.

[ **update:** you can change output with using **`amixer cset numid=3 1`** &#8211; _[tomsolari.id.au](http://tomsolari.id.au/post/27169019561/airplay-music-streaming-on-raspberry-pi)_[](http://tomsolari.id.au/post/27169019561/airplay-music-streaming-on-raspberry-pi) ]

If all is good, save the alsa levels.

<pre>alsactl store</pre>

And set the sound modules and new daemons to load at startup by editing _/etc/rc.conf_

<pre>vi /etc/rc.conf
MODULES=(.. snd-bcm2835 ..)
DAEMONS=(.. dbus avahi-daemon alsa ..)</pre>

Probably a good idea to reboot at this stage.

<pre>shutdown -r now</pre>

# Make Shairport

Make a directory called Shairport in the home folder.

<pre>mkdir shairport</pre>

Now clone the repo, `cd` into it and `make`.

<pre>git clone https://github.com/albertz/shairport.git shairport
cd shairport
make</pre>

All being well, Shairport should have built and you can now run it with the name &#8216;AirPi&#8217;.

<pre>./shairport.pl -a AirPi</pre>

# Create daemon

**18/12/12 &#8211; This may not work now due to Arch builds now using `systemd`. If it doesn&#8217;t, [this comment thread](/2012/08/airpi-diy-airplay-speakers/#comment-18) has a solution.**  
Install the new build

<pre>make install</pre>

Shairport includes a sample `init` file but it is not designed for Arch. Arch includes a template for creating new daemons in _/usr/share/pacman/rc-script.proto_, first copy to _/etc/rc.d_

<pre>cp /usr/share/pacman/rc-script.proto /etc/rc.d/shairport</pre>

Now edit the file using vi as mine below

<pre>#!/bin/bash
daemon=shairport
daemon_name=shairport.pl

. /etc/rc.conf
. /etc/rc.d/functions

get_pid() {
    pidof -o %PPID $daemon_name
}

case "$1" in
    start)
        stat_busy "Starting $daemon"

        PID=$(get_pid)
        if [[ -z $PID ]]; then
            [[ -f /var/run/$daemon_name.pid ]] &&
                rm -f /var/run/$daemon_name.pid
        # RUN
        $daemon_name -d -a AirPi
        #
        if [[ $? -gt 0 ]]; then
            stat_fail
            exit 1
        else
            echo $(get_pid) &gt; /var/run/$daemon_name.pid
            add_daemon $daemon_name
            stat_done
        fi
        else
            stat_fail
            exit 1
        fi
        ;;

    stop)
        stat_busy "Stopping $daemon_name daemon"
        PID=$(get_pid)
        # KILL
        [[ -n $PID ]] && kill $PID &&gt; /dev/null
        #
        if [[ $? -gt 0 ]]; then
            stat_fail
            exit 1
        else
            rm -f /var/run/$daemon_name.pid &&gt; /dev/null
            rm_daemon $daemon_name
            stat_done
        fi
        ;;

    restart)
        $0 stop
        sleep 3
        $0 start
        ;;

    status)
        stat_busy "Checking $daemon_name status";
        ck_status $daemon_name
        ;;

    *)
        echo "usage: $0 {start|stop|restart|status}"
esac

exit 0

# vim:set ts=2 sw=2 et:</pre>

Add _shairport_ to the list of daemons in _etc/rc.conf_ and you&#8217;re all good to go.



# UPDATE 2:

I&#8217;ve since found a command to redistribute the Pi&#8217;s memory, providing less dropped audio (it doesn&#8217;t happen much anyway). By default, a certain amount is allocated to the GPU, since this is headless, we can remove that.

<pre>cd /boot
mv start.elf orig-start.elf
cp arm224_start.elf start.elf</pre>

# UPDATE 3:

Shairport has been updated to support iOS and with it now depends on _perl-net-sdp_. This can be installed from the [AUR](http://aur.archlinux.org/packages.php?ID=63217&detail=1) using [these instructions](https://wiki.archlinux.org/index.php/Arch_User_Repository)