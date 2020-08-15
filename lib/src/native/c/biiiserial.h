// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include <stdbool.h>
#include <stdint.h>

typedef enum
{
  ONE = 0,
  TWO = 1,
  // ONE_HALF = 1,
} stopbits_t;

typedef enum
{
  NONE = 0,
  ODD = 1,
  EVEN = 2
} parity_t;

struct SerialLibPortDataStruct
{
  char* name;
};

typedef void (*ScanResultProto)(struct SerialLibPortDataStruct* data);

typedef void (*SeriaTxRxProto)(char* data, int dataLen, int tty_id);

void
biiiserial_scan(ScanResultProto resultFx);

int
biiiserial_connect(char* name,
                   int baudrate,
                   int databits,
                   int parity,
                   int stopbits);

int
biiiserial_send(int tty_fd, char* data, int dataLen);

int
biiiserial_read(int tty_fd, SeriaTxRxProto rxFx);

int
biiiserial_close(int tty_fd);