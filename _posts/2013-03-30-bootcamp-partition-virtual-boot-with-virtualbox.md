---
id: 235
title: BootCamp Partition Virtual Machine with VirtualBox
date: 2013-03-30T14:52:41+00:00
author: John
layout: post
guid: /?p=235
permalink: /2013/03/bootcamp-partition-virtual-boot-with-virtualbox/
image: assets/img/uploads/2013/03/Screen-shot-2013-03-30-at-15.16.54-1000x288.png
categories:
  - Programming
tags:
  - guide
  - linux
---
I&#8217;ve had a BootCamp partition on my Macbook since it bought it; I waited specifically for the Intel CoreDuo Macbooks. Sometimes I don&#8217;t want to restart just to run an app or test something out, so developed this bash script to boot it using Virtual Box.

<!--more-->

[VirtualBox](https://www.virtualbox.org/) is an extremely powerful virtualisation platform that is amazingly free. I&#8217;ve used the more Mac like VMs (and pricey) but have found VirtualBox to trump them in term of features and control with command line interaction. Like more open source and powerful programs, it requires a fair bit of research to use it beyond a basic VM. Hopefully this post will help others tackle the useful ability of booting a hard partition like a virtual disk, giving you the best of both worlds and not requiring management of two installations. It should work on any other Unix platform too.

I used the info from a few other blogs for this and most permanently unmounted the Windows volume or required user interaction. I made a script to avoid this and enable me to simply enter `bootcamp` into Terminal.

  1. Get the partition of your BootCamp install using `diskutil list`, it&#8217;s the /dev/disk* listed under what your named your partition.</p> 
  2. `sudo chmod 777 /dev/disk0s3` using the correct partition numbering you found above (replace /dev/disk0s3 onwards).

  3. `diskutil umount /dev/disk0s3` &#8211; ejects the Windows partition.

  4. `sudo VBoxManage internalcommands createrawvmdk -rawdisk /dev/disk0 -filename bootcamp.vmdk -partitions 3` &#8211; creates the virtual disk to boot the partition, the number after the &#8216;partitions&#8217; argument must match the partition on your disk (number after s).

  5. `sudo chown YOUR-USERNAME *.vmdk` &#8211; ensures you own rights to the files created.

  6. Run VirtualBox and create a new Windows machine. Set the settings as you want but when asked to select a hard drive, choose &#8216;existing disk&#8217; and browse for the &#8216;bootcamp.vmk&#8217; created in the above steps (it will be in your &#8216;Home&#8217; directory if you just opened Terminal fresh).

  7. Highlight the machine, choose &#8216;Settings&#8217;. In &#8216;Storage&#8217; change the type to &#8220;ICH6&#8221; &#8211; this caused me problems at the default.

The virtual machine should now be booting your BootCamp installation just fine. The problem comes when you restart, the partition will auto-mount and permissions will be lost. This is where my script comes in.

**26/02/2016 UPDATE: After a Virtual Box update my bootcamp stopped working with &#8216;VERR\_NOT\_SUPPORTED&#8217; error. After some digging, I found you have to enable &#8216;Use Host I/O Cache&#8217; in Settings -> Storage -> Controller:SATA.**

Second to the permission problem, I was recieving the error &#8216;VERR\_FILE\_NOT_FOUND&#8217; every few boots. Many attribute this to the permissions not being set but even after `chmod` I would still get the error. It turned out that since I now have [](/2012/09/macbook-core-duo-goes-solid-state/ "two disks") in my Macbook, sometimes the mount points would change at boot (SDD disk1 not disk0) leaving the virtual disk referring to a non-existent partition.

The .vmdk can be edited using a text editor and contains the line `RW 78125000 FLAT "/dev/disk1s3" 0`, clearly referring to the physical disk. Correcting this stopped the error. So my script is a little more complex than some but makes it almost flawless. The operation is:

  * Find and set the variable `disk` as the correct BootCamp mount point (using `mount</code piped with <code>grep Windows`
  * Set full permissions to `$disk`
  * Unmount `$disk`
  * Using `awk` look at line 12 of bootcamp.vmdk to check if it is referring to the right place.
  * Boot the virtual machine if it is, otherwise signal it is not
  * Plenty of ASCII like any good bash script!

I also included the additional `remount` arg to remount the volume once I&#8217;ve finished using machine.

Copy and paste the below into a text file, then save it in /usr/local/sbin

<pre><code class="bash">#!/bin/sh
printf '\e[31m
 ______     ______     ______   ______   __     __   __     ______        __  __     ______      ______     ______     __    __     ______     
/\  ___\   /\  ___\   /\__  _\ /\__  _\ /\ \   /\ "-.\ \   /\  ___\      /\ \/\ \   /\  == \    /\  ___\   /\  __ \   /\ "-./  \   /\  == \    
\ \___  \  \ \  __\   \/_/\ \/ \/_/\ \/ \ \ \  \ \ \-.  \  \ \ \__ \     \ \ \_\ \  \ \  _-/    \ \ \____  \ \  __ \  \ \ \-./\ \  \ \  _-/    
 \/\_____\  \ \_____\    \ \_\    \ \_\  \ \_\  \ \_\\"\_\  \ \_____\     \ \_____\  \ \_\       \ \_____\  \ \_\ \_\  \ \_\ \ \_\  \ \_\      
  \/_____/   \/_____/     \/_/     \/_/   \/_/   \/_/ \/_/   \/_____/      \/_____/   \/_/        \/_____/   \/_/\/_/   \/_/  \/_/   \/_/      

'
if [ "$1" == "remount" ]; then
  diskutil mount /dev/disk0s4
else
  #Get mount point of bootcamp
  disk=$(mount | grep 'Windows' | cut -d" " -f1)
  printf "\e[1;31m\e[47mSetting up permissions....\e[0m\n"
  chmod 777 $disk
  printf "\e[1;31m\e[47mUnmounting Bootcamp parition ($disk)....\e[0m\n"
  diskutil umount $disk
  line=$(awk 'NR==12' ~/VirtualBox\ VMs/Bootcamp/bootcamp.vmdk)
  if [ "$line" != "RW 78125000 FLAT \"$disk\" 0" ]; then
    printf "\e[1;37m\e[41mThe virtual machine is refering to the wrong partition and will not boot!!\e[0m\n"
  else
  printf "\e[1;31m\e[47mStarting virtual machine....\e[0m\n"
  sudo -u John vboxmanage startvm 'VirtualCamp'
  export disk=$disk
fi 
</code></pre>

How it looks when it runs:

[<img loading="lazy" src="/assets/img/uploads/2013/03/Screen-shot-2013-03-30-at-15.16.54-1024x660.png" alt="BootCamp VM Bash Script" width="584" height="376" class="aligncenter size-large wp-image-238" srcset="/assets/img/uploads/2013/03/Screen-shot-2013-03-30-at-15.16.54-1024x660.png 1024w, /assets/img/uploads/2013/03/Screen-shot-2013-03-30-at-15.16.54-300x193.png 300w, /assets/img/uploads/2013/03/Screen-shot-2013-03-30-at-15.16.54-465x300.png 465w, /assets/img/uploads/2013/03/Screen-shot-2013-03-30-at-15.16.54.png 1148w" sizes="(max-width: 584px) 100vw, 584px" />](/assets/img/uploads/2013/03/Screen-shot-2013-03-30-at-15.16.54.png)