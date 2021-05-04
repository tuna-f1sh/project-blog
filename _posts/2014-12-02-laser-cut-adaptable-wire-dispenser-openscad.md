---
id: 457
title: Laser Cut Adaptable Wire Dispenser in OpenSCAD
date: 2014-12-02T19:32:50+00:00
author: John
layout: post
guid: /?p=457
permalink: /2014/12/laser-cut-adaptable-wire-dispenser-openscad/
image: assets/img/uploads/2014/12/IMG_0899.jpg
categories:
  - Fabrication
  - Mechanical
  - Programming
tags:
  - CAD
  - design
  - laser cut
  - wood
---
I wanted a wire dispenser that wasn&#8217;t fixed in place so I could move it to where I was working. To my surprise, such a thing doesn&#8217;t exist (I couldn&#8217;t seem to find fixed ones either, other than using a kitchen towel rail). Keen to put my new found love for [_OpenSCAD_](http://www.openscad.org/) to use, I set about making such a thing.
<figure id="attachment_473" aria-describedby="caption-attachment-473" style="width: 640px" class="wp-caption aligncenter">
<img loading="lazy" class="wp-image-473 size-full" src="/assets/img/uploads/2014/12/assembly.png" alt="The projection()&#96; command in *OpenSCAD* allows one to easily create 3d objects that can be exported as 2d .dxf for printing" /><figcaption id="caption-attachment-473" class="wp-caption-text">The projection() command in OpenSCAD allows one to easily create 3d objects that can be exported as 2d .dxf for printing</figcaption></figure> 

_OpenSCAD_ really suits this type of design requirement; something that is going to need to scale user defined variables (the wire reel in this case). I didn&#8217;t want to create a design for 6 wire reels from a specific manufacturer, then find they change their spindle, or I decide I need more reels. It&#8217;s particularly hard scaling a laser cut box because of all the teeth/dents that slot it together. With a GUI based CAD program, you&#8217;d send hours fiddling around with the spacings/length or trying to create patterns &#8211; then still ending up with bits that don&#8217;t fit together! This is actually my second project in _OpenSCAD_ that I&#8217;d bashed together quickly. I&#8217;ve got another more complex project to document too.  

Well designed OpenSCAD code allows distances to be created exactly the right size by defining the laser kerf &#8211; vital for creating slotted designs with glueless tolerances &#8211; and for the whole thing to scale gracefully to the new conditions.  I&#8217;m not saying mine is necessarily that well designed (i&#8217;m still learning!) but it does the job. The header of my wire dispenser code looks like this:

```c
/* ==================================*/

// --- OBJECT DIA AND SETTINGS ---

// Reel Info
reelOD = 70; // reel outer diameter
reelID = 25; // reel inner diameter
reelW = 31; // reel = 18; // supporting dowel outer dia
buffer = 10; // buffer around the edges of reels
trim = 3/4; // trim to height by this fraction since the reels don't need to be fully enclosed

// Reel Settings
noReels = 6; // number of wire reels to hold
reelSpacing = 1; // buffer between reels
wireDia = 2; // dia of wire

spacing = 2; // spacing between dxf export for print

// Slot
// Tweak these till it looks right
baseSlots = 24; // number of slots in base
sideSlots = 8; // number of slots on sides

// Laser cutter beam kerf
LaserBeamDiameter = 0.23;
// Material characteristic
materialThickness = 3.20;

// --- COMPILE SETTING ----
// make export true if you want to create DXF print sheet, otherwise 3D render is created to visualise
export = false;
```

A wire dispenser to these requirements is then created. I&#8217;ve created one for the lab and will also created one for my own wire requirements. [I&#8217;ve listed the code on github](https://github.com/tuna-f1sh/wire-dispenser) if you want to make one/have a look. The real party trick of _OpenSCAD_ is `projection()`, which creates 2d silhouettes of 3d objects, allowing the code to have a mode which creates an assembly to visually check, and one that creates the .dxf for printing.

For further reading, [Matt Venn documents making a CNC cut box with _OpenSCAD_](http://www.mattvenn.net/2013/02/17/using-openscad-for-2d-machining/), which orginally inspired me to look at it.

<img src="/assets/img/uploads/2014/1sembly.png" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-10-473" />

<img src="/assets/img/uploads/2014/12/print.png" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-10-474" />

<img src="/assets/img/uploads/2014/12/IMG_0899.jpg" class="attachment-thumbnail size-thumbnail" alt="" loading="lazy" aria-describedby="gallery-10-475" />
