export 'src/Unsupported.dart'
    if (dart.library.html) 'src/web/Web.dart'
    if (dart.library.io) 'src/native/Native.dart';

typedef BiiiSerialRxHandler = void Function(List<int> bytes);
typedef BiiiSerialDiconnecthandler = void Function();

abstract class BiiiSerialPort {
  final String name;
  int _baud = 9600;

  BiiiSerialPort(this.name);

  set baud(b) => _baud = b;

  get baud => _baud;

  @override
  String toString() {
    return '{$name,$_baud}';
  }

  ///
  Future<bool> connect(
      BiiiSerialRxHandler onReceive, BiiiSerialDiconnecthandler onNotify,
      {int readFreqMillis});

  ///
  bool transmit(List<int> bytes);

  ///
  bool disconnect();
}

class BiiiSerialPortFilter {
  final int vendorId;

  BiiiSerialPortFilter({this.vendorId});
}

enum BiiiSerialDiconnecthandlerType {
  StateChange,
}

enum BiiiSerialResponseCode {
  Success,
  PermissionDenied,
  NotSupported,
  UnknownError,
}
