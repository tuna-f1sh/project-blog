---
title: Cyme - System USB Bus and Device Listing
date: 2023/01/01
tags: rust, cli
categories: Programming
image: assets/img/cyme-header.png
layout: post
---

[`cyme`](https://github.com/tuna-f1sh/cyme) is a Rust CLI tool I developed for listing system USB buses and devices - a modern cross-platform alternative to `lsusb`. Here is the README intro:

The project started as a quick replacement for the barely working lsusb script and is my yearly Rust project to keep up to date! Like most fun projects, it quickly experienced feature creep as I developed it into a cross-platform replacement for lsusb. As a developer of embedded devices, I use a USB list tool on a frequent basis and developed this to cater to what I believe are the short comings of lsusb; verbose dump is too verbose, tree doesn't contain useful data on the whole, it barely works on non-Linux platforms and modern terminals support features that make glancing through the data easier.

It's not perfect as it started out as a Rust refresher but I had a lot of fun developing it and hope others will find it useful and can contribute. Reading around the lsusb source code, USB-IF and general USB information was also a good knowledge builder.

The name comes from the technical term for the type of blossom on a Apple tree: cyme - it is Apple related and also looks like a USB device tree 😃🌸.

[![asciicast demo](https://asciinema.org/a/IwYyZMrGMbXL4g15qDIaUViyM.svg)](https://asciinema.org/a/IwYyZMrGMbXL4g15qDIaUViyM)
