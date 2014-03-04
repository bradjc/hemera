COMPONENT=HemeraMonjoloC

PFLAGS += -DCC2420_DEF_CHANNEL=21

################################################################################
### Set the addressing scheme
################################################################################

# Use IN6_PREFIX with static addressing modes
PFLAGS += -DIN6_PREFIX="\"::\""
# Use BLIP Neighbor Discovery to autoconfigure an address
PFLAGS += -DBLIP_ADDR_AUTOCONF=0
# Use RPL and prefix information in DIO messages to autoconfigure an address
PFLAGS += -DRPL_ADDR_AUTOCONF=0

################################################################################
### Configure BLIP
################################################################################

# Configure the Neighbor Discovery mechanism
PFLAGS += -DBLIP_SEND_ROUTER_SOLICITATIONS=0
PFLAGS += -DBLIP_SEND_ROUTER_ADVERTISEMENTS=0

# Configure the number of times BLIP tries to send a packet and how long it
# waits between attempts
PFLAGS += -DBLIP_L2_RETRIES=1
#PFLAGS += -DBLIP_L2_DELAY=103

# Configure how many of the 6LoWPAN headers we support
#PFLAGS += -DLIB6LOWPAN_FULL=1

# Configure the header compression for 6LoWPAN
PFLAGS += -DLIB6LOWPAN_HC_VERSION=6

# Keep statistics about various BLIP/IPv6 parameters. See BlipStatistics.h
#PFLAGS += -DBLIP_STATS
#PFLAGS += -DBLIP_STATS_IP_MEM

################################################################################
### Configure RPL
################################################################################

# Include the RPL layer if set to 1
#PFLAGS += -DRPL_ROUTING=1

# If set keep routing information in each node. If not the root must keep all
# routing information.
PFLAGS += -DRPL_STORING_MODE=1

# Choose the objective function RPL should use
PFLAGS += -DRPL_OF_0=1
PFLAGS += -DRPL_OF_MRHOF=0

################################################################################
### Configure LPL
################################################################################

PFLAGS += -DLOW_POWER_LISTENING
PFLAGS += -DLPL_SLEEP_INTERVAL=512
PFLAGS += -DLPL_DEF_LOCAL_WAKEUP=512
PFLAGS += -DLPL_DEF_REMOTE_WAKEUP=512

################################################################################
### Configure printf() output
################################################################################

#PFLAGS += -DPRINTFUART_ENABLED

################################################################################
### Configure this application
################################################################################

# Set the address and port to send the packets to
PFLAGS += -DRECEIVER_ADDR=\"2001:470:1f10:131c::2\"
PFLAGS += -DRECEIVER_PORT=4001

#PFLAGS += -DENABLE_LEAF_NODES
#PFLAGS += -DUSE_TESTIO

# Temperature, humidity, and light sample period
PFLAGS += -DTHL_SAMPLE_PERIOD=60000
#PFLAGS += -DTHL_SAMPLE_PERIOD=1000

# Whether or not to use the LEDs
#PFLAGS += -DUSE_LEDS

# Uncomment this to disable the motion sensor interrupt while sampling the other
# sensors.
PFLAGS += -DPAUSE_MOTION

#PFLAGS += -DBINARY_SHELL
#PFLAGS += -DBLIP_REMOVE_PING
#PFLAGS += -DBLIP_MINI_SHELL

# Enable the watchdog timer and use a timer to pet it every second
#PFLAGS += -DUSE_WATCHDOG

#PFLAGS += -DUSE_LOGGING

GOALS += blip rpl

TINYOS_ROOT_DIR?=../..
include $(TINYOS_ROOT_DIR)/Makefile.include
