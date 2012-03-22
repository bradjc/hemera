#include "HemeraSampler.h"
#include <Timer.h>
#include <IPDispatch.h>
#include <lib6lowpan/lib6lowpan.h>
#include <lib6lowpan/ip.h>

module HemeraSamplerP {
  uses {
    interface Timer<TMilli> as TimerTHL;
#ifdef USE_WATCHDOG
    interface Timer<TMilli> as TimerWatchdog;
#endif

    interface Leds;
    interface Boot;

#ifdef USE_LOGGING
    interface LogRead;
    interface LogWrite;
    interface UartStream;
    interface StdControl as UartControl;
#endif

    interface HplMsp430GeneralIO as MotionSensorGpIO;
    interface HplMsp430Interrupt as MotionSensor;

    interface SplitControl as RadioControl;
    interface UDP as UDPService;

    interface Read<uint16_t> as Temp;
    interface Read<uint16_t> as Hum;
    interface Read<uint16_t> as LightSensor;

    interface Read<uint16_t> as BatSensor;
  }
}

implementation {

  nx_struct udp_thlm_t  payload_thl;      // Packet struct to send to receiver
  uint8_t               current_motion;   // Global variable where 1 =motion sensor is high, 0=motion sensor is low
  uint16_t              temperature;      // Global variables for sensor data
  uint16_t              humidity;
  uint16_t              light;
  uint16_t              battery;
  uint8_t               thlsensor_reads;  // Number of sensors that have been read
  uint8_t               sample_count;
  struct sockaddr_in6   dest;             // Where to send the packet

#ifdef USE_LOGGING
  uint8_t  serial_buf[65];
#endif

  task void sendTHLData_task ();
  void      sendTHLData (uint8_t);
  void      THLRead ();
  void      check_all_sensors_done ();

  event void Boot.booted () {
    atomic {
      current_motion = 0;

      call MotionSensorGpIO.selectIOFunc(); // Initialize interrupt for motion sensor
      call MotionSensorGpIO.makeInput();
      call MotionSensor.edge(TRUE);
      call MotionSensor.enable();

      // Turn on second voltage regulator
      TOSH_SET_VOLTAGE_REG_PIN();

      inet_pton6(RECEIVER_ADDR, &dest.sin6_addr);
      dest.sin6_port    = htons(RECEIVER_PORT);
      payload_thl.seqno = 0;
      sample_count      = 0;

      call Leds.led2On();

#ifdef USE_WATCHDOG
      WDTCTL = WDT_ARST_1000;
      call TimerWatchdog.startPeriodic(980);
#endif

#ifdef USE_LOGGING
      call UartControl.start();
#endif

      call RadioControl.start();
    }
  }


  /** Functions **/

  void sendTHLData (uint8_t _motion) {
    error_t err;

    uint8_t size;
    atomic {
      payload_thl.seqno++;
      payload_thl.temperature = temperature;
      payload_thl.humidity    = humidity;
      payload_thl.light       = light;
      payload_thl.motion      = _motion;
      payload_thl.battery     = battery;
    }

    // reset the sample count
    if (sample_count >= 6) {
      sample_count = 0;
      size = sizeof(nx_struct udp_thlm_t);
    } else {
      size = sizeof(nx_struct udp_thlm_t) - sizeof(nx_uint16_t);
    }

#ifdef USE_LOGGING
    // log
    call LogWrite.append(&payload_thl, size);
#endif

    // send on radio
    err = call UDPService.sendto(&dest, &payload_thl, size);

    if (err == SUCCESS) call Leds.led1Toggle();
    else call Leds.led0Toggle();
  }

  void THLRead () {
    call Temp.read();
    call Hum.read();
    call LightSensor.read();

    if (sample_count == 6) {
      call BatSensor.read();
    } else {
      sample_count++;
    }
  //    call BatSensor.read();
  //  post sendTHLData_task();
  }

  // called by the sensor_readDone()s to check whether or not they all finished and it"s
  // time to send the packet
  void check_all_sensors_done () {
    atomic {
      thlsensor_reads = thlsensor_reads + 1;
      if ((sample_count >= 6 && thlsensor_reads >= 4) ||
         (sample_count < 6   && thlsensor_reads >=3)) {
        post sendTHLData_task();
      }
    }
  }

  /** Misc Events **/

  event void RadioControl.startDone (error_t e) {
    if (e == SUCCESS) {
#ifdef USE_LOGGING
      call UartStream.enableReceiveInterrupt();
#endif
      call TimerTHL.startPeriodic(THL_SAMPLE_PERIOD);
    } else {
      call RadioControl.start();
    }
  }

  /** Tasks **/

  task void sendTHLData_task () {
    // clear and re enable the motion interrupt if it was triggered
    call MotionSensor.clear();
    call MotionSensor.enable();
    atomic {
      sendTHLData(current_motion);
      current_motion = 0;
    }
  }

  /** Events **/

  // Called when the motion sensor detects motion.
  async event void MotionSensor.fired () {
    // we don't need to handle any more motion interrupts until we do our send event
    call MotionSensor.disable();

    atomic {
      current_motion = 1;
    }
  }

  event void TimerTHL.fired () {
    atomic { thlsensor_reads = 0; }

#if defined(PAUSE_MOTION)
    call MotionSensor.disable();
#endif

    THLRead();
  }

  event void Temp.readDone (error_t e, uint16_t data) {
 //   if (e != SUCCESS) return;

    temperature = data;
    check_all_sensors_done();
  }

  event void Hum.readDone (error_t e, uint16_t data) {
  //  if (e != SUCCESS) return;

    humidity = data;
    check_all_sensors_done();
  }

  event void LightSensor.readDone (error_t e, uint16_t data) {
  //  if (e != SUCCESS) return;

    light = data;
    check_all_sensors_done();
  }

  event void BatSensor.readDone (error_t e, uint16_t data) {
    battery = data;
    check_all_sensors_done();
  }

#ifdef USE_WATCHDOG
  event void TimerWatchdog.fired() {
    // reset watchdog
    call Leds.led2Toggle();
    WDTCTL = WDT_ARST_1000;
  }
#endif


  // Serial Logging
#ifdef USE_LOGGING
  async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t e) {

    if (len >= 5) {
      if (buf[0] == 's' && buf[0] == 't' && buf[0] == 'a' && buf[0] == 'r' && buf[0] == 't') {

        // pause logging
        call TimerTHL.stop();

        // seek to beginning
        call LogRead.seek(SEEK_BEGINNING);
      }
    }
  }

	event void LogRead.seekDone (error_t error) {
		call LogRead.read(serial_buf, 64);
	}

	event void LogRead.readDone (void* buf, storage_len_t len, error_t error) {
		error_t err;

		if (len > 0) {

      call Leds.led0Toggle();
      err = call UartStream.send(buf, len);

		} else {
			call Leds.led0On();

      // restart logging
      call TimerTHL.startPeriodic(THL_SAMPLE_PERIOD);
		}

	}

	async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t error) {
    call LogRead.read(serial_buf, 64);
  }

	event void LogWrite.syncDone (error_t error) { }
  event void LogWrite.eraseDone (error_t error) { }
  event void LogWrite.appendDone (void* buf, storage_len_t len, bool recordsLost, error_t error) { }

	async event void UartStream.receivedByte(uint8_t byte) { }
#endif

  event void UDPService.recvfrom (struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) { }
  event void RadioControl.stopDone (error_t e) { }
}
