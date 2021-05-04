---
id: 245
title: Modelling a Double Pendulum in Simulink
date: 2013-04-26T07:35:06+01:00
author: John
layout: post
guid: /?p=245
permalink: /2013/04/modelling-a-double-pendulum-in-simulink/
image: assets/img/uploads/2013/04/4.jpg
categories:
  - Programming
  - University
tags:
  - control systems
  - MATLAB
  - simulink
---
One module I took during the final year of my degree was &#8216;System Modelling and Simulation&#8217;. A well taught and great module, one of the tasks was to model a double pendulum.

The approach involved deriving the equations of from the highest order of motion for each mass then working backwards through Simulink blocks to generate each term, which could then be to solve the equation &#8211; a bit of a chicken and egg problem! It was a an excellent task as the idea seems a little backwards at first and gave me a fresh approach to problem solving a model.

Below is the method extract from my report as the YouTube demo has generated some interest in the solution.

<figure id="attachment_262" aria-describedby="caption-attachment-262" style="width: 584px" class="wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-262" src="/assets/img/uploads/2013/04/3.jpg" alt="The double pendulum to be modelled." /><figcaption id="caption-attachment-262" class="wp-caption-text">The double pendulum to be modelled.</figcaption></figure> 

## Theory

Double pendula are an example of a simple physical system which can exhibit chaotic behavior [[1]](http://scienceworld.wolfram.com/physics/DoublePendulum.html). That is to say it is sensitive to initial conditions and that its movements, although predictable, appear random. Equations of motion for the pendulum of Fig.?? can be derived by first considering the x and y components of displacement:

$$
    \begin{align}
    x_1 = l_{1}\sin(\theta_{1}) \\
    y_2 = -l_{1}\cos(\theta_{1}) \\
    x_2 = l_{1}\sin(\theta_{1}) + l_{2}\sin(\theta{2}) \\
    y_2 = -l_{1}\cos(\theta_{1}) - l_{2}\cos(\theta{2})
    \end{align}
$$

Leading to potential and kinetic energies of the system:  

$$
    \begin{align}
    PE = V = m_1gy_1 + m_2gy_2 \\
    = -(m_1+m_2)gl_1\cos{\theta_1} - m_2gl_2\cos{\theta_2} \\
    KE = T = \frac{1}{2}m_1v_1^2+\frac{1}{2}m_2v_2 \\
    = \underbrace{\frac{1}{2}m_1l_1^2\dot{\theta_1^2}}{m_1} + \underbrace{\frac{1} {2}m_2[l_1^2\dot{\theta_1^2}+l_2^2\dot{\theta_2^2}+2l_1l_2\dot{\theta_1}\dot{\theta_2}\cos{(\theta_1 - \theta_2)}]}{m_2}
    \end{align}
$$

And Langrangian:

$$
    L \equiv T-V \\
    = \frac{1}{2}(m_1+m_2)l_1^2\dot{\theta_1^2} + \frac{1}{2}m_2l_2^2\dot{\theta_2^2} \\ + m_2l_1l_2\dot{\theta_1}\dot{\theta_2}\cos{(\theta_1-\theta_2)} + (m_1+m_2)gl_1\cos{\theta_1} + m_2gl_2cos{\theta_2}
$$

For $$\theta_1$$, the simplified Euler-Lagrange differential equation becomes:

$$
    (m_1+m_2)l_1\ddot{\theta_1} + m_2l_1\ddot{\theta_2}\cos{(\theta_1-\theta_2)} + m_2l_2\dot{\theta_2^2}\sin{(\theta_1-\theta_2)} + (m_1+m_2)g\sin{\theta_1} = 0
$$

Or in this case $$LHS=T$$. Similarly, $$\theta_2$$ becomes:

$$
    m_2l_2\ddot{\theta_2} + m_2l_1\ddot{\theta_1}\cos{(\theta_1-\theta_2)} - m_2l_1\dot{\theta_1^2}\sin{(\theta_1-\theta_2)} + m_2g\sin{\theta_2} = 0
$$

**Simulink Model**

The _Simulink_ model was constructed by first considering the various terms which make up the equations of motion ([5](#id635968605)), ([6](#id3169393751)); each of the terms can be derived from the highest order of $$\theta$$: $$\ddot{\theta}$$. Hence, development begin by creating a mathematical flow of blocks, with each output a term within the equation [Fig.??].

<figure id="attachment_261" aria-describedby="caption-attachment-261" class="wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-261" src="/assets/img/uploads/2013/04/2.jpg" alt="The starting point for the Simulink model." /><figcaption id="caption-attachment-261" class="wp-caption-text">The starting point for the Simulink model.</figcaption></figure>

Outputs for $$\dot{\theta_1^2}, \dot{\theta_2^2}, \sin{\theta_1}$$, etc. had been created but the inputs $$\ddot{\theta_1}$$ and $$\ddot{\theta_2}$$ where unknown. By rearranging the equations of motion to a set of functions in terms of $$\ddot{\theta_1}$$ and $$\ddot{\theta_2}$$, they can be applied to the outputs and result fed back to the inputs:

$$
    \begin{align}
    \ddot{\theta_1} = \frac{b_1 - b_2}{b_3} \\
    \ddot{\theta_2} = \frac{b_2 - b_4}{b_5}
    \end{align}
$$

Where:

$$
    \begin{align}
    b_1 = T - (m_1+m_2)gsin{\theta_1} - m_2l_2\dot{\theta_2^2}sin{(\theta_1-\theta_2)} \\
    b_2 = m_2l_2\dot{\theta_1}^2sin{(\theta_1-\theta_2)}-m_2gsin{\theta_2} \\
    b_3 = (m_1+m_2)l_1 - m_2l_1\cos^2(\theta_1-\theta_2) \\
    b_4 = m_2l_1\ddot{\theta_1}cos(\theta_1-\theta_2) \\
    b_5 = m_2l_2
    \end{align}
$$

The outputs are combined using a Mux block, a multiplexor which creates an array of its inputs. Similarly, the masked system parameters are defined using MATLAB variables as Constant blocks and combined with another Mux. The $$b$$ terms are then found by creating Function blocks referencing these arrays, which are then equated accordingly to find $$\ddot{\theta_1}$$ and $$\ddot{\theta_2}$$. Kinetic energies of the masses are also found at this stage in a similar manor.. The angular accelerations are then fed back to the start of the block diagram. Initial angle conditions are set in the displacement Integrator to the MATLAB variables.

<figure id="attachment_260" aria-describedby="caption-attachment-260" class="wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-260" src="/assets/img/uploads/2013/04/1.jpg" alt="The complete un-masked sub-system" /><figcaption id="caption-attachment-260" class="wp-caption-text">The complete un-masked sub-system</figcaption></figure> 

The pendulum model was &#8216;masked&#8217; into a sub-system block for cleaner integration with the proceeding models [Appendix: ??]. Firstly, for Steps.2-5 of the experiment, the system of Fig.?? was used, which saves the outputs of the pendulum to file for manipulation within _MATLAB_. Secondly, for Step.5, a closed loop system with a _PID_ block was used [Fig.??].

For the purpose of experimenting with the system for the report, I created two simple _MATLAB_ scripts:

* Pre-processing &#8211; to define the variables (masses, length, gravity etc.)
* Post-processing &#8211; to create output plots and an animation.

This made the whole model very easy to use and play around with. I also various disturbances and feedback loops to the system, that can be turned on and off.

<figure id="attachment_263" aria-describedby="caption-attachment-263" class="wp-caption aligncenter">
<img loading="lazy" class="size-large wp-image-263" src="/assets/img/uploads/2013/04/4.jpg" alt="The final system with masked sub-system, PID control and disturbances." /><figcaption id="caption-attachment-263" class="wp-caption-text">The final system with masked sub-system, PID control and disturbances.</figcaption></figure> 



Here&#8217;s the code and model:

[Pendulum](/assets/img/uploads/2013/04/Pendulum.zip)
