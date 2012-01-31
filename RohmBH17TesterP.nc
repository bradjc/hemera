
module RohmBH17TesterP {
  uses {
    interface Timer<TMilli> as Timer0;
    interface Leds;
    interface Boot;
    interface Read<uint16_t> as LightSensor;
  }
}

implementation {

  event void Boot.booted () {
    call Timer0.startPeriodic(3000);
  }

  event void Timer0.fired() {
    call Leds.led1Toggle();
    call LightSensor.read();
  }
  
  event void LightSensor.readDone (error_t e, uint16_t data) {
    if (e != SUCCESS) {
      call Leds.led0Toggle();
    } else {
      call Leds.led2Toggle();
    }
  }

}
