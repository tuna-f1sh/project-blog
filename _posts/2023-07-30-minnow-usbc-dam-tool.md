---
title: Minnow USB-C DAM Tool
date: 2023/07/30
tags: development, product, embedded
categories: Electronics
image: assets/img/minnow-dam-board.jpg
layout: post
---

Minnow is a tool for using DAM (Debug Accessory Mode), providing an interface to SWD or JTAG and/or UART from the device. It expands upon [this concept](https://github.com/BitterAndReal/SWD-over-USB-C) to include a USB-UART and some utility for use within test rigs. It could be considered SWD over DAM with a sprinkling of [USB cereal](https://github.com/oxda/usb-cereal) - unlike usb-cereal it does not use the Chromebook UART mapping in favour of maintaining USB-C rotational symmetry.

* Enables and interfaces USB DAM configured in image below; Full SWD or JTAG over USB-C.
* Provides board designer the option of using RX+ for NRST/RXD and RX- for SWO/TXD - either single-wire trace communication (RTT) or UART.
* Four configurable GPIO on FT230 for test rig control of UUT: power enable; RX pin control; reset.
* TagConnect TC2030 and ARM 10-pin header to debugger.
* USB pass-through or FT230 USB UART to device.
* VTARGET reference from device or external.
* Maintains USB-C rotational symmetry.
* Alternate Mode 3.1+ can still be used in the main application with normal hosts.

![Minnow DAM USB-C DAM Tool PCB](/assets/img/minnow-pcb.jpg)

That's the intro for the [README.md](https://github.com/tuna-f1sh/minnow). I'll expand a bit more on why I made the device here. The debugger over SWD/JTAG is a pre-requisite when developing any custom embedded hardware, and is often required for provisioning said hardware - in volumes below pre-programmed microcontrollers. When designing a PCB, there is often a trade off between ease of debugger attachment and land. I'm a fan of the [TagConnect](https://www.tag-connect.com/) system but even that is quite big and really should be reserved for out of form, initial dev boards. Another issue is that once the device is _embedded_ the debugger header often cannot be accessed. In practice this is generally considered a bonus (security) but it can save the day after a dodgy DFU for example.

Most devices have a USB-C interface, which supports USB 3.1+ [Alternate Mode](https://en.wikipedia.org/wiki/USB-C#Alternate_Mode_2). The Alternate Mode lines provide 5 lines (2 differential pairs and 1 low-speed signal), which provide a designer up-to 10 additional IO (not used as differential and rotational asymmetry). These pins are used by USB-C [interface protocols](https://en.wikipedia.org/wiki/USB-C#Alternate_Mode_partner_specifications) such as DisplayPort, Thunderbolt and HDMI.

The USB specification even includes one for debugging; [DAM](https://en.wikipedia.org/wiki/USB-C#Debug_Accessory_Mode) - what we are talking about here. It's up-to the designer how to implement it, the specification only covers how to enter DAM. Since the port is normally externally accessible and already taking up board area it's a nice solution to solve the issues mentioned in the paragraph above.

Whilst it may not be ideal for the highest security devices - exposing an external interface to debuggers - the SWD/JTAG/readback could still be disabled with fuses in production firmwares (as it should be).

![Minnow DAM mode pinout](/assets/img/minnow_swd_dam_pinout.png)
__[Original reference](https://github.com/BitterAndReal/SWD-over-USB-C/blob/main/images/SWD%20over%20USB-C%20Pinout-01.png) modified to include option of UART.__

[Minnow](https://github.com/tuna-f1sh/minnow) implements DAM by defining the [SWD and JTAG](https://developer.arm.com/documentation/101636/0100/Debug-and-Trace/JTAG-SWD-Interface) interface over the Alternate Mode differential pairs and VTARGET over SBUS. Since there are four SWD lines and one for VTARGET, USB-C rotational symmetry is maintained 🙏. The Minnow hardware does the job of pulling the CC lines high with the pull-ups defined in the USB specification, so when connected to a supported target SWD is exposed on the 10-pin ARM and TagConnect headers. 

The neat thing is that when the target is connected to other hosts, the DAM lines are out of circuit and the Alternate Modes can be used for a custom protocol. One could have a DisplayPort display for a example, with this Minnow DAM implementation to provide DFU.

Minnow enables DAM whilst forwarding the standard USB 2.0 differential pairs to the host; SWD can be used at the same time as USB communication in DAM.

I also added the option of using the _extra_ SWD lines (NRST and TRACE, not required for programming/debug) for UART. This means the target device can forward a UART over USB-C for provisioning rather than RTT. For this, Minnow includes a FTDI FT230X USB-UART adaptor so no additional tools are required.

The on-board FT230X's GPIO can also be used to control power to the target device, reset the device or control something else.

You can find a quick video demo below. The design is open-source but if you'd rather purchase assembled boards or just support my work, PCBAs are on [my shop](https://shop.jbrengineering.co.uk/product/minnow-usb-c-debug-accessory-mode-tool-dam/) and [Tindie](https://www.tindie.com/products/jbrengineering/minnow-usb-c-debug-accessory-mode-tool-dam/).

<div class="box">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/QQiKsJ13bL0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

[![Minnow R2 schematic](/assets/img/minnow-r2-0-g19cc.png)](/assets/minnow-r2-0-g19cc.pdf)
__Minnow schematic design. Full source available on [GitHub](https://github.com/tuna-f1sh/minnow)__

[![Example DAM mode Minnow target](/assets/img/minnow-usb-dam-schematic.png)](/assets/minnow-usb-dam-schematic.pdf)

__Example DAM switching on target. Some additional circuitry is required on the target device to implement DAM as per the USB specification; it could be reduced if not concerned about meeting the specification. The additional parts are not any bigger than most other debugging headers however, with the benefit of not requiring a bespoke plug - just a USB-C.__
