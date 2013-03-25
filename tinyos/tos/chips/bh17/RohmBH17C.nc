/**
 * RohmBH17C is a top-level access component for the Rohm
 * BH17xx model light sensor.
 *
 * @author Brad Campbell <bradjc@umich.edu>
 * @version 1.5
 */

configuration RohmBH17C {
  provides {
  	interface Read<uint16_t> as ReadLux;
  }
}
implementation {
  components RohmBH17P;
  ReadLux = RohmBH17P.ReadLux;

  components HplRohmBH17C;
  RohmBH17P.I2CPacket -> HplRohmBH17C.I2CPacket;
  RohmBH17P.I2CResource -> HplRohmBH17C.I2CResource;
  RohmBH17P.LightReset -> HplRohmBH17C.LightReset;

  components new TimerMilliC() as TimerWait;
  RohmBH17P.TimerWait -> TimerWait;
}
