@JS()
library biii_in_webserial;

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:biiiUtils/BiiiUtil.dart';
import 'package:biiiSerial/BiiiSerial.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS()
class Promise {
  external Promise then(Function successCallback, [Function errorCallback]);
  external Promise catchIt(Function errorCallback);
}

@JS('bgWsRequestDevice')
external Promise _scanPorts(_WebSerialFilter filter);

@JS('bgWsConnectDevice')
external Promise _connectPort(
    _WebSerialOptions options, Function onReceive, Function onDisconnect);

@JS('bgWsDisconnectDevice')
external bool _disconnectPort();

@JS('biii_serial_isSupprted')
external bool _isSupported();

@JS()
external bool bgWsHasDevice();

@JS('bgWsTxBytes')
external bool _sendBytes(Uint8List list);

@JS()
@anonymous
class _WebSerialDevFilter {
  external int get usbVendorId;
  external factory _WebSerialDevFilter({usbVendorId});
}

@JS()
@anonymous
class _WebSerialFilter {
  external List<_WebSerialDevFilter> get filters;
  external factory _WebSerialFilter({filters});
}

@JS()
@anonymous
class _WebSerialOptions {
  external int get baudrate;
  external int get databits;
  external int get stopbits;
  // ParityType parity = "none";
  external int get buffersize;
  external bool get rtscts;
  external bool get xon;
  external bool get xoff;
  external bool get xany;

  external factory _WebSerialOptions(
      {baudrate, databits, stopbits, buffersize, rtscts, xon, xoff, xany});
}

class BiiiSerial {
  static final BiiiSerialPort _serial = BiiiSerialPortWeb('WebCommPort');

  static Future<BiiiSerialResponseCode> scanForPort(
    List<BiiiSerialPort> result, {
    List<BiiiSerialPortFilter> filters,
  }) async {
    /// translate to web based filters
    List<_WebSerialDevFilter> webFilters = [];
    if (filters != null) {
      filters.forEach((f) {
        if (f.vendorId != null) {
          webFilters.add(_WebSerialDevFilter(usbVendorId: f.vendorId));
        }
      });
    }

    /// start port request
    try {
      return promiseToFuture<BiiiSerialResponseCode>(
        _scanPorts(_WebSerialFilter(filters: webFilters)).then(
          allowInterop(
            (code) {
              if (code == 0) {
                result.add(_serial);
              }
              return code == 0
                  ? BiiiSerialResponseCode.Success
                  : code == 1
                      ? BiiiSerialResponseCode.PermissionDenied
                      : code == 2
                          ? BiiiSerialResponseCode.NotSupported
                          : BiiiSerialResponseCode.UnknownError;
            },
          ),
          allowInterop(
            (err) {
              Log.d('BiiiSerial', 'err $err');
              return BiiiSerialResponseCode.UnknownError;
            },
          ),
        ),
      );
    } on NoSuchMethodError {
      Log.d('BiiiSerial', '''
include biii_in_webbserial.js in web/index.html
paste following inside body
    <script src="biii_in_webserial.js" type="application/javascript"></script>
''');
    } catch (e) {
      Log.d(BiiiSerial, 'err $e');
    }
    return BiiiSerialResponseCode.UnknownError;
  }
}

class BiiiSerialPortWeb extends BiiiSerialPort {
  BiiiSerialPortWeb(name) : super(name);

  ///
  Future<bool> connect(
      BiiiSerialRxHandler onReceive, BiiiSerialDiconnecthandler onDisconnect,
      {int readFreqMillis}) {
    return promiseToFuture<bool>(
      _connectPort(
        _WebSerialOptions(baudrate: baud),
        allowInterop(
          (bytes) => onReceive(bytes),
        ),
        allowInterop(
          () => onDisconnect(),
        ),
      ),
    );
  }

  ///
  bool transmit(List<int> bytes) {
    return _sendBytes(Uint8List.fromList(bytes));
  }

  ///
  bool disconnect() {
    return _disconnectPort();
  }
}
