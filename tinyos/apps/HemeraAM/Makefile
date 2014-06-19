COMPONENT=HemeraAMC

### For Over-The-Air Programming (still being tested)
# BOOTLOADER=tosboot

### GATD Profile ID for Hemera
PFLAGS += -DPROFILE_ID=\"TtYWhXKRke\"

###########################################################
########################## RADIO ##########################
###########################################################

PFLAGS += -DCC2420_DEF_CHANNEL=15
PFLAGS += -DCC2520_DEF_CHANNEL=15
PFLAGS += -DAM_TYPE=31


###########################################################
###################### SAMPLE PERIOD ######################
###########################################################

PFLAGS += -DSAMPLE_PERIOD=3000


###########################################################
########################### LPL ###########################
###########################################################

PFLAGS += -DLOW_POWER_LISTENING
PFLAGS += -DLPL_SLEEP_INTERVAL=512
PFLAGS += -DLPL_DEF_LOCAL_WAKEUP=512
PFLAGS += -DLPL_DEF_REMOTE_WAKEUP=512


###########################################################
######################### INCLUDE #########################
###########################################################

TINYOS_ROOT_DIR?=../..
include $(TINYOS_ROOT_DIR)/Makefile.include
