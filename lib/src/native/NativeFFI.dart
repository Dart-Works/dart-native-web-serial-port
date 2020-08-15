import 'dart:ffi';

import 'dart:io';
import 'dart:cli' as cli;
import 'dart:isolate';

import 'package:biiiSerial/BiiiSerial.dart';
import 'package:biiiSerial/src/native/Native.dart';
import 'package:ffi/ffi.dart';

/// scan response native function proto
typedef _ScanRespCallbackNative = Void Function(
    Pointer<_SerialLibPortDataStruct>);

/// scan response dart function proto
typedef _ScanRespCallbackDart = void Function(
    Pointer<_SerialLibPortDataStruct>);

///  _Serial scan native function proto
typedef _SerialScanRespFunctionNative = Void Function(
    Pointer<NativeFunction<_ScanRespCallbackNative>>);

///  _Serial scan dart function proto
typedef _SerialScanRespFunctionDart = void Function(
    Pointer<NativeFunction<_ScanRespCallbackNative>>);

/// scan response native function proto
typedef ReadRespCallbackNative = Void Function(Pointer<Uint8>, Int32, Int32);

/// scan response dart function proto
typedef ReadRespCallbackDart = void Function(Pointer<Uint8>, int, int);

///  _Serial scan native function proto
typedef _SerialReadRespCallbackNative = Int32 Function(
    Int32, Pointer<NativeFunction<ReadRespCallbackNative>>);

///  _Serial scan dart function proto
typedef _SerialReadRespCallbackDart = int Function(
    int, Pointer<NativeFunction<ReadRespCallbackNative>>);

///  _Serial open native function proto
typedef _SerialOpenFunctionNative = Int32 Function(
    Pointer<Utf8>, Int32, Int32, Int32, Int32);

///  _Serial one dart function proto
typedef _SerialOpenFunctionDart = int Function(
    Pointer<Utf8>, int, int, int, int);

///  _Serial send native function proto
typedef _SerialSendFunctionNative = Int32 Function(
    Int32, Pointer<Uint8>, Int32);

///  _Serial send dart function proto
typedef _SerialSendFunctionDart = int Function(int, Pointer<Uint8>, int);

///  _Serial send native function proto
typedef _SerialCloseFunctionNative = Int32 Function(Int32);

///  _Serial send dart function proto
typedef _SerialCloseFunctionDart = int Function(int);

DynamicLibrary loadLibrary(String name) {
  // resolve name for platform
  if (Platform.isLinux || Platform.isAndroid) {
    name = "lib" + name + ".so";
  } else if (Platform.isMacOS) {
    name = "lib" + name + ".dylib";
  } else if (Platform.isWindows) {
    name = name + ".dll";
  } else {
    throw Exception("Platform not implemented");
  }

  try {
    print('Searching Global $name');
    return DynamicLibrary.open('$name');
  } catch (e) {
    try {
      print('Searching at local ./$name');
      return DynamicLibrary.open('./$name');
    } catch (e) {
      try {
        print('Searching at local ./blob/$name');
        return DynamicLibrary.open('./blob/$name');
      } catch (e) {
        try {
          ///
          print('Searching in BiiiSerial Package');
          Uri rootLibrary;
          rootLibrary = Uri.parse('package:biiiSerial/BiiiSerial.dart');
          rootLibrary = cli.waitFor(Isolate.resolvePackageUri(rootLibrary));
          rootLibrary = rootLibrary.resolve('src/native/lib/');
          print('Abs Path is ${rootLibrary.resolve(name).toFilePath()}');
          return DynamicLibrary.open(rootLibrary.resolve(name).toFilePath());
        } catch (e) {
          print('Unable to load from package $e');
          throw e;
        }
      }
    }
  }
}

DynamicLibrary _SerialLib = loadLibrary('biiiserial');

/// get biiiserial_scan function
_SerialScanRespFunctionDart startScanFunction =
    _SerialLib.lookup<NativeFunction<_SerialScanRespFunctionNative>>(
            'biiiserial_scan')
        .asFunction();

_SerialOpenFunctionDart openPortFunction =
    _SerialLib.lookup<NativeFunction<_SerialOpenFunctionNative>>(
            'biiiserial_connect')
        .asFunction();

_SerialSendFunctionDart sendPortFunction =
    _SerialLib.lookup<NativeFunction<_SerialSendFunctionNative>>(
            'biiiserial_send')
        .asFunction();

_SerialReadRespCallbackDart readPortFunction =
    _SerialLib.lookup<NativeFunction<_SerialReadRespCallbackNative>>(
            'biiiserial_read')
        .asFunction();

_SerialCloseFunctionDart closePortFunction =
    _SerialLib.lookup<NativeFunction<_SerialCloseFunctionNative>>(
            'biiiserial_close')
        .asFunction();

///  _Serial port data structure
class _SerialLibPortDataStruct extends Struct {
  ///
  Pointer<Utf8> name;

  ///
  factory _SerialLibPortDataStruct.allocate(Pointer<Utf8> name) =>
      allocate<_SerialLibPortDataStruct>().ref..name = name;
}

///
List<BiiiSerialPort> _ports;

void scanRespCallback(Pointer<_SerialLibPortDataStruct> portPointer) {
  _ports.add(BiiiSerialPortNative(Utf8.fromUtf8(portPointer.ref.name)));
}

void ffiNativeSerialStartScan(List<BiiiSerialPort> result) {
  _ports = result;
  startScanFunction(Pointer.fromFunction(scanRespCallback));
}

int ffiNativeSerialConnect(
    String name, int baud, int bits, int parity, int stop) {
  return openPortFunction(Utf8.toUtf8(name), baud, bits, parity, stop);
}

List<int> _rxList;
void readPortCallback(Pointer<Uint8> pointer, int len, int tty_id) {
  _rxList = pointer.asTypedList(len);
}

List<int> ffiNativeSerialRead(int tty_id) {
  int b = readPortFunction(tty_id, Pointer.fromFunction(readPortCallback));
  return b > 0 ? _rxList : b == 0 ? [] : null;
}

int ffiNativeSerialWrite(int tty_id, List<int> bytes) {
  final Pointer<Uint8> frameData = allocate<Uint8>(count: bytes.length);
  for (int i = 0; i < bytes.length; i++) {
    frameData[i] = bytes[i];
  }
  int r = sendPortFunction(tty_id, frameData, bytes.length);
  free(frameData);
  return r;
}

int ffiNativeSerialClose(int tty_id) {
  return closePortFunction(tty_id);
}
