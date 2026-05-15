import 'dart:ui';

import 'package:LactosureConnect/LOGIN/Society/Bluetooth/BLE/screens/scan_screen.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/state.dart';

import 'package:LactosureConnect/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 62, 65, 66),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {},
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth is ${state != null ? state.toString().substring(15) : 'not available'}.',
                style: Theme.of(context)
                    .primaryTextTheme
                    .headlineMedium
                    // ignore: deprecated_member_use

                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: const Text('TURN ON'),
                onPressed: () =>
                    FlutterBluetoothSerial.instance.requestEnable(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  List<BluetoothDevice> _devicesList = [];

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
  }

  @override
  void dispose() {
    if (connexion?.isConnected ?? false) {
      connexion?.close();
    }
    super.dispose();
  }

  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
      // ignore: empty_catches
    } on PlatformException {}

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      connexion = await BluetoothConnection.toAddress(device.address);
      // ignore: use_build_context_synchronously
      context.read<AppState>().setConnexion(connexion!);
      // ignore: use_build_context_synchronously
      context.read<AppState>().listenForIncoming(context);
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const DeviceScreen()))
          .then((value) {
        bluetoothConnectionState();
      });
    } catch (e) {
      // Handle the connection error
      _showConnectionTimeoutDialog();
    }
  }

  Future<void> openconnect(BluetoothDevice device) async {
    try {
      // Navigate to DeviceScreen and wait for it to complete
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DeviceScreen()),
      );

      // The code after this line will be executed after DeviceScreen is popped
      bluetoothConnectionState();
    } catch (e) {
      // Handle the connection error
    }
  }

  Future<void> _showConnectionTimeoutDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(
                52, 84, 17, 108), // Set the background color to transparent
            title: Text(
              'Connection Timeout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            content: Text(
              'Could not establish a connection. Please try again.',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            actions: <Widget>[
              PrimaryButton(
                maxHeight: 40,
                maxWidth: 60,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (_) async {},
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Paired Devices',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ScanScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final begin = Offset(0.00010.sw, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutCubic;
                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ));
              },
            ),
            actions: [
              // Add your icon button here
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              return bluetoothConnectionState();
            },
            child: ListView(
              children: _devicesList
                  .map(
                    (e) => ListTile(
                      title: Text(e.name ?? 'Unknown'),
                      subtitle: Text(e.address),
                      trailing: PrimaryButton(
                        maxHeight: 30,
                        maxWidth: 100,
                        child: Text(
                          e.isConnected
                              ? 'Open'
                              : 'Connect', // Change button text dynamically
                        ),
                        onTap: () {
                          if (!(e.isConnected)) {
                            try {
                              Future.delayed(const Duration(seconds: 30), () {
                                if (connexion?.isConnected ?? false) {
                                  return; // Connection established before the timeout
                                }
                                // Connection not established within the timeout
                                connexion?.close();
                                _showConnectionTimeoutDialog();
                              });

                              connect(e);
                            } catch (e) {
                              // Handle the connection error
                              _showConnectionTimeoutDialog();
                            }
                          } else {
                            openconnect(e);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ));
  }
}
