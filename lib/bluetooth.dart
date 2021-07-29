import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final flutterReactiveBle = FlutterReactiveBle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
