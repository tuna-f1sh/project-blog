---
id: 546
title: Developing Simulink Device Drivers for ARM Cortex
date: 2015-02-12T17:12:04+00:00
author: John
layout: post
guid: /?p=546
permalink: /2015/02/developing-simulink-device-drivers-arm-cortex/
image: assets/img/uploads/2015/01/blink.png
categories:
  - Programming
tags:
  - c
  - embedded
  - guide
  - MATLAB
  - simulink
---
_Simulink Embedded Coder_ offers an [ARM Cortex-M support toolbox](http://uk.mathworks.com/hardware-support/arm-cortex-m.html?refresh=true), which includes code optimisation for the MCU and QEMU emulation but lacks any S-Block drivers for the device. The lack of drivers limits the _Simulink_ development to merely number crunching. You can create `cevel` blocks that execute external C functions but this requires separate source files with a shared header and pre-defined initialisation, leaving the model without _full_ control of the hardware. In this post, I go over the process of creating hardware driver S-Blocks.

# CMSIS

_ARM_ have a universal driver set named CMSIS that standardises register names, system start-up function, exceptions and defines. Developing the basic device drivers to use this means that we can transition a model from MCU and even manufacturer by simply changing the board include.

# Digital Output S-Block

## GPIO Functions

As explained above, a minimum requirement of a board.h is a definition of register locations. We need to create functions that the _Simulink_ S-Block can call to modify these.

The S-Block needs:

**1** An init function

```c
/*-------------------------------------------------------------------------------
enable the peripheral clock
*------------------------------------------------------------------------------*/
inline static void pmc_enable_periph_clk_matlab(int ul_id)
{

    if (ul_id &lt; 32) {
        if ((PMC-&gt;PMC_PCSR0 & (1u &lt;&lt; ul_id)) != (1u &lt;&lt; ul_id)) {
            PMC-&gt;PMC_PCER0 = 1 &lt;&lt; ul_id;
        }
        } else {
        ul_id -= 32;
        if ((PMC-&gt;PMC_PCSR1 & (1u &lt;&lt; ul_id)) != (1u &lt;&lt; ul_id)) {
            PMC-&gt;PMC_PCER1 = 1 &lt;&lt; ul_id;
        }
    }
}


/*-------------------------------------------------------------------------------
configure pins
*------------------------------------------------------------------------------*/
void pio_config_pin(int pin)  {

  int mask = (1 &lt;&lt; pin);

    pmc_enable_periph_clk_matlab(ID_PIOA);

    /* Set up LED pins. */
    PIO-&gt;PIO_PER = mask; // enable pin mask
    PIO-&gt;PIO_OER = mask; // direction output
    PIO-&gt;PIO_PUDR = mask; // pull-up disable
    PIO-&gt;PIO_OWER = mask; // enable output write
    pio_block( mask, 0x0 ); // turn everything off
}
```

**2** An output function (to run each step)

```c
/*-------------------------------------------------------------------------------
pio set pins
*------------------------------------------------------------------------------*/
void pio_pin(int pin, int level)  { 

  int mask = (1 &lt;&lt; pin);

  PIO-&gt;PIO_SODR = mask & level; // set output 
  PIO-&gt;PIO_CODR = mask & ~level; // clear output

} 
```

**3** A terminate function

```c
void pio_terminate_pin(int pin) { 

  int mask = (1 &lt;&lt; pin);

  pio_block( mask, 0x0 ); // turn everything off

} 
```

Note the types aren&#8217;t explicit due to type definition discrepancy when it comes to building the S-Block. The function calls will be so it shouldn&#8217;t be a problem. I looked at using pin masks rather than using single pins but the S-Block init cannot accept block inputs &#8211; only parameters &#8211; so it was a lost cause. The blocks can be built into a masked sub-system within _Simulink_ for the same effect.

Put these in a gpio\_control.c file with declarations in gpio\_control.h (except the inline pmc_enable.., MATLAB doesn&#8217;t need to see this).

## Make the S-Block

Now to _MATLAB_. Put the driver source (gpio\_control.c,.h) in a working directory, along with the CMSIS source including the MCU header (we&#8217;re using ATMEL, which can be found in Atmel/Atmel Toolchain/ARM GCC/4.8.1429/CMSIS\_Atmel of an Atmel Studio install).

### Configure

1. Create a S-Block template definition: `def = legacy_code('initialize')`
2. Source files:  
`def.SourceFiles = {'gpio_control.c'}`  
`def.HeaderFiles = {'gpio_control.h'}`
3. Functions:  
`def.OutputFcnSpec = 'pio_pin(uint8 p1, uint32 u1)'`  
`def.StartFcnSpec = 'pio_config_pin(uint8 p1)'`  
`def.TerminateFcnSpec =<br />
'pio_terminate_pin(uint8 p1)'`
4. Includes: `def.IncPaths = {'CMSIS_Atmel/Device/ATMEL/sam3s/include/','CMSIS_Atmel/','CMSIS_Atmel/CMSIS/Include/','CMSIS_Atmel/Device/ATMEL/'}`
5. A name: `def.SFunctionName = 'Cortex_Pin_Digital_Output'`

You may notice the include path is specific to the SAM3S directory. _MATLAB MEX_ compiler needs to be able to build the source and for this reason we must define a MCU at this point. It can be changed once the block is complete but the source won&#8217;t compile now without a board header. Add to the top of the gpio_control.c source:

```c
#define __SAM3S2A__

#include "sam3.h" 
#include "gpio_control.h"

#define PIO        PIOA 
```

(or another board.h, ATMEL uses an MCU define system to load the specific board). The include directories will be auto added to the code builder when it comes to code generation, so it&#8217;s worth putting the folder in the _MATLAB_ path.

### Build

1. Generate mex info: `legacy_code('sfcn_cmex_generate', def);`
2. Compile: `legacy_code('compile', def);`
3. Make TLC: `legacy_code('sfcn_tlc_generate',specs)`
4. You&#8217;ll get some generated files with the name of the block (Cortex\_Pin\_Digital_Output). The source file (.c) is the one that is called during simulations and .tlc is used for generation. Unfortunately, the simulation code will also be trying to call the driver functions, which it can&#8217;t do and will cause **catasphric crashing** if it does (I learnt the hard way!). To solve this, open the file `edit Cortex_Pin_Digital_Output.c`, find `mdlStart`, `mdlOutputs` and `mdlTerminate`. Wrap each call to the driver functions in `#ifndef MATLAB_MEX_FILE` `#endif` and save. EG:

```c
static void mdlStart(SimStruct *S)
{
  /*
   * Get access to Parameter/Input/Output/DWork/size information
   */
  uint8_T *p1 = (uint8_T *) ssGetRunTimeParamInfo(S, 0)-&gt;data;

  /*
   * Call the legacy code function
   */
  #ifndef MATLAB_MEX_FILE
    pio_config( *p1);
  #endif
}
```

1. Recompile: `legacy_code('compile', def);`
2. Make RTW: `legacy_code('rtwmakecfg_generate',def)`
3. Make the block: `legacy_code('slblock_generate',def)`

All being well, a model window with the block will pop up. If you have problems at the compile stage, the error is fairly verbose; it&#8217;s normally due to a missing include so check folder structure. On _Windows_ spaces in directory names will cause problems so you might be better off putting the CMSIS directory at root.

At this point you can remove the MCU specific define and include from the driver source file, making the S-Block processor independent. We&#8217;ll set the MCU in the &#8216;Custom Code > Header file&#8217; section of a model instead.

## Run Model

Connect a pulse generator to the block input. You can set the pin to change state by double clicking the new block and changing the parameter. Simulate the model, it should run as normal (connect a scope between the generator and driver block to check).

<figure id="attachment_555" aria-describedby="caption-attachment-555" class="wp-caption aligncenter">
<img loading="lazy" src="/assets/img/uploads/2015/01/blink.png" alt="Basic LED blink model for ARM Cortex GPIO driver" class="size-full wp-image-555" srcset="/assets/img/uploads/2015/01/blink.png 402w, /assets/img/uploads/2015/01/blink-300x201.png 300w" /><figcaption id="caption-attachment-555" class="wp-caption-text">Basic LED blink model for ARM Cortex GPIO driver</figcaption></figure> 

## Generate Code

1. Open &#8216;Model Configuration Parameters&#8217;. In &#8216;Code Generation&#8217; set the &#8216;System target file&#8217; to &#8216;ert.tlc&#8217;. Set the &#8216;Target hardware&#8217; to &#8216;ARM Cortex-M3 (QEMU)&#8217; (you&#8217;ll need to download the toolbox linked at the top). Even though we&#8217;re not emulating, this will generate a usable example main file. At the bottom, check the checkbox &#8216;Generate code only&#8217; (if you build it will build for QEMU and get conflicting defines with our MCU).
2. Within the &#8216;Interface&#8217; section, set the &#8216;Code replacement library&#8217; to &#8216;GCC ARM Cortex-M3&#8217; (not required but makes things neater).
3. &#8216;Custom Code > Header file&#8217; add the MCU header file you are using.
4. Close the settings window and click &#8216;Deploy to Hardware&#8217;! Code should be gerenated to modename&#95;ert&#95;rtw/.

# Optional Steps

You&#8217;ve got code now that seamlessly integrates with the _Cortex_ peripherals. Making additional drivers would follow the same process (ADC, PWM, DAC, etc.). The key is basic functions that set the CMSIS defined registers.

## Add Block to Library

    MATLAB new_system('Cortex_Drivers','Library') 
    Cortex_Drivers

Drag the driver block to the new library, then follow these steps to [Add Library to Library Browser](http://uk.mathworks.com/help/simulink/ug/adding-libraries-to-the-library-browser.html). **NOTE** You&#8217;ll need to put the source files for the driver functions with any model you make or in the _MATLAB_ path.

## Build

To build this, the most friendly open is probably to copy the source into an blank project in an IDE such as Atmel Studio. For fully streamlined Simulink build I&#8217;ve developed two options.

### makefile

Using the Atmel Studio example Makefile and config.mk, one can quick throw together a Makefile that will build any _Embedded Coder_ generated code &#8211; [see my post on this](/2015/02/building-atmel-studio-asf-project-using-external-makefile/ "Building Atmel Studio ASF Project using External Makefile").

The main changes to make are the includes and source:

* Source: I wildcard contents of &#8216;modelname\_ert\_rtw&#8217; folder, followed by the block source and &#8216;system\_mcu.c&#8217;,&#8217;startup\_mcu.c&#8217;.
* Include: &#8216;modelname\_ert\_rtw&#8217;, block source folder and CMSIS includes used by block.

You can then invoke `make` using the external command option of _MATLAB_, generating a binary that can be flashed via _JTAG_.

### rtwbuild

The Cortex-M toolbox includes support for the arm-gcc compiler. I did get the program compiling using this. You must change the &#8216;Target hardware&#8217; to &#8216;None&#8217;, then in &#8216;Build configuration&#8217; specify your own flags for the source, includes and linker.

The key step is changing the &#8216;Templates > Custom template > File customization template&#8217; to &#8216;codertarget\_file\_process.tlc&#8217; &#8211; it&#8217;s the file that generates the template Makefile. For successful building, you&#8217;ll need to tweak this.

In the long term I&#8217;d like to create a specific &#8216;Target hardware&#8217; that would configure all this and provide options for MCU name etc.
