---
id: 103
title: MacBook Core Duo Goes Solid State
date: 2012-09-05T16:12:36+01:00
author: John
layout: post
guid: /?p=103
permalink: /2012/09/macbook-core-duo-goes-solid-state/
image: assets/img/uploads/2012/09/2012-09-04-20.21.28.jpg
categories:
  - Modification
tags:
  - apple
  - computing
  - guide
---
My MacBook is the 2006 original; the white Core Duo 32bit. I got it upon starting University and that ended up taking six years. Amazingly, it is still going strong and whilst I want a nice retina MBP, it would be truly frivolous, given how well this one still runs.

Over the years I have given it a number of upgrades: 70GB > 500GB HDD, 512MB > 2GB (max for Core Duo) ram, new battery and a complimentary top deck from Apple (long story). Now I was turning to an SSD.

Computer technology has somewhat stagnated in my opinion, from the days when hardware was obsolete within a year and I constantly had the side off my PC. Unless you&#8217;re looking to run the newest games at excessive FPSs ([and many of those are using > 6 year old engines!](http://store.steampowered.com/app/730/)), optimal day to day use was achieved back when I bought my MacBook. I think this is confirmed by the fact that the technology race is now for size and power efficiency, than GHz. The only thing holding my MacBook back now is that it is a 32bit and so software is going to make it redundant &#8211; it can&#8217;t run Apple&#8217;s latest OS, Mountain Lion.

<figure id="attachment_104" aria-describedby="caption-attachment-104" class="wp-caption aligncenter">
<img loading="lazy" src="/assets/img/uploads/2012/09/IMGP0585.jpg" alt="" title="Water Cooled PC" class="size-medium wp-image-104" /><figcaption id="caption-attachment-104" class="wp-caption-text">Back in my computing hay day, when I was into overclocking.</figcaption></figure> 

Anyway, the purpose of this post: My experience with solid state drives (SSD). With their prices tumbling, and a desire to get more space on the MacBook to transition over to Arch now Apple and abandoned me, I went for a [Samsung 830 256GB](http://www.samsung.com/us/computer/memory-storage/MZ-7PC256D/AM).

I indecisive about the upgrade, since I was shelling out £130 on old hardware and didn&#8217;t really need it. The difference is incredible though, and well worth the money. I hadn&#8217;t realised how much of a bottleneck the hard disk is but I guess with everything else at it&#8217;s peak it makes sense. It&#8217;s honestly like a brand new laptop and it isn&#8217;t even a fresh install! (I used Carbon Copy Cloner).

## The benefits:

1. **Power Consumption:** Without a platter to spin up, power consumption and battery life has increased. In order to maximise this with the dual SSD/HDD setup, use this command to shut the disk down after 1min of inactivity: `pmset -a disksleep 1`.
2. **Silence:** Again, no moving parts means my MacBook is silent when not doing anything intense (you can&#8217;t hear the fan).
3. **More Space:** The SSD is smaller than my old disk, but I&#8217;ve now stuck that in the optical bay (below).

## Swapping the Optical Drive for a HDD

Since I needed more than the 256GB SSD and am not a fan of lugging external disks around, I wanted to swap my useless optical drive for my old HDD. I hoped the optical was SATA and I could just duck tape the thing in, unfortunately, these MacBooks use PATA drives (PITA!). You can buy [special MacBook HDD/SSD caddies for $50](http://www.mcetech.com/optibay/) but to my eyes the optical drive was an off the shelf laptop job. Sure enough, I was right, and a search on eBay found me a [universal PATA-SATA caddy](http://www.ebay.co.uk/itm/120966267526?ssPageName=STRK:MEWNX:IT&_trksid=p3984.m1497.l2649) (the MacBook uses 9.5mm).

<figure id="attachment_105" aria-describedby="caption-attachment-105" class="wp-caption aligncenter">
<img loading="lazy" /><figcaption id="caption-attachment-105" class="wp-caption-text">The standard 9.5mm one does the job for £10</figcaption></figure> 

<figure id="attachment_106" aria-describedby="caption-attachment-106" class="wp-caption aligncenter"><img loading="lazy" src="/assets/img/uploads/2012/09/2012-09-04-20.21.28.jpg" alt="" title="MacBook with SDD / HDD Combo" width="584" height="435" class="size-large wp-image-106" /><figcaption id="caption-attachment-106" class="wp-caption-text">Electrical tape because I&#8217;ve had to re-paste the heatsink and fix the fan in it&#8217;s six year life!</figcaption></figure> 

So if your computer is feeling sluggish, I can whole heartily recommend an SSD. I think it&#8217;s taken over as the best upgrade now ram comes in copious quantities.
