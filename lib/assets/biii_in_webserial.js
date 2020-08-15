var _port;
var _writer;
var _reader;
var onReceiveFx;
var onDisconnectFx;

dlog = function () { }
// dlog = console.log;

// chrome setting for support
// #enable-experimental-web-platform-features flag in chrome://flags
// https://github.com/WICG/serial/blob/gh-pages/EXPLAINER.md
async function bgWsRequestDevice(filter) {
    if (biii_serial_isSupprted()) {
        dlog('using', filter);
        return navigator.serial.requestPort(filter).then((p) => {
            dlog('got ', p);
            if ('getInfo' in p) {
                dlog(p.getInfo());
            }
            _port = p;
            return 0;
        }, (err) => {
            dlog(err);
            return 1;
        });
    } else {
        dlog('webserial not supported');
        return 2;
    }
}

function biii_serial_isSupprted() {
    return 'serial' in navigator;
}


function bgWsHasDevice() {
    return _port != null;
}

async function bgWsConnectDevice(options, onReceive, onDisconnect) {
    if (_port == null) {
        rc = await bgWsRequestDevice({ filters: [] });
        if (rc != 0)
            return false;
    }
    dlog(options);
    onReceiveFx = onReceive;
    onDisconnectFx = onDisconnect;
    return _port.open(options).then(
        () => {
            dlog('Port Opened ', _port);
            bgWsStartRxLoop();
            _writer = _port.writable.getWriter();
            dlog('TxObj created ');
            dlog('RxLoop Start ');
            return true;
        }, () => {
            dlog('Already Opened ', _port);
            return false;
        }
    );
}

async function bgWsStartRxLoop() {
    // while (_port & _port.readable) {
    _reader = _port.readable.getReader();
    dlog(Date.now(), 'reader created', _reader);
    while (true) {
        try {
            const { value, done } = await _reader.read();
            if (done) {
                // |_reader| has been canceled.
                break;
            }
            if (value) {
                dlog(Date.now(), '[RX]', value);
                if (onReceiveFx) {
                    onReceiveFx(value);
                }
            }
        } catch (error) {
            dlog(error);
            break;
        }
    }
    bgWsDisconnectDevice();
    // }
}

function bgWsDisconnectDevice() {
    if (_port) {
        if (_writer) {
            _writer.close();
            _writer.releaseLock();
            _writer = null;
        }
        if (_reader) {
            if (!_reader.closed) {
                _reader.cancel();
            }
            _reader.releaseLock();
            _reader = null;
        }
        _port.close();
        // _port = null;
    }
    onDisconnectFx();
    return true;
}

function bgWsTxBytes(value) {
    if (_writer) {
        dlog(Date.now(), '[TX]', value);
        _writer.write(value);
        return true;
    }
    return false;
}
