---
title: Ceramic Nixie Tube Clock
date: 2022/11/01
tags: mechanical, electronics, programming, fabrication
image: assets/img/nixie-clock/header.jpg
layout: post
---

It's been six years since my [Nixie Pipe project]({% post_url 2016-12-14-nixie-pipe-modern-day-led-nixie-tube %}) - my interpretation of a modern day [Nixie Tube](https://en.wikipedia.org/wiki/Nixie_tube). Whilst the project was successful and has merit as an Nixie Tube alternative, an element of the inspiration was perhaps shying away from the electronic design challenge of a _real_ Nixie Tube project.

So I decided now was the time to do the fabled project of an Electronic Engineer: a Nixie Tube project. Not to say it's the most challenging electronics in the world, more that it's a digestible one for a side-project with some interesting analogue and digital design choices to make; Drop-in hV supply or custom design? Shift registers and MOSFETs, hV LED drivers, hV shift registers or retro Nixie drivers?

The main interest for me was the hV supply and case design - since the case is where one can make it unique. Like my [Linear Clock]({% post_url 2021-06-16-linear-clock %}) I ended up with two designs again! One is a CNC aluminium case with a solar indicator and the other is a 3d printed ceramic case - something I've wanted to try for a while.

## Electronics

I wanted to design the high-voltage (hV) supply into the controller - rather than pick something off the shelf - as this was one of the more interesting aspects of the project. Using the excellent [report by Tony](https://hackaday.io/project/162301-high-voltage-nixie-power-supply) as a reference, the controller features a LT3757EMSE configured as a flyback converter. It's essentially the application example on pg.32 but with a digital pot in the feedback loop so that the controller can adjust the output voltage as required. I thought it might to be useful to control this to _overdrive_ the tubes if required or adjust brightness but didn't use it in the end.

The converter is most efficient at higher than standard USB input voltages so I added a USB-PD controller. It's nice to have the option but in practice the clock works fine at USB-2.0 5 V/500 mA - I would probably DNF this circuitry next time.

The remaining design is something tried and tested for me: SAMD21 microcontroller, DS3232 RTC, logic shifters for WS2812B LEDs and Molex connectors for the touch buttons/IO. I'm happy to report revision 0 of the controller worked without any bodge wires 😁!

[JBR Nixie Tube Clock Controller Schematic](/assets/jbr-nixie-in-12-clock-r1.pdf)

### Touch Buttons

Every clock needs a way to set it, which offers another area to play! I had a basic idea of how I wanted the case to look at this point and knew I wanted touch pads not buttons. The touch input was initially provided by the [MPR121](https://www.nxp.com/docs/en/data-sheet/MPR121.pdf) on an external board. The part is end of life however and so I've since developed a direct to GPIO [solution](https://github.com/tuna-f1sh/RBD_QTouchButton) using the SAMD21's QTouch peripheral.

The touch inputs connect to aluminium (not anodised for conduction unlike the case) touch pads.

### IN-12A/B Carrier Modules

With the hV supply on the controller, it didn't leave much land for lots of through-holes to mount the IN-12 tubes directly. Modules also allow quick replacement in case of burn out so this is the route I went down. The next choice was the switching method.

I explored shift registers with transistors, shift registers with high voltage sinking etc. but none had the right number of channels to be mounted directly on a module, complicating the routing. I came across the [Exixie](https://github.com/dekuNukem/exixe) modules a while back and actually started making some so decided to base my modules on this. I replaced the STM32F0 part for a PCA9685PW - the same control but cheaper and no programming required. For redundancy, the controller and firmware actually supports both the SPI Exixe and I2C PCA9685PW - take that chipageddon!

[JBR IN-12A/B Module Schematic](/assets/jbr-in-12-module-r0.pdf)

![](/assets/img/nixie-clock/hardware/DSC_0360.jpg)
__My IN-12A/B Nixie Tube module. A [PCA9685BS](https://www.nxp.com/docs/en/data-sheet/PCA9685.pdf) 16 channel PWD controller, 10 [BF820W](https://assets.nexperia.com/documents/data-sheet/BF820W.pdf) NPN high-voltage transistors, RGB LED and passives. It's footprint matches the Exixe and the addressing of the PCA9685BS allows upto 62 modules, so it's not going to be a limiter.__
![](/assets/img/nixie-clock/hardware/DSC_0355.jpg)
__Low stack headers mean the modules don't add much stack compared to being soldered straight into controller. I toyed with pin sockets but opted against in favour of better clearances.__
![](/assets/img/nixie-clock/hardware/DSC_0334.jpg)
__My controller left to right: [LT3757EMSE](https://www.analog.com/media/en/technical-documentation/data-sheets/lt3757-3757a.pdf) configured as a flyback high voltage supply (170 V) with optional digital pot for uC setpoint control. STUSB4500 USB-PD controller for > 5 V input voltage to improve flyback efficiency - will work at USB-2.0 5 V/500 mA too. SAMD21, DS3232 RTC, IO and logic shifters for WS2813B LEDs.__

## Cases

With the electronics done, next was the part looked at every day. I went for a fairly simple rectangle with a bit of my own spin; nice radii and smooth lines. Up top are areas for two slightly raised touch pads. On the bottom, a foot tilts the case to an angle that is nearer to one's eyeline when on a desk.

Initially I made a resin then aluminium case because these were easy to prototype. Something about ceramic and Nixie Tubes got me going though - maybe because ceramic is often used as a hV isolator? Finding Olaf at [Seremik](https://seremik.ch/?lang=en) in Switzerland, he explained how to adapt the design and we made a ceramic version.

The ceramic one is one I like most. Whilst the solar clock part of the aluminium one is cool, I actually wanted to avoid LEDs in this project. Additionally, having been into ceramics when at school it feels like coming full circle in my life of projects. I actually made it as a 70th birthday present for my mother, to go with all my school ceramic pieces!

### Aluminium Solar Clock

I intended the foot to be made from wood or plastic. Waiting for parts to arrive and wanting to do more with the sun clock function in my [Linear Clock]({% post_url 2021-06-16-linear-clock %}), I ended up making a translucent foot. An LED strip diffuses through the foot, with the _sun_ (LED) moving from the left to right side throughout the daylight hours - repeating with a _moon_ hue at night. The LED palette attempts to mirror the sun's at that coordinate position. It's best understood watching the [video](https://youtu.be/eiXbshH5SjY?t=108) or animation below.

<div class="box">
    <img src="/assets/img/nixie-clock/nixie-clock-solar.gif"/>
</div>

![](/assets/img/nixie-clock/aluminium/DSC_0501.jpg)
__Midday the sun (LED) position is near enough middle.__
![](/assets/img/nixie-clock/aluminium/DSC_0496.jpg)
__LED bar and tube illumination off__
![](/assets/img/nixie-clock/aluminium/DSC_0449.jpg)
![](/assets/img/nixie-clock/aluminium/DSC_0309.jpg)
![](/assets/img/nixie-clock/aluminium/DSC_0317.jpg)
__In set settings mode the bottom bar is full magenta!__
![](/assets/img/nixie-clock/aluminium/DSC_0391.jpg)
![](/assets/img/nixie-clock/aluminium/DSC_0388.jpg)
__The body is anodised, the buttons are not in order to isolate them from the case.__
![](/assets/img/nixie-clock/aluminium/DSC_0387.jpg)
__Light diffuser foot. I have the intention of making a wooden foot too.__
![](/assets/img/nixie-clock/aluminium/DSC_0382.jpg)
__Clear rear panel to show off the electronics but prevent accidental shocks. Yes I did shock myself more than once 🤦👈...__
![](/assets/img/nixie-clock/aluminium/DSC_0381.jpg)

[Dropbox folder with more photos](https://www.dropbox.com/sh/c0p42ch8rv73797/AACrwQgwomrfLwGUCbuhZ-fXa?dl=0)

### Printed Ceramic

Adapting the case for ceramic printing involved a bit of back and fourth. Unlike other 3d printing materials, the wet clay remains wet as it prints. The result is that supports aren't an option, ruling out even minor overhangs like the radii on the case.

The front of the case is flat for this reason but I don't think it takes much away as the imperfect, organic form of the clay adds interest. Talking of the imperfect form, the tube openings have enough tolerance for the tubes to fit and the wavy ceramic finish is not dissimilar to the blown glass tubes. It was hard to get the machined touch buttons in place however, without gaps (or only small ones)!

Unlike the machined case, which includes PCB mounts and tapped holes for the rear panel, neither were options for the ceramic case. Instead, I created a PCB carrier that is adhered to the ceramic and glued magnets to hold the rear panel.

Overall I think the outcome is great and it's near to what I envisaged. I particularly like how the white glaze reflects the glowing tubes.

![](/assets/img/nixie-clock/ceramic/DSC_0520.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0512.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0491.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0423.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0419.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0413.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0410.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0402.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0394.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0376.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0374.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0368.jpg)
![](/assets/img/nixie-clock/ceramic/DSC_0349.jpg)

[Dropbox folder with more photos](https://www.dropbox.com/sh/c0p42ch8rv73797/AACrwQgwomrfLwGUCbuhZ-fXa?dl=0)

## Video

<div class="box">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/eiXbshH5SjY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
