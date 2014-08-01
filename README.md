Hemera Indoor Sensor Node
=========================

Hemera is an indoor wireless sensor node that measures temperature, humidity, light and motion.

The node contains three key sensors:
- Sensirion SHT11 (Temperature and Humidity)
- Rohm BH1721 (Light)
- PIR (Motion)

[
![hemera](http://www.bradcampbell.com/wp-content/uploads/2012/05/hemera_project.jpg)
](http://www.bradcampbell.com/wp-content/uploads/2012/05/hemera_project.jpg)


Setup
-----

### 1) Clone &amp; install the Lab11 version of tinyos-main:

    git clone https://github.com/lab11/tinyos-main.git
    cd tinyos-main/tools
    ./Bootstrap
    ./configure
    make
    sudo make install


### 2) Clone yours truly:

    git clone https://github.com/lab11/hemera.git


### 3) Add to `bash.rc`:

    export TINYOS_ROOT_DIR=<path to>/tinyos-main
    export TINYOS_ROOT_DIR_ADDITIONAL=<path to>/hemera/tinyos:$TINYOS_ROOT_DIR_ADDITIONAL


### 4) Set up the RaspberryPi (optional, but recommended):

A modified RaspberryPi can be utilized to receive and forward data to GATD. 
If you choose to use one, you need the [Linux CC2520 Driver](https://github.com/ab500/linux-cc2520-driver) for the RPi.
Instead of installing this manually, it is suggested to download &amp; install the preinstalled image from [this torrent](https://github.com/lab11/raspberrypi-cc2520/tree/master/torrents).
Go to https://github.com/lab11/raspberrypi-cc2520 for additional details on setup.

Clone the RPi repo:

    git clone https://github.com/lab11/raspberrypi-cc2520.git

Add to `bash.rc`:

    export TINYOS_ROOT_DIR_ADDITIONAL=<path to>/raspberrypi-cc2520/tinyos:$TINYOS_ROOT_DIR_ADDITIONAL


### 5) Get the compilers

In order to compile the TinyOS code you need the msp430 and the ARM compilers


Sense Stuff
-----------

After you have finsihed the above setup, you should be ready to install apps on the Hemera board.

The basic sense &amp; broadcast app is HemeraAM. To install it, go to `<path to>/hemera/tinyos/apps/HemeraAM` and follow the README. 

To receive &amp; forward data to GATD on the RPi, go to `<path to>/hemera/tinyos/apps/RpiGatdForwarder` and follow the README.
