// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "biiiserial.h"
#include <fcntl.h>
#include <io.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <windows.h>

int
main()
{
  printf("Biii Serial test TODO");
  return 0;
}

// int
// convertParity(parity_t parity)
// {
//   // MARKPARITY, SPACEPARITY not supported
//   switch (parity) {
//     default:
//     case NONE:
//       return NOPARITY;
//     case ODD:
//       return ODDPARITY;
//     case EVEN:
//       return EVENPARITY;
//   }
// }

// int
// convertStopBits(stopbits_t stopbits)
// {
//   switch (stopbits) {
//     default:
//     case ONE:
//       return ONESTOPBIT;
//     case TWO:
//       return TWOSTOPBITS;
//       /*
//    case TWOSTOPBITS:
//       return TWOSTOPBITS;
//       */
//   }
// }

// int
// openSerialPort(const char* port_name,
//                int baudrate,
//                int databits,
//                parity_t parity,
//                stopbits_t stopbits)
// {
//   HANDLE handlePort = CreateFile(
//     port_name, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0,
//     NULL);
//   int tty_fd = _open_osfhandle((intptr_t)(handlePort), _O_TEXT);
//   if (tty_fd > 0) {
//     DCB config = { 0 };
//     config.DCBlength = sizeof(config);
//     config.fBinary = true;
//     config.BaudRate = baudrate;
//     config.ByteSize = databits;
//     config.Parity = convertParity(parity);
//     config.StopBits = convertStopBits(stopbits);
//     config.fDtrControl = 0;
//     config.fRtsControl = 0;
//     SetCommState(handlePort, &config);

//     COMMTIMEOUTS commTimeouts = { 0 };
//     commTimeouts.ReadIntervalTimeout = 1;
//     commTimeouts.ReadTotalTimeoutMultiplier = 0;
//     commTimeouts.ReadTotalTimeoutConstant = 100;
//     commTimeouts.WriteTotalTimeoutConstant = 100;
//     commTimeouts.WriteTotalTimeoutMultiplier = 1;
//     SetCommTimeouts(handlePort, &commTimeouts);

//     PurgeComm(handlePort, PURGE_RXCLEAR);
//     PurgeComm(handlePort, PURGE_TXCLEAR);
//   }
//   return tty_fd;
// }

// bool
// closeSerialPort(int tty_fd)
// {
//   HANDLE handlePort = (HANDLE)(_get_osfhandle(tty_fd));
//   return CloseHandle(handlePort);
// }

// int
// readFromSerialPort(int tty_fd, uint8_t* data, int buffer_size)
// {
//   DWORD bytes_read = -1;
//   HANDLE handlePort = (HANDLE)(_get_osfhandle(tty_fd));
//   ReadFile(handlePort, data, buffer_size, &bytes_read, NULL);
//   return bytes_read;
// }

// int
// writeToSerialPort(int tty_fd, const char* data)
// {
//   HANDLE handlePort = (HANDLE)(_get_osfhandle(tty_fd));
//   DWORD length = -1;
//   WriteFile(handlePort, data, strlen(data), &length, NULL);
//   return length;
// }

// Note:
// ---only on Windows---
// Every function needs to be exported to be able to access the functions by
// dart. Refer: https://stackoverflow.com/q/225432/8608146
void
biiiserial_scan(ScanResultProto resultFx)
{
  char name[16] = { 0 };
  struct SerialLibPortDataStruct result = { .name = name };
  char lpTargetPath[4096] = { 0 };
  static char longResult[1024] = { 0 };
  int foundCharIndex = 0;
  for (int i = 0; i < 256; i++) {
    snprintf(name, 15, "COM%d", i);
    DWORD res = QueryDosDevice(name, lpTargetPath, 5000);
    if (res != 0) {
      resultFx(&result);
    }
  }
}

int
biiiserial_connect(char* name,
                   int baudrate,
                   int databits,
                   int parity,
                   int stopbits)
{
  HANDLE handlePort = CreateFile(
    name, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
  int tty_fd = _open_osfhandle((intptr_t)(handlePort), _O_TEXT);
  if (tty_fd > 0) {
    DCB config = { 0 };
    config.DCBlength = sizeof(config);
    config.fBinary = true;
    config.BaudRate = baudrate;
    config.ByteSize = databits;
    config.Parity = parity;
    config.StopBits = stopbits;
    config.fDtrControl = 0;
    config.fRtsControl = 0;
    SetCommState(handlePort, &config);

    COMMTIMEOUTS commTimeouts = { 0 };
    commTimeouts.ReadIntervalTimeout = 1;
    commTimeouts.ReadTotalTimeoutMultiplier = 0;
    commTimeouts.ReadTotalTimeoutConstant = 100;
    commTimeouts.WriteTotalTimeoutConstant = 100;
    commTimeouts.WriteTotalTimeoutMultiplier = 1;
    SetCommTimeouts(handlePort, &commTimeouts);

    PurgeComm(handlePort, PURGE_RXCLEAR);
    PurgeComm(handlePort, PURGE_TXCLEAR);
  }
  return tty_fd;
}

int
biiiserial_send(int tty_fd, char* data, int dataLen)
{
  HANDLE handlePort = (HANDLE)(_get_osfhandle(tty_fd));
  DWORD length = -1;
  WriteFile(handlePort, data, dataLen, &length, NULL);
  return length;
}

int
biiiserial_read(int tty_fd, SeriaTxRxProto rxFx)
{
  DWORD bytes_read = -1;
  static char data[64] = { 0 };
  HANDLE handlePort = (HANDLE)(_get_osfhandle(tty_fd));
  ReadFile(handlePort, data, 64, &bytes_read, NULL);
  rxFx(data, bytes_read, tty_fd);
  return bytes_read;
}

int
biiiserial_close(int tty_fd)
{
  HANDLE handlePort = (HANDLE)(_get_osfhandle(tty_fd));
  return CloseHandle(handlePort);
}