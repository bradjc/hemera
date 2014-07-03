#ifndef HEMERA_H
#define HEMERA_H

#ifndef NODE_ID
#define NODE_ID 0
#endif

// Packet Struct
typedef nx_struct packet_t {
  nx_uint8_t  profile[10];
  nx_uint16_t sequence;
  nx_uint16_t temperature;
  nx_uint16_t humidity;
  nx_uint16_t light;
  nx_uint8_t  motion;
  nx_uint8_t  id;
  //nx_uint16_t battery;
} __attribute__((packed)) packet_t;

#endif
