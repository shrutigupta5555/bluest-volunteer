import 'dart:math';

import 'package:blueaidngo/Home.dart';
import 'package:blueaidngo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:blueaidngo/src/ble/ble_scanner.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import 'device_detail/device_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<String> getName() async {
  final SharedPreferences temp = await _prefs;

  final String _vol = temp.getString("volunteer");

  return _vol;
}

Future<String> getId() async {
  final SharedPreferences temp = await _prefs;

  final String _id = temp.getString("id");

  return _id;
}

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

  String name;
  String volId;
  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));

    getName().then((value) {
      setState(() {
        name = value;
      });
    });

    getId().then((value) {
      setState(() {
        volId = value;
      });
    });
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
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 254, 255, 1),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(image: AssetImage('assets/logo.png')),
                              SizedBox(width: 20.0),
                              Text(
                                "Blue Aid",
                                style: GoogleFonts.nunito(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                final SharedPreferences temp = await _prefs;

                                temp.setString("volunteer", "").then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Selection(),
                                      ));
                                });
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Welcome $name",
                              style: GoogleFonts.nunito(
                                  color: Color.fromRGBO(3, 84, 102, 1),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Volunteer Id: $volId",
                              style: GoogleFonts.nunito(
                                  color: Color.fromRGBO(3, 84, 102, 1),
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 56.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Nearby Civilians",
                          style: GoogleFonts.nunito(
                              color: Color.fromRGBO(3, 84, 102, 1),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "Civilians can be tracked within 30 meters",
                          style: GoogleFonts.nunito(
                              color: Color.fromRGBO(1, 187, 229, 1),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 40.0,
                        )
                      ],
                    ),
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
                          child: Text(
                            'Stop',
                          ),
                          onPressed: widget.scannerState.scanIsInProgress
                              ? widget.stopScan
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.scannerState.scanIsInProgress ||
                            widget.scannerState.discoveredDevices.isNotEmpty)
                          Text(
                            'No. of civilians: ${widget.scannerState.discoveredDevices.length}',
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(3, 84, 102, 1),
                                fontSize: 20.0),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: ListView(
                  children: widget.scannerState.discoveredDevices.map((device) {
                    num rssi = device.rssi;
                    num distance = pow(10, (-69 - rssi) / 20);
                    Color selected;
                    if (distance < 5) {
                      selected = Color.fromRGBO(3, 84, 102, 1.0);
                    } else if (distance >= 5 && distance < 10) {
                      selected = Color.fromRGBO(3, 84, 102, 0.95);
                    } else if (distance >= 10 && distance < 16) {
                      selected = Color.fromRGBO(3, 84, 102, 0.85);
                    } else {
                      selected = Color.fromRGBO(3, 84, 102, 0.7);
                    }

                    return Container(
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              device.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            minVerticalPadding: 8.0,
                            subtitle: Text(
                                "${device.id}\n Distance: $distance m",
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
        ),
      ),
    );
  }
}
