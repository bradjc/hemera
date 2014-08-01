#include "Hemera.h"
#include <Timer.h>
#include <UserButton.h>

module HemeraAMP {
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
    interface Packet;
    interface AMSend;
  }
}

implementation {

  message_t pkt;
  uint16_t  sequence;
  uint16_t  temperature;
  uint16_t  humidity;
  uint16_t  light;
  uint16_t  battery;
  uint8_t   motion;
  uint8_t   profile[10];
  bool      userbutton;

  void sendData () {
    error_t err;

    // Set up packet
    packet_t* data = (packet_t*) (call Packet.getPayload(&pkt, sizeof(packet_t)));
    atomic {
      strncpy(data->profile, PROFILE_ID,10);
      data -> sequence    = sequence++;
      data -> temperature = temperature;
      data -> humidity    = humidity;
      data -> light       = light;
      data -> motion      = motion;
      data -> id          = NODE_ID;
      //data -> battery     = battery;
    }

    // Broadcast
    err = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(nx_struct packet_t));

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
    atomic battery = (e == SUCCESS) ? data : -1;
    sendData();
  }

  event void RadioControl.stopDone (error_t e) { }

  event void AMSend.sendDone(message_t* msg, error_t e) { }
  
}
