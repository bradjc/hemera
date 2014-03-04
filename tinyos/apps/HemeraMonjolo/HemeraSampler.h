#ifndef HEMERA_SAMPLER_H
#define HEMERA_SAMPLER_H

// general number constants
#define ONE_MINUTE 60000	// 1 minute in milliseconds
#define TEN_MINUTES 600000	// 10 minutes in milliseconds

// message struct
typedef nx_struct udp_thlm_t {
  nx_uint16_t seqno;
  nx_uint16_t temperature;
  nx_uint16_t humidity;
  nx_uint16_t light;
  nx_uint8_t  motion;			// whether or not there was motion in the last sample interval
  nx_uint16_t battery;
} udp_thl_t;

#endif
