import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:blueaidngo/src/ble/ble_scanner.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import 'device_detail/device_detail_screen.dart';

class DeviceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState>(
        builder: (_, bleScanner, bleScannerState, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScan,
          stopScan: bleScanner.stopScan,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  const _DeviceList({this.scannerState, this.startScan, this.stopScan});

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  TextEditingController _uuidController;

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.stopScan();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }

  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scan for devices'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Service UUID (2, 4, 16 bytes):'),
                  TextField(
                    controller: _uuidController,
                    enabled: !widget.scannerState.scanIsInProgress,
                    decoration: InputDecoration(
                        errorText:
                            _uuidController.text.isEmpty || _isValidUuidInput()
                                ? null
                                : 'Invalid UUID format'),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text('Scan'),
                        onPressed: !widget.scannerState.scanIsInProgress &&
                                _isValidUuidInput()
                            ? _startScanning
                            : null,
                      ),
                      ElevatedButton(
                        child: const Text('Stop'),
                        onPressed: widget.scannerState.scanIsInProgress
                            ? widget.stopScan
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(!widget.scannerState.scanIsInProgress
                            ? 'Enter a UUID above and tap start to begin scanning'
                            : 'Tap a device to connect to it'),
                      ),
                      if (widget.scannerState.scanIsInProgress ||
                          widget.scannerState.discoveredDevices.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 18.0),
                          child: Text(
                              'count: ${widget.scannerState.discoveredDevices.length}'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                children: widget.scannerState.discoveredDevices.map((device) {
                  num rssi = device.rssi;
                  num distance = pow(10, (-69 - rssi) / 20);
                  Color selected;
                  if (distance < 5) {
                    selected = Color.fromRGBO(3, 84, 102, 1);
                  } else if (distance >= 5 && distance < 10) {
                    selected = Color.fromRGBO(3, 84, 102, 0.95);
                  } else if (distance >= 10 && distance < 16) {
                    selected = Color.fromRGBO(3, 84, 102, 0.85);
                  } else {
                    selected = Color.fromRGBO(3, 84, 102, 0.7);
                  }

                  return Container(
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            device.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          minVerticalPadding: 8.0,
                          subtitle: Text("${device.id}\n Distance: $distance m",
                              style: TextStyle(color: Colors.white)),
                          leading: Icon(
                            Icons.bluetooth,
                            color: Colors.white,
                          ),
                          tileColor: selected,
                        ),
                        SizedBox(
                          height: 12.0,
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
}
