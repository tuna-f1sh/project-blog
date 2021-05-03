---
id: 7
title: 'FYP: MATLAB A* Based Path Planner for Autonomous Off-Road Vehicle'
date: 2012-06-25T13:42:24+01:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=7
permalink: /2012/06/fyp-matlab-a-based-path-planner-for-autonomous-off-road-vehicle/
image: /wp-content/uploads/2012/06/cropped-wordpress.jpg
categories:
  - University
tags:
  - 'a*'
  - featured
  - MATLAB
  - path planning
  - robotics
---
<figure id="attachment_9" aria-describedby="caption-attachment-9" style="width: 584px" class="wp-caption alignnone">[<img loading="lazy" class="size-large wp-image-9" title="Final Year Project Poster" src="http://engineer.john-whittington.co.uk/wp-content/uploads/2012/06/PosterA3-723x1024.jpg" alt="" width="584" height="827" srcset="/assets/img/uploads/2012/06/PosterA3-723x1024.jpg 723w, /assets/img/uploads/2012/06/PosterA3-212x300.jpg 212w, /assets/img/uploads/2012/06/PosterA3.jpg 1754w" sizes="(max-width: 584px) 100vw, 584px" />](http://engineer.john-whittington.co.uk/wp-content/uploads/2012/06/PosterA3.jpg)<figcaption id="caption-attachment-9" class="wp-caption-text">A picture says 1000 words</figcaption></figure> 

# Synopsis

A new venture for the University of Bath and a collaboration with Mechanical and Electrical Engineering, the autonomous quad project aims to convert an ’off the shelf’ miniature quad bike to a driverless one. Generation of a least cost path to a pre-defined goal is required, which avoids known obstacles and will update for new obstacles detected during driving. The A* search algorithm is chosen and a comprehensive planner developed within MATLAB.  
<!--more-->

# Abstract

A path planner is required as part of an autonomous off-road vehicle project at the University of Bath, which is able to generate both an initial path (off-line) around obstacles to a goal, and update using data from camera detection during driving (on-line). The A\* search algorithm is selected as the program foundation (including a custom cost function with terrain traversability and steering penalty) and developed using the MATLAB com- puting package. Limitations of the algorithm are clear, with a 45◦ angle step making the method unsuitable for driving autonomy. Following this conclusion the planner is improved and better tailored to our project, by testing three ‘angle-angle’ methods: Line of Sight Path Smoothing, Theta\* and Field D* Interpolation. The two former are found to create the desired line, unbounded by the nodal grid, but as ‘short-cut’ techniques still provide no method of limiting the degree of turning.

Field D* interpolation is successfully implemented and forms the final planner in both off-line and on-line routines, generating a path in average times 1.8s and 50ms respectively, for a 0.1km2 workspace, 1m node size, and a 7.5◦ interpolation step; parameters found to be most suiting to our vehicle with a 22.5◦ steering limit. Heuristic weighting is found to improve searching time by 130%, using a value 20. Steering weight is less decisive and depends on the workspace configuration, a marginal inclusion in f(n) using a value 15 is seen to reduce drive time. All results are simulated due to the project and other sub-systems not yet being at a testing stage; real-world testing remains as the principle of any future work.

[FinalReport](http://engineer.john-whittington.co.uk/wp-content/uploads/2012/06/FinalReport.pdf)