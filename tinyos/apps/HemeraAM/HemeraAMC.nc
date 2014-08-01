configuration HemeraAMC { }

implementation {

  // Usual Stuff
  components MainC;
  components HemeraAMP as App;
  components LedsC;
  components UserButtonC;
  App        -> MainC.Boot;
  App.Leds   -> LedsC;
  App.Notify -> UserButtonC;

  // Timer
  components new TimerMilliC();
  App.Timer -> TimerMilliC;

  // Motion
  components HplMsp430GeneralIOC;
  components HplMsp430InterruptC;
  App.MotionSensorGpIO -> HplMsp430GeneralIOC.IO_PIR;
  App.MotionSensor     -> HplMsp430InterruptC.IO_PIR;

  // Temperature/Humidity
  components new SensirionSht11C();
  App.TemperatureSensor -> SensirionSht11C.Temperature;
  App.HumiditySensor    -> SensirionSht11C.Humidity;

  // Light
  components RohmBH17C;
  App.LightSensor -> RohmBH17C.ReadLux;

  // Battery
  components BatteryAdcC;
  App.BatterySensor -> BatteryAdcC.ReadSen;

  // Radio
  components ActiveMessageC;
  components new AMSenderC(AM_TYPE);
  App.Packet       -> AMSenderC;
  App.AMSend       -> AMSenderC;
  App.RadioControl -> ActiveMessageC;

}
