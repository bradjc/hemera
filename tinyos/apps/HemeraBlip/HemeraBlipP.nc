#include "Hemera.h"
#include "Ieee154.h"
#include <Timer.h>
#include <UserButton.h>
#include <lib6lowpan/lib6lowpan.h>
#include <lib6lowpan/ip.h>

module HemeraBlipP {
  uses {
    interface Boot;
    interface Leds;
    interface Notify<button_state_t>;    
    interface Timer<TMilli>      as Timer;

    interface HplMsp430GeneralIO as MotionSensorGpIO;
    interface HplMsp430Interrupt as MotionSensor;
    interface Read<uint16_t>     as TemperatureSensor;
    interface Read<uint16_t>     as HumiditySensor;
    interface Read<uint16_t>     as LightSensor;
    interface Read<uint16_t>     as BatterySensor;

    interface SplitControl       as RadioControl;
    interface ForwardingTable;
    interface Packet;
    interface UDP;
  }
}

implementation {

  uint16_t  sequence;
  uint16_t  temperature;
  uint16_t  humidity;
  uint16_t  light;
  uint16_t  battery;
  uint8_t   motion;
  bool      userbutton;

  struct sockaddr_in6 dest; // Where to send the packet
  struct in6_addr next_hop; // for default route setup

  packet_t pkt;

  void sendData () {
    error_t err;

    // Set up packet
    atomic {
      strncpy(pkt.profile, PROFILE_ID,10);
      pkt.sequence    = sequence++;
      pkt.temperature = temperature;
      pkt.humidity    = humidity;
      pkt.light       = light;
      pkt.motion      = motion;
      pkt.id          = NODE_ID;
      //pkt.battery     = battery;
    }

    // Broadcast
    err = call UDP.sendto(&dest, &pkt, sizeof(nx_struct packet_t));

    // Display broadcast status on LEDs if user button is pressed
    if (userbutton) {
      if (err == SUCCESS) call Leds.led2Toggle();
      else call Leds.led0Toggle();
    }

    // Re-enable motion sensor
    call MotionSensor.clear();
    call MotionSensor.enable();
    atomic motion = 0;
  }

  event void Boot.booted () {
    // Initialize interrupt for motion sensor
    call MotionSensorGpIO.selectIOFunc();
    call MotionSensorGpIO.makeInput();
    call MotionSensor.edge(TRUE);
    call MotionSensor.enable();
    atomic motion = 0;

    // Initialize user button
    call Notify.enable();
    atomic userbutton = 0;

    // Turn on second voltage regulator
    TOSH_SET_VOLTAGE_REG_PIN();

    // Initialize sequence number
    atomic sequence = 0;

    // Start up radio
    // Get binary version of the ip address to send the packets to
    inet_pton6(ADDR_ALL_ROUTERS, &dest.sin6_addr);
    // dest.sin6_port = htons(RECEIVER_PORT);

    // Setup a default broadcast route for that destination
    // inet_pton6(ADDR_ALL_ROUTERS, &next_hop);
    // call ForwardingTable.addRoute(dest.sin6_addr.s6_addr, 128, &next_hop, ROUTE_IFACE_154);

    call RadioControl.start();
  }

  event void RadioControl.startDone (error_t e) {
    if (e == SUCCESS) call Timer.startPeriodic(SAMPLE_PERIOD);
    else call RadioControl.start();
  }

  event void Notify.notify(button_state_t state) {
    userbutton = (state == BUTTON_PRESSED);
    if (state == BUTTON_PRESSED ) call Leds.led1On();
    if (state == BUTTON_RELEASED) call Leds.set(0);
  }

  event void Timer.fired () {
    call MotionSensor.disable();
    call TemperatureSensor.read();
  }

  async event void MotionSensor.fired () {
    call MotionSensor.disable();
    atomic motion = 1;
  }

  event void TemperatureSensor.readDone (error_t e, uint16_t data) {
    atomic temperature = (e == SUCCESS) ? data : -1;
    call HumiditySensor.read();
  }

  event void HumiditySensor.readDone (error_t e, uint16_t data) {
    atomic humidity = (e == SUCCESS) ? data : -1;
    call LightSensor.read();
  }

  event void LightSensor.readDone (error_t e, uint16_t data) {
    atomic light = (e == SUCCESS) ? data : -1;
    sendData(); // call BatterySensor.read();
  }

  event void BatterySensor.readDone (error_t e, uint16_t data) {
    // atomic battery = (e == SUCCESS) ? data : -1;
    // sendData();
  }

  event void UDP.recvfrom (struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) { }

  event void RadioControl.stopDone (error_t e) { }

  // event void AMSend.sendDone(message_t* msg, error_t e) { }
  
}
