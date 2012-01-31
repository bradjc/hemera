/**
 * RohmBH17 is the rich interface to the Rohm BH17xx
 * digital light sensor. 
 *
 * @author Brad Campbell <bradjc@umich.edu>
 * @version $Revision: 1.0 $ $Date: 2011/01/28 11:31:12 $
 */

interface RohmBH17 {

  /**
   * Starts a light measurement.
   *
   * @return SUCCESS if the measurement will be made
   */
  command error_t measureLight ();

  /**
   * Presents the result of a light measurement.
   *
   * @param result SUCCESS if the measurement was successful
   * @param val the light reading in lux
   */
  event void measureLightDone (error_t result, uint16_t val);

}
