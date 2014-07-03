RpiGatdForwarder
========
@author Thomas Zachariah
@url    http://github.com/lab11/hemera


Overview
--------

RpiGatdForwarder accepts all incoming packets on a channel,
and forwards them to a server (GATD).


Installation
------------

Configure the settings in the Makefile. Then run:

    make rpi install scp.<ip address of the RPi>

Alternatively, you can copy the precompiled app `RpiGatdForwarderC` (runs using default settings) directly to the home directory of the Raspberry Pi.


Run
---

On the Raspberry Pi, run:

    sudo ~/RpiGatdForwarderC
