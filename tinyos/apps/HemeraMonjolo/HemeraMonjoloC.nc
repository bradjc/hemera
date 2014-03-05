#ifdef DELUGE_LITE
#include "StorageVolumes.h"
#endif


configuration HemeraMonjoloC { }

implementation {

  // Core, basic functionality
  components MainC;
  components HemeraMonjoloP;
#ifdef USE_LEDS
  components LedsC as Led;
#else
  components NoLedsC as Led;
#endif
  HemeraMonjoloP -> MainC.Boot;
  HemeraMonjoloP.Leds -> Led;

  // General Timer
  components new TimerMilliC() as TimerTHL;	// Temperature, Humidity, and
                                            // Light sensor timer
  HemeraMonjoloP.TimerTHL -> TimerTHL;

#ifdef USE_LOGGING
  // Storage
	components new LogStorageC(VOLUME_DATA, TRUE);
	HemeraMonjoloP.LogRead	-> LogStorageC;
	HemeraMonjoloP.LogWrite	-> LogStorageC;

  // Serial
	components PlatformSerialC;
	HemeraMonjoloP.UartStream		-> PlatformSerialC;
	HemeraMonjoloP.UartControl	-> PlatformSerialC;
#endif

  // Motion
  components HplMsp430InterruptC as Interrupt;
  components HplMsp430GeneralIOC as GpIO;
  HemeraMonjoloP.MotionSensorGpIO	-> GpIO.IO_PIR;
  HemeraMonjoloP.MotionSensor -> Interrupt.IO_PIR;

  // Temperature/Humidity
  components new SensirionSht11C() as SensirionSen;
  HemeraMonjoloP.Temp -> SensirionSen.Temperature;
  HemeraMonjoloP.Hum  -> SensirionSen.Humidity;

  // Light
  components RohmBH17C as LightSen;
  HemeraMonjoloP.LightSensor -> LightSen.ReadLux;

  // Battery ADC
  components BatteryAdcC as BatterySen;
  HemeraMonjoloP.BatSensor -> BatterySen.ReadSen;

  // Watchdog
#ifdef USE_WATCHDOG
  components new TimerMilliC() as TimerWatchdog;
  HemeraMonjoloP.TimerWatchdog -> TimerWatchdog;
#endif

  // Radio
  components IPStackC;
  components new UdpSocketC() as UDPService;
  HemeraMonjoloP.RadioControl -> IPStackC;
  HemeraMonjoloP.UDPService   -> UDPService;
  HemeraMonjoloP.ForwardingTable -> IPStackC.ForwardingTable;

  components StaticIPAddressC;

#if RPL_ROUTING
  components RPLRoutingC;
#endif

  // Deluge and NWProg support
#ifdef DELUGE_LITE
  components UDPShellC;
#endif


}
