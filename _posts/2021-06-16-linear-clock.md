---
title: Linear Clock
date: 2021/06/16
tags: mechanical, electronics, programming, fabrication
image: assets/img/linear-clock/linear-clock-max-kitchen-3.jpg
layout: post
---

My latest clock project has been the longest and most challenging to complete. There have been times when I've been tempted to can it or thought I'd reached a dead-end but persevered. I had to keep reminding myself that I do these projects primarily for the challenge, to learn new things and to further my knowledge: if it were simple I wouldn't have started.

Overall I'm now fairly happy with the outcome - an outcome which resulted in two designs! I've tried to compact the development's interesting points into this post, which also serves as a sort of script for the [video blog](https://www.youtube.com/embed/_xnCBslNjTs).

## Idea and Concept

I was keen to build a mechanical clock [^1], as my previous designs have been light based. Having worked with flip-dot displays, the sound of a well orchestrated electro-mechanical system is very pleasing and this is something I wanted to achieve. It would also present the multi-domain challenges that I seek.

[^1]: mechanical in the non-static sense rather than internal cogs and gears.

The [solar Apple Watch face](https://www.hodinkee.com/articles/the-eerie-beauty-of-the-apple-watch-solar-face-and-the-anatomy-of-nightfall) had drawn my inspiration for a while and I wanted to create a physical clock based on this. I was struggling to develop a nice way to present this however: I'd developed a sun clock based colour temperature of WS2812B LEDs but didn't want another purely LED clock!

Ball bearings also peaked my interest and started considering how to build a clock around this, without it becoming a marble run. Again, I wanted sound but not actuation sound; only the sound of the ball rolling. How could I move balls without some form of actuation? Magnets.

![sketch of clock idea](/assets/img/linear-clock/linear-clock-sketch.png)
__Basic form sketch. The idea was two rows: one for fives of minutes and one for ones of hours. A ball in each row would move to indicate the current time using magnets. Combined with the sun clock, the shiny balls would reflect the colour temperature and make for a more interesting display.__

At this point, I could design around an array of electromagnets from Aliexpress. I had recently come [across PCB motors](https://hackaday.io/project/39494-pcb-motor) however and wanted to explore this. It would also allow for a compact and easy to assemble design. Of course, I wasn't sure at this stage how well they would work with a gap between the PCB and attracting ball..

![image of clock concept development](/assets/img/linear-clock/linear-clock-concept-development.jpg)
**An ongoing idea board - it features some later developments. Shows some gauging for the clock sizing and consideration of shared channel 3-phase motor control rather than the independent h-bridge design that I ended up with.**

## Prototype One

So I started out designing a _Coil Board_ and enclosure that would feature tracks above the PCB coils for each row. It would be controlled by a _Controller_ via an umbilical connection. I opted to separate the boards for a number of reasons:

* The _Controller_ features designs I've tried and tested so I was confident I would not need to revise it. It had the most assembly so I could just build it once and move it to _Coil Board_ revisions.
* I was less concerned regarding EMF issues; 24 inductors next to the microcontroller didn't seem nice!
* It allows for debugging the _Coil Board_ without the controller. Human in the loop and a power supply if required.
* There simply wasn't much space on the _Coil Board_. The design was already long with twelve coils and there wasn't much space in the centre once the LEDs were added and ensuring a good ground plane.

### Coil Board R0

In terms of electronics, the _Coil Board_ was quite simple: a I2C PWM driver (PCA9685PW) per row to control each coil independently via a low-side switch (single direction) and a WS2812B LED strip in centre for sun clock and visual feedback. The challenge was in the coil design and layout.

I found [Spiki](https://github.com/in3otd/spiki) a Python tool for creating KiCad spirals, which I used to create a 26 mm diameter coil with a 0.2 mm trace width. It required some fudging however to morph the output into what I could use for creating rows of coils. 

Since it generated a PCB, I made this into a footprint with some _vim_ since the KiCad editor does not allow multi-layer footprints. KiCad also does not allow vias in footprints so I ended up with a mix of footprint and layout, which I then used as a pattern using another script to create two rows of twelve coils.

<div class="box">
    <img src="/assets/img/linear-clock/pcb-coil.gif"/>
</div>
__The four layer PCB coil created with some scripts and vim! I had to layout the vias and tracks manually since these are not allowed in a KiCad footprint and then repeat this as a master pattern. Not before triple checking the current path is always the correct direction so as not to cancel it's own EMF! The routing is quite tight when one factors in that JLPCB does not allow blind vias.__

![R0 full board](/assets/img/linear-clock/see-through-board.png)
__The full copper layout looks pretty cool!__

### Controller R0

![linear clock controller board](/assets/img/linear-clock/big-ball-controller.jpg)

Nothing too special:

* STUSB4500 USB-PD controller for power supply: I've used this for a number of projects and it's great. It keeps the power supply upstream but allows the controller to decide the input power - this was important as I wanted to tune the coil voltage for the maximum current the copper could take once I could measure the actual coil resistance.
* SAMD21 microcontroller: My go to for Arduino compatibility. I added support for this chip to [Arduino Makefile](https://github.com/sudar/Arduino-Makefile) so it strikes the right balance for personal projects between being able to go low-level whilst relying on the Arduino eco-system.
* Current sense for each row: For protection but I also had the idea that I may be able to detect the ball position based on the change in current due to the induced current in the ball.
* DS3231 RTC: I could have used the RTC on the SAMD21 but it doesn't have an easy to use RTC battery solution like the STM32 series. The DS3231 I've used in all my clocks so it was low risk.
* Connected to the _Coil Board_ via a Molex Pico-Lock system: I love these because they are small but carry high current; the 1 mm pitch/2 circuit is rated for 2.5 A! Each row has it's own supply cable and I estimated with three coils the peak current would be 1.5 A per row.

### Case R0

![r0 render](/assets/img/linear-clock/r0-render.png)
__A render of the first design. With the PCBs fabricated in China, I perhaps got a bit ahead of myself waiting for the delivery - this would become the theme of the project!__

I wanted a clean design so it's a simple rounded rectangle - based on the PCB outline - with some indents at the front edge to indicate the positions. The tracks are profile cuts of the ball but offset slightly so the ball only contacts at the edges, in order to reduce friction and help the ball roll between pads.

![r0 print](/assets/img/linear-clock/split-joined.jpg)
__When it came to printing (which I had to do in two halves due to print tray size) I opted to play with the track design. One is a smooth track and the other is wavey. The wavey idea was to create mechanical instability so that the ball would roll to the edge of the coil when the coil was switched off, allowing the next coil to _pick it up_. The centre thin section is for the LEDs - too thin and square in this case.__

### Testing

<div class="box">
    <img src="/assets/img/linear-clock/first-run.gif"/>
</div>
__Testing started well, the coils worked! Control via the PWM controllers from the _Controller_ also worked.__

I got off to a good start: the PCB coils all worked and were controllable via the PWM controllers. PWM driving the coils wasn't great as in combination with a magnet, they turned into a very unpleasant speaker! Even PWM frequencies above audible created noise. 100% duty solved this, which was ok as I found I had no need to module the driving.

What didn't work was a ferrous steel ball, which I had based the design around; 20 mm carbon steel balls. The PCB magnets were too weak (generating ~1.5 mT at the PCB) to even hold a ferrous steel, let alone attract it through the casing. Not deterred, I used a neodymium magnet and this worked great. I can replace the carbon steel balls with neodymium of the same size, simple I thought...

The first hurdle with using a permanent magnet rather than ferrous steel was that it had poles and this meant single direction current control of the coil was not going to work. With the steel, I had hoped I could just shift the attracting coil down the row and the ball would roll with it. The magnet meant that it would have its poles aligned with the current coil and that the direction of the next coil needed to be the opposite. I turned to some (basic) FEM using [FEMM](https://www.femm.info/wiki/MagneticsTutorial).

![FEM model two pcb coil](/assets/img/linear-clock/linear-clock-two-balls-air-model.png)
__FEM model of the PCB coil with balls illustrated but configured as air. One can see that the field lines from the active coil form such that the poles would be inverse on the adjacent pad. Turning on the next coil with the same polarity simply _locks_ the ball on the other pad; the polarity must switch to attract the ball, something R0 did not allow.__

![FEM model single ball](/assets/img/linear-clock/linear-clock-one-ball-ans.png)
__More pretty colours! FEM model of the PCB coil with single neodymium ball. I'm not going to pretend I had to go much beyond the tutorial but I was pleased to find the model matched my measurements for Telsas generated by the PCB coil: ~1.5 mT on the PCB and ~1.0 mT through the case (0.6 mm).__

I hoped the wavey track might counter this flaw, by causing the ball to rest between coils it would allow the next coil to _pick up_ the ball. In practice it was not successful however. I tried a number of profiles but faced a few issues. 

One was the increased material/air gap degrading the holding field strength and also struggling to get the ball stable when held. Another was that the track biasing had to be symmetrical (in order to work both directions) but this meant the ball would not always roll to the correct coil. It's possible with more effort one could find a track profile but I opted for a different path.

![wavey track profile cut](/assets/img/linear-clock/track-profile-cut.png)
__I could not find a track profile that solved R0's design flaws. This track had small peaks but also narrowing to make the ball less stable at the coils so that it would carry momentum between coils. The problem was biasing the roll in the correct direction, whilst maintaining bidirectional control.__

Pondering over other mechanical advantages: inclining the track depending on direction, moving the magnet...all felt like over-complexity and dilution of the idea - I wanted the ball to roll with no apparent assistance.

![iron core electromagnets](/assets/img/linear-clock/electromagnet-build.JPG)
__Another attempt at salvaging the design was using iron core electromagnets. I found the perfect size for the design. Whilst this did hold a carbon steel ball, the air gap was still too large to attract the ball from another coil. At this point I was learning the hard way about reluctance and the magnetic field drop off in air!__

## Prototype Two

Prototype One showed the concept had potential but also flaws so I set out on a second design. The primary updates were to the _Coil Board_, the _Controller_ could remain at R0 - the split paying dividends.

* The _Coil Board_ needed polarity control of the coils.
* Current sense didn't really work for position detection; current induced was negligible compared to coil current. I needed a better positioning method.
* I had realised how important reluctance is and that the coil should be as close to ball as possible.
* I had measured the coil resistance to be ~20 Ω. Based on the fabricated copper thickness peak 450 mA @ 9 V was about the limit before burn out. I say peak because the coil quickly warms up and thus its resistance increases, reducing the current.

### Coil Board R1

The obvious way to get direction control of the coils was to ditch the PWM controller and MOSETS and to use a motor controller IC with internal H-bridges. The design decision here was what controller to use.

3-phase with three channels? I could wire the coils like a stepper motor rolled out flat and get away with just two controllers. The current demand would be high however as four coils would be on when just one is _working_, or eight in order to move (~7.4 A!). It might also corner me in the software control flexibility.

I decided against this 3-phase, mostly because the current demand would eliminate USB-C and the clock would require a massive PSU. There was the option of not sharing channels, but going down this track I opted to use a simple dual H-bridge IC: the [DRV8833](https://www.ti.com/lit/ds/symlink/drv8833.pdf). I'd used it in a couple of other projects so knew how it worked, plus I liked that it features over-current limiting, clipping current control and fault indication. I would add hall effect sensors at each coil as a magnet position sensor - since I was now using magnetic balls not steel, this was an option.

<div class="box">
    <img src="/assets/img/linear-clock/drv8833-test.gif"/>
</div>
__Testing the DRV8833 control of coils with first board before redesign. I wanted to ensure that the DRV8833 didn't fault, since the coil could be considered a short-circuit.__

The next step was how to independently control each DRV8833. I would have six DRV8833 per row (one per two coils), each with five inputs and one output. A shift register came to my mind first, but would not provide read-back of fault or the hall sensors so I would require another chip just for this. Since the speed or timing of the coil switching was not important, I went for the MCP23017 GPIO expander: three per row, each controlling and reading the state of four coils via the DRV8833 and hall sensors.

Whilst the _Coil Board_ was having quite the overhaul, the nice thing about using the GPIO expander was that it could be controlled over I2C and so the PicoLock cable to the _Controller_ reminded the same. The firmware became a bit more complex, due to addressing the six MCP23017 in order to shift along the coil row but I created an abstraction layer that made this transparent as my first task.

### Development and Testing

![r1 coil board assembly](/assets/img/linear-clock/small-ball-open.jpg)
__The assembled R1 _Coil Board_ with DRV8833 H-bridge control via MCP23017 GPIO expanders and hall sensors below each coil is quite pleasing, even if I do say so myself - and only one bodge wire! It's four layer so there is some hidden complexity below the solder mask.__

The updated boards arrived, I assembled and to my joy the system worked! I had polarity control and sensing of all the coils via the _Controller_. With the wind in my sails, I set out developing the firmware. My approach to the firmware was to create a coil control abstraction, which a _magnets_ state machine interfaces with. 

The _magnets_ state machine on a basic level, takes a seek position and moves the magnet to this location. It also constantly tracks the state of the magnet, ensuring that it is always where it should be, if it is missing or if the system is faulting. 

Movement is achieved by enabling the next coil in the direction of the seek position, with the opposite polarity of the current coil. The current coil is disabled and the ball movement is detected by the hall sensors. The movement event causes the state change, this allows the system to detect when the magnet is _stuck_ and act accordingly. Once moved, the _brake_ state enables coils either side of the position to help stop the magnet.

<div class="box">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/jUbjE3N4uFo" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
__Demo of _magnets_ state machine with LED debugging enabled. Green: hall sensor active; Blue: coil enabled with north polarity; Red: coil enabled with south polarity.__

Another state machine _linear-time_, controls the clock state and sets the _magnets_ FSM based on the time. It also controls a configuration state, which allows one to set the time and other run-time parameters.

Separate to all this is the solar clock I designed that sets the hour position LED colour temperature based on the solar cycle:

`night -> dawn -> sunrise -> day -> sunset > dusk -> night`

<div class="box">
    <img src="/assets/img/linear-clock/sunrise.gif"/>
</div>
__Solar cycle showing the sunrise using a blended sky colour palette, emulating each phase of the day. See the [demo reel](https://youtu.be/CRLD3K5hQnA?t=68) for a clearer view.__

It does this completely offline, based on a set longitude and latitude using the [sunset lib](https://github.com/buelowp/sunset) - pretty neat! I created the FastLED colour temperature palettes using sky palettes kindly provided [here](http://soliton.vm.bytemark.co.uk/pub/cpt-city/rafi/index.html) that are mapped to each day phase, mixed as they intersect.

#### Balls...

You may have noticed that the above video shows only one magnet...I'm embarrassed to say, I became so focused developing this that I developed the whole thing with only one magnet. I started with one row during bring up and just didn't think to try the other row since it was just a mirror of the first. I also have the excuse that my original design was without permanent magnets so interaction between rows was not an issue.

If you haven't worked it out, the magnetic field of the neodymium magnets is magnitudes (100x) larger than the PCB coil. The air gap between the rows is not enough to prevent 15 mm neodymium magnets interacting with each other 🤦. In hindsight, this is obvious and I may appear an idiot but I guess it's an example of a design in flux (pun intended!) and becoming too focused on the development once one gets a sniff of success!

<div class="box">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/3JAXp0J8rKA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Above was a low point in the project for sure. I took a break, unsure how it could be salvaged. I considered how I could change the magnetic properties of the ball:

* Heating the ball in the oven I had read can permanently reduce magnetism of neodymium - not for me or at not enough to make a difference.
* Hitting the balls I also read can affect a permanent magnet due to change in the crystal alignments. No joy.
* Making a carrier ball with smaller neodymium magnets at the pole positions. It didn't really roll well.
* Permanent magnets not made from neodymium or at least not 100% neodymium to reduce the magnetic field for the same volume. I found one can get [sintered ferrite magnets](https://uk.misumi-ec.com/vona2/detail/221006350391/#) that can be tuned to the required field strength. These are nice because they have a mirrored finish unlike a 100% ferrite magnet and are not quite as brittle. They are expensive however!

The carrier ball and sintered magnets did offer a solution. The problem, was the trade off when selecting ball size. A large ball has more inertia and so is harder to control and move - it does offer a larger field strength however, so is more attracted to the coil. I wanted a large ball (15-20 mm) as this was the intended design. Small balls made the clock harder to read from a distance and make a more _pingy_ sound.

![all the balls I tested with](/assets/img/linear-clock/balls.jpg)
__I now have a lot of magnetic balls. Exploring the different trade offs between ball diameter, inertia and magnetic field strength. I've included the 3d printed carrier balls in this photo too.__

The ball size also has an impact on the control system/PCB geometry, as the circumference/2 should be a close factor of the coil pitch in order to roll into the next coil with the correct polarity.

After a lot of testing, the only ball I could get to work reliably on the current design was a 5 mm neodymium. It didn't look bad but the small balls just felt like too much of a compromise. True to current tech trends, I decided I'd keep it at that but call it 'Linear Clock Mini' or something and work on a re-design.

<div class="box">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/CRLD3K5hQnA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
__Demo reel of the _Mini_ design. Whilst the small balls dilute the design somewhat, I still think it has a place in a small room or on a desk.__

![linear clock mini](/assets/img/linear-clock/linear-clock-mini-1.jpg)

## Prototype Three

Not fully satisfied with the Linear Clock Mini. I explored some options for a clock with the original large balls I had designed for.

### Sledge

One idea that seemed feasible and would maintain the same exterior was to sandwich a magnet between the case and PCB. The magnet would move along an inner track - driven by the PCB coils - and pull a carbon steel ball above. It would be a multiplier for the PCB coil of sorts.

<div class="box">
    <img src="/assets/img/linear-clock/sledge.gif"/>
</div>
__Sandwiching a flat magnet between the ball track and PCB was something I tested. Here a small magnet is shown to move with a steel ball magnetically attached - the case would sit between the two.__

In practice, whilst it did sort of work, the ball would scrape along the track rather than roll. In addition, friction of the magnet in the sandwich and due to the clamping force to the ball meant it wasn't all that smooth. I also suspected I would encounter issues with magnet size and proximity to the parallel sledge again, due to the size magnet I would require.

### Split

Creating a larger air gap between the rows was the other feasible idea I had and decided to go with. It was guaranteed to work, the challenge was finding the minimum air gap and maintaining a nice design.

I turned back to my FEM model and back it up with real-world testing to find the minimum air gap such that the PCB coils would overcome the interaction between the two magnets. By stepping the design and moving the gap into the diagonal, the effect on overall width was reduced slightly. The step also creates a better area for the position indicators, LED and easier viewing of both balls when reading at eye level so wasn't a complete compromise.

![split verification](/assets/img/linear-clock/p-linear-clock-split-1.jpg)
__Verifying the FEM modelled air gap required for a 15 mm sintered ferrite ball, before committing to the design.__

### Coil Board R2

The R2 schematic matched R1 since it worked - the change was purely mechanical. I created a split and cut lines in order to detach the rows from each other. One might wonder why I didn't just create symmetrical PCBs for each row. I opted for a single board with cut so that I could use the board in a wide flat design if I desired; I could keep a single connector to the _Controller_ without changing that design; to minimise changes in the layout/tracking at this stage.

![hardware debugging](/assets/img/linear-clock/hardware-debugging.jpg)
__There were very few hardware issues in the design process. There was one gotcha in the split that did require some hardware debugging: the cut disconnected the top layer ground plane, resulting in the DRV8833s working at low power (5 V/3 A) but not the intended 9 V/3 A. A good lesson that a bad ground return can allow something to work but not work _well_.__

### Stepped Case

<div class="box">
    <img src="/assets/img/linear-clock/linear-clock-max-model-overview.gif"/>
</div>
__Overview of the _Max_ model. I think I made the most of the forced geometry and it did not become too cumbersome. The track features _tees_ to aid keeping the ball in position.__

Prototype Three demanded a completely new enclosure design. Nothing too complex though: again based on the PCB outline to minimise size but with a slope based on the calculated minimum air gap + fudge factor between the rows. I made full use of the slope to make the position indicators clearer with an LED light diffuser between them.

![anodised base for max](/assets/img/linear-clock/max-base-machining.jpg)
__The ferrite balls have a dark gray appearance so for this design, I requested a gray anodising to the aluminium machined base to match.__

### It Works!

I placed the order for the printed top and machined base then crossed my fingers. When they arrived, I was dreading the test but thankfully, it worked! The big balls were controllable through the full clock cycle. The firmware for both designs is the same, apart from some different timing values for the motion due to the different ball inertia.

There is minor interaction between the rows on both the _Mini_ and the _Max_ design - more so on the _Mini_ in fact. With the motion sensing however, the controller can overcome this. It flips the parallel row to ensure the poles are opposing one another and will re-attempt a move if _stuck_ - this can be seen in the demo videos. Running at accelerated speed for the demos, this is more apparent as the coils and balls warm up and the control is less effective. I think the repeated movement is almost part of the charm.

I'm pleased with both designs. The rolling noise is different but pleasing on both; a fast swipe on the _Mini_ and a grand roll on the _Max_ due to the increased inertia. Each fits a different space.

<div class="box">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/vNKcjXRv2U8" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
__Demo reel of the split and stepped _Max_ design. The increased air gap allows the clock to work with 15 mm balls, which was my original design intent.__

![linear clock max open](/assets/img/linear-clock/max-open.JPG)
__The _Max_ design involves some soldered connections unlike the _Mini_. I would probably change the interconnects if I were to revise this, so that both boards connect directly to the _Controller_.__

## Final Design Gallery

### Mini

![linear clock mini with flip dot](/assets/img/linear-clock/linear-clock-mini-flipdot.jpg)
![linear clock mini front left](/assets/img/linear-clock/linear-clock-mini-front-4.jpg)
![linear clock mini front tracks](/assets/img/linear-clock/linear-clock-mini-front-5.jpg)
![linear clock mini tracks](/assets/img/linear-clock/linear-clock-mini-tracks-1.jpg)
![linear clock mini rear](/assets/img/linear-clock/linear-clock-mini-rear-1.jpg)

### Max

![linear clock max front right](/assets/img/linear-clock/linear-clock-max-front-1.jpg)
![linear clock max rear](/assets/img/linear-clock/linear-clock-max-rear-1.jpg)
![linear clock max left side](/assets/img/linear-clock/linear-clock-max-side-1.jpg)
![linear clock max balls](/assets/img/linear-clock/linear-clock-max-reflect-2.jpg)
![linear clock max kitchen](/assets/img/linear-clock/linear-clock-max-kitchen-3.jpg)
