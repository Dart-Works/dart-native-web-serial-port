import 'dart:async';

import 'package:biiiSerial/BiiiSerial.dart';
import 'NativeFFI.dart';

class BiiiSerial {
  ///
  static Future<BiiiSerialResponseCode> scanForPort(
    List<BiiiSerialPort> result, {
    List<BiiiSerialPortFilter> filters,
  }) async {
    result.clear();
    ffiNativeSerialStartScan(result);
    return BiiiSerialResponseCode.Success;
  }
}

class BiiiSerialPortNative extends BiiiSerialPort {
  int tty_id;
  BiiiSerialPortNative(name) : super(name);

  ///
  Future<bool> connect(
      BiiiSerialRxHandler onReceive, BiiiSerialDiconnecthandler onNotify,
      {int readFreqMillis}) async {
    tty_id = ffiNativeSerialConnect(name, baud, 8, 0, 0);
    if (tty_id > 0) {
      Timer.periodic(Duration(milliseconds: readFreqMillis ?? 50), (t) {
        if (tty_id > 0) {
          List<int> data = ffiNativeSerialRead(tty_id);
          if (data != null) {
            if (data.length > 0) {
              onReceive(data);
            }
          } else {
            onNotify();
          }
        } else {
          t.cancel();
        }
      });
    }
    return tty_id > 0;
  }

  ///
  bool transmit(List<int> bytes) {
    return ffiNativeSerialWrite(tty_id, bytes) == bytes.length;
  }

  ///
  bool disconnect() {
    int r = ffiNativeSerialClose(tty_id);
    tty_id = 0;
    return r > 0;
  }
}
