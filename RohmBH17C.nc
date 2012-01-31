/**
 * RohmBH17C is a top-level access component for the Rohm
 * BH17xx model light sensor. Because this component represents
 * one physical device, multiple calls will be arbitrated and
 * executed in sequential order.
 *
 * @author Brad Campbell <bradjc@umich.edu>
 * @version $Revision: 1.0 $ $Date: 2011/01/28 11:31:12 $
 */

configuration RohmBH17C {
	provides interface Read<uint16_t> as Light;
}
implementation {
  components RohmBH17ReaderP;
  Light = RohmBH17ReaderP.Light;

  components HalRohmBH17C;
  RohmBH17ReaderP.BH17LightSen	-> HalRohmBH17C.RohmBH17;
	
}
