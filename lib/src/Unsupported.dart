import 'package:biiiSerial/BiiiSerial.dart';

class BiiiSerial {
  ///
  static Future<BiiiSerialResponseCode> scanForPort(
    List<BiiiSerialPort> result, {
    List<BiiiSerialPortFilter> filters,
  }) async {
    throw UnimplementedError();
  }

  ///
  static bool connect(
    BiiiSerialRxHandler onReceive,
    BiiiSerialDiconnecthandler onNotify,
  ) {
    throw UnimplementedError();
  }

  ///
  static bool transmit(List<int> bytes) {
    throw UnimplementedError();
  }

  ///
  static bool disconnect() {
    throw UnimplementedError();
  }
}
