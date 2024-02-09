---
title: Tailwind - Wahoo Headwind BLE Remote with Rust
date: 2023/12/11
tags: development, embedded, rust, nordic, hacking
categories: Programming
image: assets/img/tailwind-remote.jpeg
layout: post
---

I recently purchased a [_Wahoo Headwind_](https://eu.wahoofitness.com/devices/indoor-cycling/accessories/kickr-headwind) as part of my static trainer setup. The device lacks a button remote in favour of App based control. Whilst this works okay in principle, anyone that has used a static trainer knows that in the sweaty heat of the moment trying to use a App is frustrating at best!

So I decided to use the opportunity to explore using (embedded) Rust on the Nordic nRF series. Developing BLE for Nordic chips involves a reasonably complex toolchain since the BLE stack is a closed-source binary (SoftDevice) and there is a lot of supporting modules. I was intrigued to see what the experience would be like outside of the C _Nordic nRF Connect SDK_.

[Embassy](https://embassy.dev/) have created a [SoftDevice Rust binding generator project](https://github.com/embassy-rs/nrf-softdevice) for the nRF series that formed the foundation of my project. Using it also allowed me to learn about many parts of the Rust embedded ecosystem, such as [Probe](https://probe.rs/), the [Embassy](https://embassy.dev/) runtime itself and working with [Rust embedded-hal(s)](https://github.com/rust-embedded/embedded-hal).

![/assets/img/tailwind-wirkshark.png](/assets/img/tailwind-wireshark.png)
__Small snapshot of Wahoo App BLE logging to reverse engineer protocol__

The Headwind protocol was fairly easy to reverse engineer using the Android Wahoo App with HCI BLE logging enabled and some other hacking attempts around the internet. I was able to review the action/result using WireShark. The protocol isn't great in my opinion, using a fixed cyclic update rather than actual notify and seems to lag behind the actual state of the device at times.

I could have ignored the device state all together but I wanted to keep synchronisation so that I can seamlessly switch control between the App, front-panel and the remote. A press of the remote button will request and assert the change so that the button press will always reflect a change in the actual state of the device.

<div class="box">
<iframe width="560" height="315" src="https://www.youtube.com/embed/c2azojD2oZM?si=xC57Zcoo9vrkFaW8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</div>

In all it was a fun project and fills the requirement. Whilst the Rust developer experience surpassed that of using the C SDK - the benefits of a modern language and package manager - it's not as powerful as the ZephyrOS based toolchain provided by the new Nordic nRF Connect SDK. ZephyrOS is a joy to use, so I'll take the shortcomings of C (fine with experience/working practices) for now in order to use it. Perhaps as Embassy develops, Nordic will adopt a Rust SDK but I don't see this happening in the near future. For a simple device like this, I'll turn to the Rust stack. For a custom fully featured BLE device, I'll stick to the nRF SDK for now...

[GitHub Project](https://github.com/tuna-f1sh/tailwind)
