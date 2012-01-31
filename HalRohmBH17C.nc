/**
 * HalRhomBH17C is an advanced access component for the
 * Rohm BH17xx model light sensor. This component provides
 * the RohmBH17 interface, which offers currently limited
 * control over the device. Please acquire the Resource
 * before using it.
 *
 * @author Brad Campbell <bradjc@umich.edu>
 * @version $Revision: 1.0 $ $Date: 2011/01/28 11:31:12 $
 */

configuration HalRohmBH17C {
	provides interface RohmBH17;
}
implementation {
	components RohmBH17LogicP;
	components new Msp430I2CC();
	components new TimerMilliC() as TimerWait;
	components MainC;
	
	RohmBH17 = RohmBH17LogicP;
	RohmBH17LogicP.TimerWait	-> TimerWait;		// timer for waiting for the light measurement to finish
	RohmBH17LogicP.I2CPacket	-> Msp430I2CC.I2CBasicAddr;
	RohmBH17LogicP.I2CResource	-> Msp430I2CC.Resource;
	
}
