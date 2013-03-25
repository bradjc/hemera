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
 * @version 1.5
 */

module RohmBH17P {
  provides {
    interface Read<uint16_t> as ReadLux;
  }
  uses {
    interface GeneralIO as LightReset;

    interface I2CPacket<TI2CBasicAddr>;
    interface Resource as I2CResource;

    interface Timer<TMilli> as TimerWait;
  }
}
implementation {

uint8_t BH17_ADDR = 0x23;

  enum {
    OPC_POWER_DOWN       = 0,
    OPC_POWER_ON         = 1,
    OPC_CONT_AUTO_RES    = 2,
    OPC_CONT_HIGH_RES    = 3,
    OPC_CONT_LOW_RES     = 4,
    OPC_CHNG_MEAS_TIME_H = 5,
    OPC_CHNG_MEAS_TIME_L = 6
  } bh_opcodes_t;

  uint8_t opcodes[7] = {0x00, 0x01, 0x10, 0x12, 0x13, 0x40, 0x60};

  uint8_t read_buffer[4];
  uint16_t light_value;

  typedef enum {
    POWER_ON,
    POWER_DOWN,
    READ_SEND1,
    READ_SEND2,
    READ_SEND3,
    READ_RECEIVE,
    READ_PROCESS,
    DONE,
    IDLE,
  } bh_state_t;

  bh_state_t state;

  task void perform_action () {
    error_t error = SUCCESS;

    if (!call I2CResource.isOwner()) {
      call I2CResource.request();
      return;
    }

    switch (state) {

      case READ_SEND1:  // turn the BH17 on
        state = READ_SEND2;

        error = call I2CPacket.write((I2C_START | I2C_STOP),
                                     BH17_ADDR,
                                     1,
                                     &opcodes[OPC_POWER_ON]);
        break;

      case READ_SEND2:  // issue a light sen read
        state = READ_SEND3;

        error = call I2CPacket.write((I2C_START | I2C_STOP),
                                     BH17_ADDR,
                                     1,
                                     &opcodes[OPC_CONT_HIGH_RES]);
        break;

      case READ_SEND3:  // wait for the required time for the read to complete
        state = READ_RECEIVE;
        call TimerWait.startOneShot(180);
        break;

      case READ_RECEIVE:  // read the light value
        state = READ_PROCESS;

        error = call I2CPacket.read((I2C_START | I2C_STOP),
      //  error = call I2CPacket.read((I2C_START),
                                    BH17_ADDR,
                                    1,
                                    read_buffer);
        break;

      case READ_PROCESS:  // convert the light value and power down
        state = DONE;
        //light_value = ((read_buffer[0] << 8) | read_buffer[1]) / 1.2;
        light_value = 5;
        error = call I2CPacket.write((I2C_START | I2C_STOP),
                                     BH17_ADDR,
                                     2,
                                     &opcodes[OPC_POWER_DOWN]);
        break;

  //    case POWER_DOWN:
  //      atomic { state = DONE; }
  //      error = call I2CPacket.write((I2C_START | I2C_STOP),
  //                                   BH17_ADDR, 1, &opcodes[OPC_POWER_DOWN]);
  //      break;

      case DONE:
        state = IDLE;
        call I2CResource.release();
        call LightReset.clr();
        signal ReadLux.readDone(SUCCESS, light_value);
        break;

      case IDLE:
        break;

      default: break;
    }

    if (error != SUCCESS) {
      // Something went wrong. Signal fail and reset things to a normal state.
      state = IDLE;
      call I2CResource.release();
      call LightReset.clr();
      signal ReadLux.readDone(FAIL, 0);
    }

  }


  command error_t ReadLux.read () {
    error_t e;

    state = READ_SEND1;

    call LightReset.makeOutput();
    call LightReset.clr();
    call LightReset.clr();
    call LightReset.clr();
    call LightReset.set();

    e = call I2CResource.request();
    if (e != SUCCESS) {
      call LightReset.clr();
    }

    return e;
  }

  event void I2CResource.granted () {
    post perform_action();
  }

  async event void I2CPacket.writeDone(error_t error,
                                       uint16_t addr,
                                       uint8_t length,
                                       uint8_t* data) {
    post perform_action();
  }

  async event void I2CPacket.readDone(error_t error,
                                      uint16_t addr,
                                      uint8_t length,
                                      uint8_t* data) {
    post perform_action();
  }

  event void TimerWait.fired () {
    post perform_action();
  }

  default event void ReadLux.readDone (error_t result, uint16_t val) { }
}
