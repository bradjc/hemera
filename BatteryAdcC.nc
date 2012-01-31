
configuration BatteryAdcC {
  provides interface Read<uint16_t> as ReadSen;
}
implementation {
  components new Msp430Adc12ClientC() as Adc;
  components BatteryAdcP;
  
  BatteryAdcP.ReadSingleChannel -> Adc.Msp430Adc12SingleChannel;
  BatteryAdcP.AdcResource -> Adc.Resource;

  ReadSen = BatteryAdcP.ReadAdc;

//  Adc.AdcConfigure -> BatteryAdcP.AdcConfigure;

}
