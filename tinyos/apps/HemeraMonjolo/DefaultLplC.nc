
/**
 * Backwards LPL scheme. The radio is always off. When a packet is ready to be
 * sent the radio turns on and then immediately turns off after transmitting.
 *
 * @author Brad Campbell <bradjc@umich.edu>
 */

#warning "*** RADIO MOSTLY OFF COMMUNICATIONS ENABLED ***"

configuration DefaultLplC {
  provides {
    interface Send;
    interface Receive;
    interface LowPowerListening;
    interface SplitControl;
    interface State as SendState;
  }

  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface SplitControl as SubControl;
  }
}

implementation {
  components MainC;
  components DefaultLplP;
  components new StateC();

  Send = DefaultLplP.Send;
  Receive = SubReceive;
  SplitControl = DefaultLplP.SplitControl;
  LowPowerListening = DefaultLplP.LowPowerListening;
  SendState = StateC.State;

  DefaultLplP.SubSend = SubSend;
  DefaultLplP.SubControl = SubControl;

  DefaultLplP.Init <- MainC.SoftwareInit;
}
