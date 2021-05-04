---
id: 951
title: Raspberry Pi Data Logger with InfluxDB and Grafana
date: 2016-11-03T18:07:21+00:00
author: John
layout: post
guid: http://engineer.john-whittington.co.uk/?p=951
permalink: /2016/11/raspberry-pi-data-logger-influxdb-grafana/
image: assets/img/uploads/2016/11/IMG_2174-2-1-825x510.jpg
categories:
  - Electronics
  - Programming
tags:
  - automation
  - guide
  - raspberrypi
---
A need popped up at work for a data logger for various lab tasks. Quickly looking at the market, I failed to identify a lab tool for data logging (cheap, easy but powerful setup, remote access); something for researchers and scientists. I decided a Raspberry Pi with some input buffering would be ideal for the task. This is my roll your own data logger, put together on Saturday &#8211; showing what is possible quickly and potential with more development time.

## Hardware Setup

  * Raspberry Pi (3) &#8211; I used a 3 for integrated wifi and speed but any Pi should work.
  * SD Card &#8211; A reliable brand as the database will be writing frequently. I used a [16GB SanDisk Extreme](https://www.7dayshop.com/16gb-micro-sd-cards/sandisk-extreme-micro-sdhc-micro-sd-memory-card-class-10-uhs-1-u3-90mb-s-with-full-size-sd-card-adapter-16gb)
  * Some form of IO buffer or input device. I first developed with a [DHT22](https://www.adafruit.com/product/385) temperature/humidity sensor, followed by a [potential divider/zener diode digital logic buffer](http://www.falstad.com/circuit/circuitjs.html?cct=$+1+0.000005+10.20027730826997+63+10+62%0Av+384+416+384+96+0+0+40+24+0+0+0.5%0Aw+384+96+512+96+0%0Ar+512+96+512+256+0+27000%0Ar+512+256+512+416+0+3900%0Aw+384+416+512+416+0%0AO+608+256+672+256+1%0Az+592+384+592+288+1+0.805904783+3.6%0Aw+592+288+592+256+0%0Aw+608+256+592+256+0%0Aw+592+256+512+256+0%0Aw+592+384+592+416+0%0Aw+592+416+512+416+0%0A) then finally a [Pimoroni Automation HAT](https://shop.pimoroni.com/products/automation-hat) for analogue voltage. I plan on creating a custom multi-channel buffered 24V logic and 0-10V analogue input card to partner with this, for industrial device testing.

## Install InfluxDB and Grafana on Raspberry Pi

A while back I attempted this but ran into problems installing and configuring InfluxDB and Grafana. I had attempted to user Docker but without success. Thankfully, .deb packages now exist in the Debian &#8216;Stretch&#8217; repository for armhf (Raspberry Pi). You and either add &#8216;Stretch to your list of sources or download the packages with `wget`:

```bash
# update these URLs by looking at the website: https://packages.debian.org/sid/grafana
sudo apt-get update
sudo apt-get upgrade
wget http://ftp.us.debian.org/debian/pool/main/i/influxdb/influxdb_1.0.2+dfsg1-1_armhf.deb
sudo dpkg -i influxdb_1.0.2+dfsg1-1_armhf.deb
wget http://ftp.us.debian.org/debian/pool/main/g/grafana/grafana-data_2.6.0+dfsg-3_all.deb # grafana data is a dependancy for grafana
sudo dpkg -i grafana-data_2.6.0+dfsg-3_all.deb
sudo apt-get install -f
wget http://ftp.us.debian.org/debian/pool/main/g/grafana/grafana_2.6.0+dfsg-3_armhf.deb
sudo dpkg -i grafana_2.6.0+dfsg-3_armhf.deb
sudo apt-get install -f
```

## Setup InfluxDB

Installed via the .deb package, InfluxDB creates a service and enables at startup so there is little more configuration to do. One must create the databases that our scripts will be saving into. This can be done via the web gui. Navigate to your Pi IP on port 8083 (default InfluxDB admin port &#8211; http://localhost:8083 if you&#8217;re doing this on the Pi). Using the &#8216;Query Templates&#8217; dropdown, one can create a database with &#8216;Create Database&#8217; &#8211; it&#8217;s fairly self explainatory. Make one called &#8216;logger&#8217; to store our sample data.

<img loading="lazy" class="aligncenter size-large wp-image-969" src="http://engineer.john-whittington.co.ukassets/img/uploads/2016/11/influx-1024x208.gif" alt="InfluxDB Create Database" srcset="/assets/img/uploads/2016/11/influx-1024x208.gif 1024w, /assets/img/uploads/2016/11/influx.gif 300w, /assets/img/uploads/2016/11/influx-768x156.gif 768w" />

## Create Logging Script

The example below uses Pimoroni&#8217;s Automation HAT but can be easily adapted to a GPIO pin or DHT22 using the commented lines. It&#8217;s worth having a read of the [InfluxDB Key Concepts](https://docs.influxdata.com/influxdb/v1.0/concepts/key_concepts/) but essentially, I create a unique _tag_ for each time the script runs called &#8216;run&#8217;. This enables a user to differentiate between test setups with no backend jiggery pockery when we come to Grafana. The _measurement_ name can be set via the command arguments, to enable a user to set different testing _sessions_, currently by default it is &#8216;dev&#8217;. You&#8217;ll need the InfluxDB Python module for this script, which you can install like this:

`sudo pip install influxdb`

```python
import time
import sys
import datetime
from influxdb import InfluxDBClient
import automationhat
#import RPi.GPIO as GPIO

# Set this variables, influxDB should be localhost on Pi
host = "localhost"
port = 8086
user = "root"
password = "root"

# The database we created
dbname = "logger"
# Sample period (s)
interval = 1

# For GPIO
# channel = 14¬
# GPIO.setmode(GPIO.BCM)¬
# GPIO.setup(channel, GPIO.IN)¬

# Allow user to set session and runno via args otherwise auto-generate
if len(sys.argv) &gt; 1:
    if (len(sys.argv) &lt; 3):
        print "Must define session and runNo!!"
        sys.exit()
    else:
        session = sys.argv[1]
        runNo = sys.argv[2]
else:
    session = "dev"
    now = datetime.datetime.now()
    runNo = now.strftime("%Y%m%d%H%M")

print "Session: ", session
print "runNo: ", runNo

# Create the InfluxDB object
client = InfluxDBClient(host, port, user, password, dbname)

# Run until keyboard out
try:
    while True:
        # This gets a dict of the three values
        vsense = automationhat.analog.read()
        op = automationhat.input.read()
        # gpio = GPIO.input(channel)
        print vsense
        print op
        iso = time.ctime()

        json_body = [
        {
          "measurement": session,
              "tags": {
                  "run": runNo,
                  },
              "time": iso,
              "fields": {
                  "op1" : op['one'], "op2" : op['two'], "op3" : op['three'],
                  "vsense1" : vsense['one'],"vsense2" : vsense['two'],"vsense3" : vsense['three']
                  # ,"gpio" : gpio
              }
          }
        ]

        # Write JSON to InfluxDB
        client.write_points(json_body)
        # Wait for next sample
        time.sleep(interval)

except KeyboardInterrupt:
    pass
```

Save the script as &#8216;logger.py&#8217; and run using `python logger.py`. To run the script in the background and indefinately as a ssh user use `nohup python logger.py &`.

## Setup Grafana

Unlike InfluxDB, Grafana doesn&#8217;t enable it&#8217;s service, so do this to enable at boot and start the service now:

```bash
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

Navigating to port 3000, you should be presented with the Grafana web GUI. Grafana has plenty of powerful querying tools to make lots of pretty and informative graphs. Have a read of the [Getting Started](http://docs.grafana.org/guides/gettingstarted/), and in particular the [InfluxDB section](http://docs.grafana.org/datasources/influxdb/).

The first thing you will need to do is add the &#8216;logger&#8217; database as a _Datasource_. Navigate to Datasource->Add New and fill in as below

<figure id="attachment_967" aria-describedby="caption-attachment-967" class="wp-caption aligncenter">
<img loading="lazy" class="wp-image-967 size-full" src="/assets/img/uploads/2016/11/datasource.gif" alt="Create the 'logger' InfluxDB database as a Datasource" /><figcaption id="caption-attachment-967" class="wp-caption-text">Create the &#8216;logger&#8217; InfluxDB database as a Datasource</figcaption></figure> 

After this, you need to setup a _Dashboard_. Click the top dropdown button, press &#8216;New&#8217; and create a dashboard called &#8216;logger&#8217;. The dashboards consist of _rows_. Clicking on the green bar on the left-hand edge provides a dropdown where one can add graphs etc &#8211; again, the [Getting Started](http://docs.grafana.org/guides/gettingstarted/) explains this better than me. Below are a couple of captures of how I setup the Automation HAT.

  <figure class='gallery-item'> 
<img src="/assets/img/uploads/2016/11/runs.gif" class="attachment-medium size-medium" alt="" loading="lazy" aria-describedby="gallery-28-978" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-28-978'> The template variable in Grafana is a powerful way to change what the dashboard shows. Here, runs can be selected. </figcaption></figure><figure class='gallery-item'> 
  
<img src="/assets/img/uploads/2016/11/panel.gif" class="attachment-medium size-medium" alt="" loading="lazy" aria-describedby="gallery-28-977" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-28-977'> Query for Automation HAT voltage input </figcaption></figure><figure class='gallery-item'> 

<img src="/assets/img/uploads/2016/11/environment.gif" class="attachment-medium size-medium" alt="" loading="lazy" aria-describedby="gallery-28-976" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-28-976'> I started developing with a DHT22 temperature and humidity sensor. </figcaption></figure>

<figure class='gallery-item'> 
<img src="/assets/img/uploads/2016/11/operate.gif" class="attachment-medium size-medium" alt="" loading="lazy" aria-describedby="gallery-28-975" />
<figcaption class='wp-caption-text gallery-caption' id='gallery-28-975'> Digital input on/off graph </figcaption></figure>

<figure class='gallery-item'>
<img src="/assets/img/uploads/2016/11/dashboard.png" class="attachment-medium size-medium" alt="" loading="lazy" aria-describedby="gallery-28-985" />
  <figcaption class='wp-caption-text gallery-caption' id='gallery-28-985'> I setup my logger to log the remote outputs of high voltage generators I&#8217;m working on. </figcaption></figure>

## Log Away

With this short introduction you should have the framework for a basic logging device and see the potential for real-world analytics of almost anything! I&#8217;m quite excited using the combination of a time based database like _InfluxDB_ and powerful web graphing package _Grafana_.
