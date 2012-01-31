/**
 * RohmBH17ReaderP transforms the HAL-level RohmBH17
 * interface into a SID Read interface. It acquires the
 * underlying resource before executing each read, enabling
 * arbitrated access.
 *
 * @author Brad Campbell <bradjc@umich.edu>
 * @version $Revision: 1.0 $ $Date: 2011/01/28 11:31:12 $
 */


module RohmBH17ReaderP {
  provides interface Read<uint16_t> as Light;

  uses interface RohmBH17 as BH17LightSen;
}
implementation {

  command error_t Light.read () {
    error_t err;
    TOSH_SET_LIGHT_RST_PIN();
    
    if ((err = call BH17LightSen.measureLight()) != SUCCESS) {
   //   signal Light.readDone(err, 0);
      TOSH_CLR_LIGHT_RST_PIN();
    }

    return err;
  }

  event void BH17LightSen.measureLightDone (error_t result, uint16_t val) {
    signal Light.readDone(result, val);
    TOSH_CLR_LIGHT_RST_PIN();
  }

  default event void Light.readDone (error_t result, uint16_t val) { }
}
