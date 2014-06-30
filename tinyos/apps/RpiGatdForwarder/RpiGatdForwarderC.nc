configuration RpiGatdForwarderC {}

implementation {
  components MainC, LedsC, SerialStartC, PrintfC, RpiGatdForwarderP as App;
  App.Boot -> MainC.Boot;
  App.Leds -> LedsC;

  components Ieee154BareC;
  App.RadioControl -> Ieee154BareC.SplitControl;
  App.Receive      -> Ieee154BareC.BareReceive;
  App.Send         -> Ieee154BareC.BareSend;

#ifdef USE_TCP
  components new PersistentTcpConnectionC();
  App.TCPSocket -> PersistentTcpConnectionC.TcpSocket;
#else
  components new LinuxUdpSocketC();
  App.UDPSocket -> LinuxUdpSocketC.LinuxUdpSocket;
#endif

}
