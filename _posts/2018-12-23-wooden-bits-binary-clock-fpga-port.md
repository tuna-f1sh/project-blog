---
id: 1246
title: Wooden Bits Binary Clock FPGA Port
date: 2018-12-23T12:45:27+00:00
author: John
layout: post
guid: /?p=1246
permalink: /2018/12/wooden-bits-binary-clock-fpga-port/
image: assets/img/uploads/2018/12/hero-825x510.jpg
categories:
  - Electronics
  - Programming
tags:
  - fpga
---
 

In attempt to get started with FPGAs and Verilog, I decided to port [Wooden Bits](https://github.com/tuna-f1sh/wooden-bits) to a _Lattice IceStick_ &#8211; selected because of the Open-Source [IceStorm toolchain](http://www.clifford.at/icestorm/). Counters and flip-flops are the first thing one learns when starting with FPGA design, so the project lends itself naturally. I learnt things FPGAs are good at and things they are not so good at &#8211; best done on a microcontroller. As the project was educational, there were many learnings along the way and invariably still to be learnt; it is not intended as a best use of FPGAs or implementation.

The most enlightening part of the learning and what finally kicked me to do the project, was the [PicoSOC](https://github.com/cliffordwolf/picorv32/tree/master/picosoc) project and in particular, Matt Venn&#8217;s addition of a [WS2812 peripheral to the PicoSOC](https://www.youtube.com/watch?v=us2F8wAncw8&t=841s). The idea of rolling one&#8217;s own peripheral for driving external hardware into a SoC or only adding the required ones is new ground for me. The concept also really helps to cement what is actually going on when accessing registers during development of embedded software.

## Binary Clock Counter Design {#binary-clock-counter-design}

A binary clock is essentially a frequency divider, which can be formed using D-Type Flip-Flops, each data line clocking the next. In order to reset the 4 bit counter at 9 (or the other digits for time), a modulo 9 counter is created by using an AND gate driving reset with bits 1 & 3 (as it clocks 10). This is assuming the D-Type is asynchronous (will reset on reset edge). If it were synchronous, the AND gate must be connected to bits 0 & 3 (9), such that the reset will be clocked as it would be counting 10. The difference becomes quite important in Verilog, particularly when driving the next digit modules with the reset signal.  

<figure class="wp-block-image">
<img loading="lazy" src="/assets/img/uploads/2018/12/Screenshot-2018-12-17-at-17.30.22-880x1024.png" alt="" class="wp-image-1249" srcset="/assets/img/uploads/2018/12/Screenshot-2018-12-17-at-17.30.22-880x1024.png 880w, /assets/img/uploads/2018/12/Screenshot-2018-12-17-at-17.30.22-258x300.png 258w, /assets/img/uploads/2018/12/Screenshot-2018-12-17-at-17.30.22-768x894.png 768w, /assets/img/uploads/2018/12/Screenshot-2018-12-17-at-17.30.22.png 1366w"/> <figcaption>24 hour ninary coded decimal (BDC) clock design. LSB/digit on left. A binary clock is first a frequency divider, which can be created by changing Flip-Flops together. A modulo counter is created by using a logic gate driving reset of synchronous D-Type Flip-Flops. The time is 00:03:38 in this screenshot.</figcaption></figure> 

It&#8217;s good to start with a logic diagram of what one is trying to achieve so I drew one up in [Falstad](http://www.falstad.com/circuit/circuitjs.html) ([import this file](https://raw.githubusercontent.com/tuna-f1sh/wooden-bits-fpga/master/falstad.txt)). To implement this, I designed a counter module for each digit that is asynchronous (reset on reset edge), so that the reset line can directly feed the next digit module. Initially, my approach was synchronous (read reset on clk edge) but this meant having to have a &#8216;carry&#8217; output on reset to clock the other digits at the correct time (otherwise they would clock one digit a head of the desired value).

<figure class="wp-block-image">
    <img loading="lazy" src="/assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.34.42-1-1024x298.png" alt="" class="wp-image-1271" srcset="/assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.34.42-1-1024x298.png 1024w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.34.42-1-300x87.png 300w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.34.42-1-768x224.png 768w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.34.42-1.png 1139w"/>
    <figcaption>Test bench timing diagram for synchronous reset digit module. The reset wire turns the counter into a modulo BCD module. Since the design is synchronous, the reset signal cannot be seen &#8211; unlike the asynchronous plot below, where it lasts for one clock cycle. The wire will instantaneously (in theory but not in physics&#8230;) reset one digit (causing it to clear) whilst driving the next, since it is hardware logic. This is one of the key differences between microcontroller variables and FGPA design.</figcaption>
</figure>

<figure class="wp-block-image"><img loading="lazy" src="/assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.31.57.png" alt="" class="wp-image-1263" srcset="/assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.31.57.png 1146w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.31.57-300x90.png 300w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.31.57-768x231.png 768w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.31.57-1024x307.png 1024w" />
<figcaption>The asynchronous Flip-Flop design results in the proceeding digit being one clock out of phase. I did originally remedy this by including a _modulo_ output bit, that asserted as the reset signal was clocked. It is the equivalent of adding an additional Flip-Flop to latch the reset in the simulation as a clock source for the next module.</figcaption>
</figure> 

Interestingly, one could use a single counter register rather than individual modules. I [developed an alternative](https://github.com/tuna-f1sh/wooden-bits-fpga/blob/master/binary_clock.v) based on this idea, using bit logic to clear/increment bit addresses. The advantage is that it only uses 13 bits rather than 16 bits. Other than this, the modular system synthesis should resolve down to the same thing (something that looks like the Falstad simulation), since the reset inputs driving each module are just _wire_ bit logic as in the massive `if, else`. I think having modules for each digit helps with readability and helped with learning the `module` aspect of Verilog.

```c
module counter(
  input clk,
  input rst,
  output [BITS-1:0] digit);

  parameter BITS = 4;

  reg [BITS-1:0] digit = 0;

  always @ (posedge clk or posedge rst) begin
    if (rst)
      digit &lt;= 0;
    else
      digit &lt;= digit + 1;
  end

endmodule

/* seconds (4 and 3 bits but leave all) */
wire [3:0] ds0;
wire rst_ds0 = ((ds0[1] & ds0[3]) || reset); // 10
counter s0(clock_clk, rst_ds0, ds0);
wire [3:0] ds1;
wire rst_ds1 = ((ds1[1] & ds1[2]) || reset); // 6(0) minutes
counter s1(rst_ds0, rst_ds1, ds1);

/* minutes (4 and 3 bits but leave all) */
wire [3:0] dm0;
wire rst_dm0 = ((dm0[1] & dm0[3]) || reset); // 10
counter m0(rst_ds1, rst_dm0, dm0);
wire [3:0] dm1;
wire rst_dm1 = ((dm1[1] & dm1[2]) || reset); // 6(0) minutes
counter m1(rst_dm0, rst_dm1,  dm1);

/* hours (4 and 2 bits but leave all) */
wire [3:0] dh0;
wire rst_dh0 = ((dh0[1] & dh0[3]) || rst_dh1 || reset); // 10 or tens of hour reset
counter h0(rst_dm1, rst_dh0, dh0);
wire [3:0] dh1;
wire rst_dh1 = ((dh1[1] & dh0[2]) || reset); // 2(0) & 4 hours
counter h1(rst_dh0, rst_dh1, dh1);
```

<p class="has-text-color has-background has-small-font-size has-very-light-gray-color has-very-dark-gray-background-color">
  <em>The Falstad simulation realised in Verilog as a per digit synchronous reset module.</em>
</p>

```c
module binary_clock(clk, reset, ce, count);
   input clk, reset;
   input ce;  // count enable 
   output [13:0] count; // two digit bcd counter

   reg [13:0] count;
   wire [3:0] d0 = count[3:0];
   wire [2:0] d1 = count[6:4];
   wire [3:0] d2 = count[10:7];
   wire [1:0] d3 = count[12:11];

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         count &lt;= 0;
      end else begin
        if (ce) begin
           if (count[3] & count[0]) begin // 9
              count[3:0] &lt;= 0;
              if (count[6] & count[4]) begin // 5
                count[6:4] &lt;= 0;
                if (count[10] & count[7]) begin // 9
                  count[10:7] &lt;= 0;
                  if (count[12] & count[8] * count[7]) begin // 2 & last 3
                    count[12:11] = 0;
                  end else begin
                    count[12:11] &lt;= count[12:11] + 1;
                  end
                end else begin
                  count[10:7] &lt;= count[10:7] + 1;
                end
              end else begin
                count[6:4] &lt;= count[6:4] + 1;
              end
           end else begin
              count[3:0] &lt;= count[3:0] + 1;
           end
         end
      end
   end
endmodule
```

<p class="has-text-color has-background has-small-font-size has-very-light-gray-color has-very-dark-gray-background-color">
  <em>Alternatively, one module to do all digits but with 13 bits rather than 16 bits.</em>
</p>

<figure class="wp-block-image">
<img loading="lazy" src="/assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.36.24.png" alt="" class="wp-image-1265" srcset="/assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.36.24.png 1144w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.36.24-300x184.png 300w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.36.24-768x472.png 768w, /assets/img/uploads/2018/12/Screenshot-2018-12-21-at-08.36.24-1024x629.png 1024w" sizes="(max-width: 1144px) 100vw, 1144px" /> <figcaption>Binary clock timing diagram over almost 24 hours. The LED matrix wire contains the bits arranged to match how the clock display is wired. They are not in digit order but the half frequency of each bit is quite visible.</figcaption></figure> 

For development, the clock input to the first Flip-Flop is taken from a divided down master clock (12 MHz) to form a 1 Hz clock. For actual deployment on the bench, I added an additional clock input pin for driving from an external 1 Hz clock generator such as can be found on RTCs.

<div class="box">
    <blockquote class="imgur-embed-pub" lang="en" data-id="2Pgq28N"  ><a href="//imgur.com/2Pgq28N">Wooden Bits FPGA Port Button</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>
</div>

## WS2812 LED Matrix {#ws2812-led-matrix}

My original design uses sixteen one-wire WS2812 LEDs chained through the laser-cut wood to form an addressable LED matrix. WS2812 LEDs simplify wiring and hardware complexity over standard LEDs, at the cost of CPU cycles: The one-wire interface sends 24 bit colour data for each LED by modulating the period of high/low in a serial data stream. Each LED takes the first 24 bits,then sends forwards the rest of the data to the next in line. Since microcontrollers don&#8217;t have a peripheral specifically designed to do this, it is normally done using Timers and match/overflow interrupt routines.

An FPGA can make light work of this however and my real interest peaked with the idea that one can make a WS2812 _peripheral_ with no processor overhead.

```c
// map bits to matrix in snakes and ladder formation...
assign led_matrix = {
    dh1[3], dh0[3], dm1[3], dm0[3],
    dm0[2], dm1[2], dh0[2], dh1[2],
    dh1[1], dh0[1], dm1[1], dm0[1],
    dm0[0], dm1[0], dh0[0], dh1[0]};

for (i=0; i&lt;NUM_LEDS; i=i+1) begin
    led_rgb_data[24 * i +: 24] &lt;= (led_matrix[i] | rainbow) ? display_rgb : 24'h00_00_00;
end
```

The binary clock face only needs to set LEDs on or off. I created [a fork](https://github.com/tuna-f1sh/ws2812-core) of Matt Venn&#8217;s WS2812 module that can access the LED colour register directly so that the code then does a mask operation using the digit registers on each update of the digits (1 Hz in standard operation). The main real overhead driving the LEDs is the size of the colour register that is 24 * N bits, where N is the number of LEDs. The FPGA must latch this data, as it can change at different clock edges. I experimented with various different modifications to the code, each with it&#8217;s merits but settled on the direct setting of the RGB register for this project.

## Clock Features {#clock-features}

### Set Button {#set-button}

The set button was easy to port: I added an input to the top module connected to an IO pin and a button with hardware pull-up and debounce &#8211; hardware is a key point here, I did both on the uC previously. If the button is pressed, the clock source to the first counter flip-flop changes to one that is running at 1000 Hz (using a counter based divider) and the display colour changes red. Releasing the button returns the clock to the normal state. This allows a user to quickly advance the clock to the correct time.

```c
/* binary clock source is either clk_1 (external 1 Hz) or clk_2 (1 kHz) if button is pressed */
wire clock_clk = CLK_1HZ ^ (clk_2 && ~BTN);
```

Whilst it was an easy port, the user interaction is much less refined compared to the software version. My software design features a delay before advancing at accelerated time so one can button press through minutes when near the correct time, or hold the button to advance quickly. It will also wait in set mode for a few seconds on release before setting the new time. Additionally, the set button can be used to set the main display colour.

<div class="box">
    <blockquote class="imgur-embed-pub" lang="en" data-id="bRNOXdM"  ><a href="//imgur.com/bRNOXdM">Wooden Bits FPGA Port Button</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>
</div>

These advanced interaction would all be possible on the FPGA but the design would become somewhat messy and it would need to be carefully implemented as to avoid FPGA bad practices (there are some big pitfalls I have found!). My take away was that these kind of user interaction features are better done in software &#8211; there is minimal overhead compared to driving the LEDs and it is very quick to implement.

### Rainbow Colour Cycle {#rainbow-colour-cycle}

My original clock also fills the display with a rainbow colour routine at midday and midnight. Implementing this on the _IceStick_ became quite challenging as I quickly overran the 1280 LUTs (basically combinational logic). I think this was due to setting a RGB colour for each LED in the colour register, where as before it was just an option between two colours based on whether a bit was high or low. Without the rainbow effect, the sythesis was a simple logic mask but with the addition of full 24 bit colour at run time, it would require much more complicated logic. In addition, the routine works using a pseudo colour wheel that also adds complexity to the logic synthesis, due to three `<` switches.

```c
task colour_wheel; begin
  if (wheel &lt; 85) begin
    red &lt;= (255 - wheel * 3);
    green &lt;= 0;
    blue &lt;= wheel * 3;
  end else if (wheel &lt; 170)  begin
    red &lt;= 0;
    green &lt;= (wheel - 85) * 3;
    blue &lt;= (255 - (wheel - 85) * 3);
  end else begin
    red &lt;= (wheel - 170) * 3;
    green &lt;= (255 - (wheel - 170)* 3);
    blue &lt;= 0;
  end
end endtask
```

Encountering these sorts of problems are useful when learning a new topic.Whilst the base project itself is quite simple, adding in these sorts of features brings up challenges that require further reading. I _just_ managed to squeeze the rainbow effect, after finding areas of optimisation in logic statements and [transparent latches](https://www.doulos.com/knowhow/verilog_designers_guide/synthesizing_latches/).

# Discussion {#discussion}

The project grew well beyond the scope of simply getting a binary clock working on the _IceStick_ &#8211; I achieved that in less than an hour. What took time was refining how the digit module worked and really understanding how to mirror the simulation; digging into the WS2812 module to add masking and direct colour register set; developing a test bench and methods for capturing specific parts of a design and finally, the user interactions and bonus features.

My take home is that an FPGA is ideal for creating a low-level driver but what one then does with that driver is generally better achieved in software. A binary counter is just as easy and low resource to implement in C and the advantage then is that the button control and advanced features that make the clock unique is much quicker, safer and flexible to incorporate. That code can then directly interface with something like the WS2812 via a FPGA peripheral in this example.

I&#8217;m looking forward to trying other high data rate experiments with FPGAs such as LED matrix and HDMI driving, watch this space&#8230;

[GitHub Project](https://github.com/tuna-f1sh/wooden-bits-fpga)

<div class="box">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/U5OJ7-_I_tY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
