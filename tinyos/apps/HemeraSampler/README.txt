README for a HemeraSampler
@author Brad Campbell
@url http://whereabouts.eecs.umich.edu/wiki/doku.php?id=tinyos_HemeraSampler

** Quick Overview **

HemeraSampler is a straightforward app for using the sensors on the hemera board.
It samples the temperature, humidity, and light sensors. Also reports motion.

Uses Blip 2.0.

** Installation Directions **

The options are located in the Makefile. You can choose how often to sample and
where the packets should be sent to.

make epic blip install miniprog

Run the python mysql listener in $TOSROOT/support/sdk/python/tinyos/listener


** More Info **

http://whereabouts.eecs.umich.edu/wiki/doku.php?id=tinyos_HemeraSampler
