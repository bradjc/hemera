Hemera Indoor Sensor Node
=========================

Hardware and software for an indoor wireless sensor node that measures temperature,
humidity, light and motion.


Hardware
--------

The node contains three key sensors:
- Sensirion SHT11 (temperature and humidity)
- motion
- Rohm BH1721 (light [lux])

For processing and radio it uses the Epic chip.

Revision C of the hardware is stable. Revisions A and B use an analog light sensor and the
circuit for the light sensor doesn't work. Rev C also has better thermal isolation for the
SHT11.

###Errata

There is still strange behavior with the motion sensor GPIO being triggered when the SHT11
is sampled. I never got to the bottom of this, but disabling the interrupt for the motion
sensor when sampling the SHT11 works around the problem.


Software
--------

The software I have is in TinyOS. You need the main TinyOS repo, my additions to the main
repo, and this repository to get the code to compile.
