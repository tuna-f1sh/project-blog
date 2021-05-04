---
id: 599
title: Building Atmel Studio ASF Project using External Makefile
date: 2015-02-02T17:23:55+00:00
author: John
layout: post
guid: /?p=599
permalink: /2015/02/building-atmel-studio-asf-project-using-external-makefile/
image: assets/img/uploads/2015/02/Capture-e1423476065874-612x510.png
categories:
  - Programming
tags:
  - atmel
  - guide
---
The Atmel Studio IDE is a useful tool thanks to the comprehensive debugging support and management of project drivers via the Atmel Software Framework (ASF) &#8211; coming from a hardcore Vim advocate. One thing I dislike about IDEs is the fact they hide the make process from the user making it difficult to break a project away from the software. On wishing to develop code on different operating systems (being Visual Studio based, Atmel Studio is limited to Windows), and outside the IDE, I set about creating a Makefile for an Atmel Studio project built around the ASF.

<!--more-->

# Makefile

Atmel Studio provides a command line tool for building projects but unfortunately it still relies on the project file and isn&#8217;t completely makefile based. Digging into the ASF, I found a Makefiles for AVR and SAM systems in &#8216;common/util/make&#8217; and &#8216;sam/util/make&#8217; respectively. It&#8217;s a project independant Makefile for each processor type, requiring an include &#8216;config.mk&#8217; that defines the project specific name, source, includes etc.

Copy this file (either AVR or SAM depending on what you&#8217;re using) to the to root directory of the project you want to build.

# Configure

Template &#8216;config.mk&#8217; files can be found in the various demo projects within the ASF folder. Just do a `find . -name config.mk | grep sam3` in the ASF root to find one for the board used in your project. They are well commented so fairly self explanatory. The main changes required are &#8216;PRJ&#95;PATH&#8217;, &#8216;TARGET&#95;FLASH&#8217; and the source/includes.

    # Path to top level ASF directory relative to this project directory.
    PRJ_PATH = src/ASF
    BUILD_DIR = build
    
    # Target CPU architecture: cortex-m3, cortex-m4
    ARCH = cortex-m3
    
    # Target part: none, sam3n4 or sam4l4aa
    PART = sam3s2a
    
    # Application target name. Given with suffix .a for library and .elf for a
    # standalone application.
    TARGET_FLASH = build.elf
    TARGET_SRAM = build.elf
    

Defining the source and includes required for a large project would be a timely and frustrating process &#8211; it&#8217;s one of the main attractions of the IDE. Thankfully, the build folder contains (&#8216;Debug&#8217; by default) a Makefile that has done this for us (it doesn&#8217;t build on its own though). Just copy &#8216;C&#95;SRCS&#8217; to &#8216;CSRCS&#8217; and &#8216;SUBDIR&#8217; tp &#8216;INC&#95;PATH&#8217; &#8211; **NOTE** the includes in the config.mk are appended with the ASF dir &#8216;PRJ&#95;PATH&#8217; whereas the &#8216;CSRCS&#8217; are not.

Finally, check the &#8216;CPPFLAGS&#8217; defines are the same as those in the IDE. Generally you&#8217;ll need to define the MCU in the format &#8216;**MCU**&#8216;. Check also that the linker scripts are correct for the board (relative to &#8216;PRJ&#95;PATH&#8217; again).

# Build

Once configured, simply `make` at the command line will build the project &#8211; completely non-reliant on the Atmel Project. The Makefile and config.mk can also be used for general Atmel projects without the ASF. The files below are examples for a simple GCC application:

[Atmel Make SAM Template](/assets/img/uploads/2015/02/Atmel-Make.zip)