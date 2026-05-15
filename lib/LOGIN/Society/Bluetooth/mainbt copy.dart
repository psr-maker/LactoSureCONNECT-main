// ignore_for_file: unused_import

import 'package:LactosureConnect/LOGIN/Society/Bluetooth/BLE/screens/scan_screen.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/bthome.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Homebt extends StatefulWidget {
  const Homebt({super.key});

  @override
  State<Homebt> createState() => _HomeState();
}

class _HomeState extends State<Homebt> {
  BluetoothState _bState = BluetoothState.UNKNOWN;

  @override
  void initState() {
    _requestLocationPermission();
    super.initState();
    FlutterBluetoothSerial.instance.onStateChanged().listen((event) {
      setState(() {
        _bState = event;
      });
    });
    checkConnected();
  }

  void checkConnected() async {
    if (await FlutterBluetoothSerial.instance.isEnabled == true) {
      setState(() {
        _bState = BluetoothState.STATE_ON;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isDenied) {
      // Permission has been denied.
      // You may want to display a dialog explaining why the permission is needed
      // and allow the user to go to the app settings to enable the permission.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bState == BluetoothState.STATE_ON) {
      return const ScanScreen();
    }
    return BluetoothOffScreen(state: _bState);
  }
}
