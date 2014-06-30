#include "printf.h"

module RpiGatdForwarderP {
  uses {
    interface Boot;
    interface Leds;
    interface Receive;
    interface Send;
    interface SplitControl   as RadioControl;
#ifdef USE_TCP
    interface TcpSocket      as TCPSocket;
#else
    interface LinuxUdpSocket as UDPSocket;
#endif
  }
}

implementation {
  event void Boot.booted() {
    error_t err;
    call RadioControl.start();
#ifdef USE_TCP
    err = call TCPSocket.connect(GATD_HOST, GATD_PORT_TCP);
#else
    err = call UDPSocket.init   (GATD_HOST, GATD_PORT_UDP);
#endif
    if (err != SUCCESS) fprintf(stderr,"SERVER CONNECTION FAILED!\n");
  }

  event message_t* Receive.receive(message_t *msg, void *payload, uint8_t len) {
    uint8_t *data  = (uint8_t *) msg + sizeof(cc2520packet_header_t);
    uint8_t length = len - sizeof(cc2520packet_header_t);
    int i;
    printf("RECEIVED %.10s", data);
    for (i=10; i<length; i++) printf(" %02X",data[i]);

    // Send a copy of this off to GATD
#ifdef USE_TCP
    if (call TCPSocket.send(data, length)                          != SUCCESS) fprintf(stderr, "TCP send failed\n");
#else
    if (call UDPSocket.build_packet(data, 10)          != SUCCESS) fprintf(stderr, "UDP build_packet failed\n");
    if (call UDPSocket.send_data((uint8_t *) &data[10], length-10) != SUCCESS) fprintf(stderr, "UDP send_data failed\n");
#endif
    else printf(" SENT\n");
    return msg;
  }

  event void RadioControl.startDone(error_t err) { printf("RfStartDone\n"); printfflush();}

  event void RadioControl.stopDone (error_t err) { }

#ifdef USE_TCP
  event void TCPSocket.receive (uint8_t* msg, int len) { }
#endif

  event void Send.sendDone (message_t* msg, error_t err) { }

}
