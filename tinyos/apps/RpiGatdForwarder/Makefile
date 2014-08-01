COMPONENT=RpiGatdForwarderC


###########################################################
###################### GATD SETTINGS ######################
###########################################################

### Protocol by which to send Received Data to GATD
### COMMENT   : Send UDP Packets to GATD
### UNCOMMENT : Send TCP Packets to GATD (untested)
# PFLAGS += -DUSE_TCP

### GATD Server Location/URL
PFLAGS += -DGATD_HOST=\"inductor.eecs.umich.edu\"

### GATD Port for UDP (User Datagram Protocol)
PFLAGS += -DGATD_PORT_UDP=4001

### GATD Port for TCP (Transmission Control Protocol)
PFLAGS += -DGATD_PORT_TCP=4002


###########################################################
########################## RADIO ##########################
###########################################################

### Channel on which to receive (should match Sender's!)
PFLAGS += -DCC2420_DEF_CHANNEL=15
PFLAGS += -DCC2520_DEF_CHANNEL=15

### Active Message
PFLAGS += -DAM_TYPE=31

### Options
CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS
CFLAGS += -DCC2420_NO_ADDRESS_RECOGNITION
CFLAGS += -DCC2420_DEF_RFPOWER=31


###########################################################
########################## PRINT ##########################
###########################################################

PFLAGS += -DNEW_PRINTF_SEMANTICS


###########################################################
######################### INCLUDE #########################
###########################################################

TINYOS_ROOT_DIR?=../..
PFLAGS += -I$(TINYOS_OS_DIR)/lib/net/blip/interfaces
PFLAGS += -I$(TINYOS_ROOT_DIR)/tools/tinyos/c/blip/lib6lowpan
PFLAGS += $(TINYOS_ROOT_DIR)/tools/tinyos/c/blip/lib6lowpan/ieee154_header.c
include $(TINYOS_ROOT_DIR)/Makefile.include
