HemeraAM
========
@author Thomas Zachariah
@url    http://github.com/lab11/hemera


Overview
--------

HemeraAM samples temperature, humidity, light, and motion, 
and sends the recorded data via Active Message. 


Installation
------------

Options are located in the Makefile.
Sampling Period & Radio Channel may be adjusted there.

RUN:

    ./install #

(where # is the intended id number of the device) OR

    make hemera install miniprog bsl,/dev/ttyUSB0

When using the install script or the alternate command,
ensure location (`/dev/ttyUSB?`) is correct.


Verification
------------

To verify broadcast, press the user button on the back:
- If the program is running, the green LED will turn on.
- If it is sending packets, the blue LED will toggle.
- If an error is encountered, the red LED will toggle.