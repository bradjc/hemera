
configuration RohmBH17TesterC {
}
implementation {

  components MainC, RohmBH17TesterP;
  RohmBH17TesterP -> MainC.Boot;

  components LedsC as Led;
  RohmBH17TesterP.Leds -> Led;

  components new TimerMilliC() as Timer0;
  RohmBH17TesterP.Timer0 -> Timer0;

  components new RohmBH17C() as LightSen;
  RohmBH17TesterP.LightSensor -> LightSen.Light;

}
