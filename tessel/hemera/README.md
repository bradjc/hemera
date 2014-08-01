Hemera on Tessel
================

Want to implement Hemera on a Tessel? You've come to the right place!  


Requirements
------------

* [Tessel](http://tessel.io)
* [Climate module](https://tessel.io/modules#module-climate)
* [Ambient module](https://tessel.io/modules#module-ambient)
* Standard 3-pin PIR sensor (VCC, GND, OUT)
* [Node.js](http://nodejs.org)


Setup
-----

The assumed module connections are as follows:
- Ambient Module -> Port A
- Climate Module -> Port B
- PIR Sensor -> Port D ( GND -> G1, VCC -> G2, OUT -> G3 )

This, along with HTTP POST destination (default:GATD), can be changed by modifying `hemera.js`.


Installation
------------

If you have yet to do so, [install Node.js & Tessel](http://start.tessel.io/install).

Install the modules:

    npm install ambient-attx4
    npm install climate-si7005
    npm install climate-si7020

Connect to WiFi:

    tessel wifi -n [network name] -p [password]

Run:

    tessel run hemera.js

Save on Tessel to run automatically:

    tessel push hemera.js
