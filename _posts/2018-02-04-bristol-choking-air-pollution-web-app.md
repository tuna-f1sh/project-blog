---
id: 1161
title: 'Is Bristol Choking &#8211; Air Pollution Web App'
date: 2018-02-04T10:16:57+00:00
author: John
layout: post
guid: /?p=1161
permalink: /2018/02/bristol-choking-air-pollution-web-app/
image: assets/img/uploads/2018/02/Screen-Shot-2018-02-04-at-10.16.06-825x510.png
categories:
  - Programming
tags:
  - python
---

__UPDATE: I have not renewed the domains for this so it's now down__

![isbristolchoking.uk screenshot](/assets/img/uploads/2018/02/Screen-Shot-2018-02-04-at-10.16.06-825x510.png)

I had some of my [Nixie Pipe](http://www.nixiepipe.com) displays showing air pollution data collected by the council, using a Python web scraper at an art trail and people seemed very interested and unaware of the data. I considered how good it would be to have live displays at the air monitoring sites for people to see, but decided a web app was more feasible as a weekend project and less risky!

[Is Bristol Choking?](http://isbristolchoking.uk) is the result. You may wonder what I mean by choking: I&#8217;ve classed an area as choking if the current 15 minute average NO2 value is greater than the annual mean legal limit set by the EU of 40 µg/m³ and as stated in the WHO guidelines. Check the website during rush hours and weekend daytime and most are choking. Have a read of the [choking](http://isbristolchoking.uk/#choking?) and [about](http://isbristolchoking.uk/#about) sections for more.

I used it as a means to learn Python Flask and Python web app tech in general and hope it is clearer and easier to understand than the council site. There is an about section that should add some context to the numbers, which I feel the council site was lacking.

I enjoyed the process of creating the app and learnt quite a lot. Initially, I was scraping the data in the same function call as the main landing page route, which created a short delay with no feedback for the user; it appeared as if the page was taking a while to load. Instead, I ended up using WebSockets with Flask to asynconously scrape the data from the Bristol Air Quality site so that Flask could render the template index.html with a scraping loading animation, then populate the fields via json passed from Flask to a Javascript socket event.

[GitHub repository](https://github.com/tuna-f1sh/bristol-choking)
