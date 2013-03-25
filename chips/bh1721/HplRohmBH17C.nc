/**
 * HalRhomBH17C is an advanced access component for the
 * Rohm BH17xx model light sensor. This component provides
 * the RohmBH17 interface, which offers currently limited
 * control over the device. Please acquire the Resource
 * before using it.
 *
 * @author Brad Campbell <bradjc@umich.edu>
 * @version 1.5
 */

configuration HplRohmBH17C {
  provides {
    interface GeneralIO as LightReset;

    interface I2CPacket<TI2CBasicAddr>;
    interface Resource as I2CResource;
  }
}
implementation {
  components new Msp430I2CC();
  components HplMsp430GeneralIOC as Hpl;
  components new Msp430GpioC() as MspGpio;

  MspGpio.HplGeneralIO -> Hpl.Port57;
  LightReset = MspGpio.GeneralIO;

  I2CPacket = Msp430I2CC.I2CBasicAddr;
  I2CResource = Msp430I2CC.Resource;
}
