import 'package:biiiSerial/BiiiSerial.dart';

int main() {
  List<BiiiSerialPort> ports = [];
  BiiiSerial.scanForPort(ports);
  print('$ports');
}
