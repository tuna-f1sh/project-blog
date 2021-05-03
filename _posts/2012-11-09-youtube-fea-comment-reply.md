---
id: 155
title: YouTube FEA Comment Reply
date: 2012-11-09T08:50:56+00:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=155
permalink: /2012/11/youtube-fea-comment-reply/
categories:
  - Programming
  - University
tags:
  - fea
  - MATLAB
---
> I was wondering what the technique is called that you used on the K matrix before solving for U?  
> The one where it﻿ takes the BC and makes 0 rows and columns, and then makes the K(i,i)=1 at the BC &#8211; [GoPDemon](http://www.youtube.com/watch?v=IiM5gC5jo8Q&lc=0HMsyVDGFbdUENqAgfZn8mWkokh1J36so-9CE9GZHhY)

<!--more-->

I first convert the boundary matrix into a vector so that it is easier to deal with. The code just creates an empty vector the correct size, then fills it with the rows and columns of the user defined boundary points.

<pre>%First boundarys must be convertered to vector
%Create empty boundary vector
BC(1:(size(nodes,1)*n_multi),1) = 0;
%Zero column increment
h = 1;

%Convert boundary matrix to vector
for node_r = 1:size(nodal_boundary,1)
    %For each row get the column force
    for node_c = 1:size(nodal_boundary,2)
        %Put the force into the vector F
        BC(h) = nodal_boundary(node_r, node_c);
        h = h+1;
    end
end
</pre>

Then, to apply to boundary conditions to the stiffness matrix, I scan the new vector _BC_ for fixed points (1). At these points, the row and column of _K_ is zero&#8217;d and the diagonal set to 1.

<pre>%Loop to zero forces at boundaries
for i = 1:size(BC,1)
    %If statement to set lines and columns coresponding to constrained
    %point to zero
    if BC(i) == 1
        K(i,:) = 0;
        K(:,i) = 0;
        %Set diagonal term to 1
        K(i,i) = 1;
        %Zero force at boundary
        F(i) = 0;
    end
end
</pre>

Hope that was the explanation you meant.