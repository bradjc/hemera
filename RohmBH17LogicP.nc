#include <I2C.h>

/**
 * RohmBH17LogicP contains the actual driver logic needed to
 * read from the Rohm BH17xx digital light sensor. It
 * uses the I2C interface and timer to wait for the measurement to
 * complete.
 * 
 * Currently the driver only supports single measurements in
 * high-resolution mode.
 * 
 *
 * @author Brad Campbell <bradjc@umich.edu>
 * @version $Revision: 1.0 $ $Date: 2011/01/28 11:31:12 $
 */

module RohmBH17LogicP {
	provides interface RohmBH17;
	
	uses interface I2CPacket<TI2CBasicAddr>;
	uses interface Resource as I2CResource;
	
	uses interface Timer<TMilli> as TimerWait;
}
implementation {

	uint16_t BH17_ADDR	= 0x23;
	
	enum {
		OPC_POWER_DOWN			= 0,
		OPC_POWER_ON			= 1,
		OPC_CONT_AUTO_RES		= 2,
		OPC_CONT_HIGH_RES		= 3,
		OPC_CONT_LOW_RES		= 4,
		OPC_CHNG_MEAS_TIME_H	= 5,
		OPC_CHNG_MEAS_TIME_L	= 6
	} bh_opcodes_t;
	
	static uint8_t opcodes[7] = {0x00, 0x01, 0x10, 0x12, 0x13, 0x40, 0x60};
/*	opcodes[OPC_POWER_DOWN]			= 0x00;
	opcodes[OPC_POWER_ON]			= 0x01;
	opcodes[OPC_CONT_AUTO_RES]		= 0x10;
	opcodes[OPC_CONT_HIGH_RES]		= 0x12;
	opcodes[OPC_CONT_LOW_RES]		= 0x13;
	opcodes[OPC_CHNG_MEAS_TIME_H]	= 0x40;
	opcodes[OPC_CHNG_MEAS_TIME_L]	= 0x60;
*/
	
/*	opcodes[OPC_POWER_ON]			= 0x01;
	opcodes[OPC_CONT_AUTO_RES]		= 0x10;
	opcodes[OPC_CONT_HIGH_RES]		= 0x12;
	opcodes[OPC_CONT_LOW_RES]		= 0x13;
	opcodes[OPC_CHNG_MEAS_TIME_H]	= 0x40;
	opcodes[OPC_CHNG_MEAS_TIME_L]	= 0x60;*/

	static uint8_t read_buffer[4];
	uint16_t light_value;

	typedef enum {
		POWER_ON		= 0,
		POWER_DOWN		= 1,
		READ_SEND1		= 2,
		READ_SEND2		= 3,
		READ_SEND3		= 4,
		READ_RECEIVE	= 5,
		READ_PROCESS	= 6,
		DONE			= 7
	} bh_state_t;
	bh_state_t state;
  
	task void perform_action();


	command error_t RohmBH17.measureLight () {
		state = READ_SEND1;
		
		return call I2CResource.request();
	}
	
	event void I2CResource.granted () { 
		post perform_action();
	}
	
	async event void I2CPacket.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data) {
		post perform_action();
	}
	
	async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data) {
		post perform_action();
	}
	
	task void perform_action () {
		error_t error = SUCCESS;
		
		switch (state) {
			
			case READ_SEND1:	// turn the BH17 on
				state = READ_SEND2;

				error = call I2CPacket.write((I2C_START | I2C_STOP), BH17_ADDR, 1, &opcodes[OPC_POWER_ON]);
				break;
				
			case READ_SEND2:	// issue a light sen read
				state = READ_SEND3;
				error = call I2CPacket.write((I2C_START | I2C_STOP), BH17_ADDR, 1, &opcodes[OPC_CONT_HIGH_RES]);
				break;
			
			case READ_SEND3:	// wait for the required time for the read to complete
				state = READ_RECEIVE;
				call TimerWait.startOneShot(180);
				break;
			
			case READ_RECEIVE:	// read the light value
				state = READ_PROCESS;
				error = call I2CPacket.read((I2C_START | I2C_STOP), BH17_ADDR, 1, &read_buffer[0]);
				break;
			
			case READ_PROCESS:	// convert the light value and power down
				state = DONE;
				light_value = ((read_buffer[0] << 8) | read_buffer[1]) / 1.2;
				error = call I2CPacket.write((I2C_START | I2C_STOP), BH17_ADDR, 1, &opcodes[OPC_POWER_DOWN]);
				break;
				
	//		case POWER_DOWN:
	//			atomic { state = DONE; }
	//			error = call I2CPacket.write((I2C_START | I2C_STOP), BH17_ADDR, 1, &opcodes[OPC_POWER_DOWN]);
	//			break;
			
			case DONE:
				call I2CResource.release();
				signal RohmBH17.measureLightDone(SUCCESS, light_value);
				break;
				
			default: break;
		}
			
	}
	
	event void TimerWait.fired () {
		post perform_action();
	}
	
	default event void RohmBH17.measureLightDone (error_t result, uint16_t val) { }
}
