---
id: 362
title: MATLAB Finite Difference Time Domain Acoustic Modelling
date: 2014-05-12T19:58:02+01:00
author: John
layout: post
guid: /?p=362
permalink: /2014/05/matlab-finite-time-difference-method-acoustic-modelling/
image: assets/img/uploads/2014/05/Capture2.png
categories:
  - Programming
tags:
  - acoustics
  - FDTD
  - featured
  - MATLAB
---
As part of MACH Acoustics&#8217; open window research, they wanted a FDTD model to visualise sound waves moving through various window opening scenarios. I created a FDTD function, that would create an impulse wave at a specified position then calculate discrete pressure points across a defined grid size and time step. 

Geometry (boundary conditions) could be loaded loaded into the function using scripts for different objects (opening, top/bottom swing window, baffle, etc), video saved and pressure, mic, time step data saved for repeat plotting (the solver took a few minutes to run so being able to plot existing data saved time). There is no currently no absorption so the sound does not decay, reflecting 100%. For short periods however this does not hinder the visualisation too drastically.

<figure id="attachment_374" aria-describedby="caption-attachment-374" style="width: 584px" class="wp-caption aligncenter">
<img loading="lazy" src="/assets/img/uploads/2014/05/Capture.png" alt="A GUI I created to control the simulation settings." class="size-large wp-image-374" /><figcaption id="caption-attachment-374" class="wp-caption-text">A GUI I created to control the simulation settings.</figcaption></figure> 
