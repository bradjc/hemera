#ifdef DELUGE_LITE
#include "StorageVolumes.h"
#endif


configuration HemeraSamplerC { }

implementation {

  // Core, basic functionality
  components MainC;
  components HemeraSamplerP;
#ifdef USE_LEDS
  components LedsC as Led;
#else
  components NoLedsC as Led;
#endif
  HemeraSamplerP -> MainC.Boot;
  HemeraSamplerP.Leds -> Led;

  // General Timer
  components new TimerMilliC() as TimerTHL;	// Temperature, Humidity, and Light sensor timer
  HemeraSamplerP.TimerTHL -> TimerTHL;

#ifdef USE_LOGGING  
  // Storage
	components new LogStorageC(VOLUME_DATA, TRUE);
	HemeraSamplerP.LogRead	-> LogStorageC;
	HemeraSamplerP.LogWrite	-> LogStorageC;
  
  // Serial
	components PlatformSerialC;
	HemeraSamplerP.UartStream		-> PlatformSerialC;
	HemeraSamplerP.UartControl	-> PlatformSerialC;
#endif

  // Motion
  components HplMsp430InterruptC as Interrupt;
  components HplMsp430GeneralIOC as GpIO;
  HemeraSamplerP.MotionSensorGpIO	-> GpIO.IO_PIR;
  HemeraSamplerP.MotionSensor -> Interrupt.IO_PIR;

  // Temperature/Humidity
  components new SensirionSht11C() as SensirionSen;
  HemeraSamplerP.Temp -> SensirionSen.Temperature;
  HemeraSamplerP.Hum  -> SensirionSen.Humidity;

  // Light
  components RohmBH17C as LightSen;
  HemeraSamplerP.LightSensor -> LightSen.Light;

  // Battery ADC
  components BatteryAdcC as BatterySen;
  HemeraSamplerP.BatSensor -> BatterySen.ReadSen;

  // Watchdog
#ifdef USE_WATCHDOG
  components new TimerMilliC() as TimerWatchdog;
  HemeraSamplerP.TimerWatchdog -> TimerWatchdog;
#endif

  // Radio 
  components IPStackC;
  components new UdpSocketC() as UDPService;
  HemeraSamplerP.RadioControl -> IPStackC;
  HemeraSamplerP.UDPService   -> UDPService;

#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif

  // Deluge and NWProg support
#ifdef DELUGE_LITE
  components UDPShellC;
#endif


}
