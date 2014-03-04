/**
 * Very Simple LPL scheme where the radio is always off unless it is trying
 * to transmit.
 *
 * @author Brad Campbell <bradjc@umich.edu>
 */


module DefaultLplP {
  provides {
    interface Init;
    interface LowPowerListening;
    interface Send;
    interface SplitControl;
  }

  uses {
    interface Send as SubSend;
    interface SplitControl as SubControl;
  }
}

implementation {

  /** The message currently being sent */
  norace message_t *currentSendMsg;

  /** The length of the current send message */
  uint8_t currentSendLen;


  /***************** Prototypes ***************/
  task void send();
  task void startRadio();
  task void stopRadio();
  task void signalStartDone();
  task void signalStopDone();

  /***************** Init Commands ***************/
  command error_t Init.init() {
    // Immediately turn off the radio
    return call SubControl.stop();
  }

  /***************** LowPowerListening Commands ***************/
  command void LowPowerListening.setLocalWakeupInterval(uint16_t intervalMs) {
  }

  command uint16_t LowPowerListening.getLocalWakeupInterval() {
    return 0;
  }

  command void LowPowerListening.setRemoteWakeupInterval(message_t *msg,
      uint16_t intervalMs) {
  }

  command uint16_t LowPowerListening.getRemoteWakeupInterval(message_t *msg) {
    return 0;
  }

  /***************** SplitControl Commands ***********************/
  command error_t SplitControl.start() {
    post signalStartDone();
    return SUCCESS;
  }

  command error_t SplitControl.stop() {
    post signalStopDone();
    return SUCCESS;
  }

  /***************** Send Commands ***************/
  command error_t Send.send(message_t *msg, uint8_t len) {
    if (currentSendMsg != NULL) {
      return EBUSY;
    }

    currentSendMsg = msg;
    currentSendLen = len;

    post startRadio();

    return SUCCESS;
  }

  command error_t Send.cancel(message_t *msg) {
    if (currentSendMsg == msg) {
      return call SubSend.cancel(msg);
    }

    return FAIL;
  }

  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }

  /***************** SubControl Events ***************/
  event void SubControl.startDone(error_t error) {
    if (!error) {
      post send();
    }
  }

  event void SubControl.stopDone(error_t error) {
  }

  /***************** SubSend Events ***************/
  event void SubSend.sendDone(message_t* msg, error_t error) {
    currentSendMsg = NULL;
    post stopRadio();
    signal Send.sendDone(msg, error);
  }

  /***************** Tasks ***************/
  task void send() {
    if (currentSendMsg == NULL) return;
    if (call SubSend.send(currentSendMsg, currentSendLen) != SUCCESS) {
      post send();
    }
  }

  task void startRadio() {
    if (call SubControl.start() != SUCCESS) {
      post startRadio();
    }
  }

  task void stopRadio() {
    if (call SubControl.stop() != SUCCESS) {
      post stopRadio();
    }
  }

  task void signalStartDone() {
    signal SplitControl.startDone(SUCCESS);
  }

  task void signalStopDone() {
    signal SplitControl.stopDone(SUCCESS);
  }

}

