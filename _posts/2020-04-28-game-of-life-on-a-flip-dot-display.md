---
id: 1382
title: Game of Life on a Flip-Dot Display
date: 2020-04-28T12:41:59+01:00
author: John
layout: post
guid: /?p=1382
permalink: /2020/04/game-of-life-on-a-flip-dot-display/
image: assets/img/uploads/2020/04/Screenshot-2020-04-28-at-14.54.20-e1588078613172-1200x698.png
categories:
    - Programming
tags:
    - flipdot
---
With the passing of John Conway, I decided to add &#8216;Game of Life&#8217; to a Flip-Dot project I&#8217;m working on, in honour of his work.

I show a couple of random starts, a start from text &#8216;Hello!&#8217; and a start with some known forms.

<div class="box">
<iframe width="560" height="315" src="https://www.youtube.com/embed/FjQ4jZS2f9M" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Physical display is an Alfa-Zeta XY5 28&#215;14. I&#8217;m building it into a much larger display (252&#215;56) so I develop with a curses based simulator most of the time. I show Game of Life running in this at the end, the larger area allows for some known persistent patterns at start.

Uses Python PIL based driver: <https://github.com/tuna-f1sh/flipdot>  
With custom async display manager, Game of Life functions: <https://gist.github.com/tuna-f1sh/9e6ff4552f75de3705cae6d3c044b1cc>
