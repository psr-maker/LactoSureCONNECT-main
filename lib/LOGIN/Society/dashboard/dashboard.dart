// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'dart:typed_data';

import 'package:LactosureConnect/Constant/core/extensions/getx_custom_snackbar.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/mainbt.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/state.dart';
import 'package:LactosureConnect/Constant/datas/containers/containers.dart';

import 'package:LactosureConnect/LOGIN/Society/reports/localreport.dart';

import 'package:LactosureConnect/widgets/background_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

bool stati = false;
bool mpass = false;
String test = AppState.ofController.text;
int bt = 0;

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({
    super.key,
  });
  static TextEditingController collectionController = TextEditingController();
  static TextEditingController ipfController = TextEditingController();
  static TextEditingController ipcController = TextEditingController();
  static TextEditingController userpassController = TextEditingController();
  static TextEditingController superpassController = TextEditingController();
  static TextEditingController wifipassController = TextEditingController();
  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

// ignore: duplicate_ignore
class _DeviceScreenState extends State<DeviceScreen> {
  final appState = AppState();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  int selectedShift = 0;

  late final String uid;

  @override
  void initState() {
    super.initState();
    getCurrentUserUid();
    setState(() {
      bt = 0;
    });
    String hexCommand = '40044800000C';
    appState.sendHexDatabt(hexCommand);
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      if (state == BluetoothState.STATE_OFF) {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Btmain(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
      }
    });
  }

  void listenForIncomingData() {
    // Check if connexion is not null
    if (connexion != null) {
      connexion!.input!.listen(
        (Uint8List data) {
          // Handle the received data

          // Process the data as needed
          // Update your UI, set state, etc.
        },
        onDone: () {
          // Handle the connection closed
        },
        onError: (error) {
          // Handle any errors
        },
      );
    }
  }

  void getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // User is signed in
      uid = user.uid;
    } else {
      // User is not signed in
    }
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {})
        .cancel();
    super.dispose();
  }

  double totalAmount = 0;
  Future<void> disconnect() async {
    try {
      if (connexion?.isConnected ?? false) {
        await connexion?.close();
        setState(() {
          // Update your UI if needed after disconnection
        });
      }
    } catch (e) {
      // Handle the disconnection error
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          // Show a confirmation dialog when the back button is pressed
          bool shouldLeave = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to leave this page?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User confirms leaving
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User cancels leaving
                  },
                  child: Text('No'),
                ),
              ],
            ),
          );

          return shouldLeave ?? false;
        },
        child: BackgroundScaffolddash(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(
                240, 0, 0, 0), // Set the background color to transparent

            title: const Text(
              '',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
              onPressed: () {
                if (mpass == true || stati == true) {
                  setState(() {
                    mpass = false;
                    stati = false;
                  });
                  String hexCommand = '40044800000C';
                  appState.sendHexDatabt(hexCommand);
                } else
                  Navigator.pop(context);
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.030, screenHeight * 0.025, 0, 0),
                child: MachineId(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, screenHeight * 0.025,
                    screenWidth * 0.0, screenWidth * 0.000),
                child: farmcontainer(),
              ),
              FloatingActionButton(
                onPressed: () {
                  // Call the disconnect method when button is pressed if connected, otherwise do nothing
                  if (connexion?.isConnected ?? false) {
                    disconnect();

                    setState(() {
                      bt = 1;
                    });
                  }
                },
                tooltip: 'Disconnect',
                backgroundColor: Colors
                    .transparent, // Set the background color to transparent
                foregroundColor:
                    Colors.green, // Set the color of the icon to green
                child: (connexion?.isConnected ?? false)
                    ? Icon(Icons.bluetooth_connected) // Show connected icon
                    : Icon(Icons.bluetooth_disabled), // Show disconnected icon
              ),
            ],
          ),
          resizeToAvoidBottomInset: true,
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
          backgroundBlur: 0,
          child: SafeArea(
            child: Stack(
              children: [
                // Background Image
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.3), // Adjust opacity as needed
                  ),
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.053, screenHeight * 0.00, 0, 0),
                        child: BorderOnlyContainer(
                          child: Text(''),
                          borderColor: Color.fromARGB(255, 190, 186, 186),
                          borderWidth:
                              MediaQuery.of(context).size.width * 0.004,
                          width: screenWidth * 0.9,
                          height: screenHeight * .69,
                          borderRadius: BorderRadius.circular(20.0).r,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: screenHeight * 0.015),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.030, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FatContainer(),
                                SizedBox(
                                  width: screenWidth * 0.023,
                                ),
                                const SnfContainer(),
                                SizedBox(
                                  width: screenWidth * 0.023,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.085,
                          screenHeight * 0.215,
                          0,
                          0,
                        ),
                        child: Column(
                          children: [
                            const Protein(),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            const Lactos(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.37, screenHeight * 0.215, 0, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const clrcontainer(),
                                SizedBox(
                                  width: screenWidth * 0.018,
                                ),
                                const water()
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Row(
                              children: [
                                const Salt(),
                                SizedBox(
                                  width: screenWidth * 0.018,
                                ),
                                temp()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.528, screenHeight * 0.49, 0, 0),
                  child: Result(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.48, screenHeight * 0.47, 0, 0),
                  child: Container(
                    height: screenHeight * 0.21, // Adjust the width as needed
                    child: VerticalDivider(
                      color: const Color.fromARGB(255, 110, 113, 109),
                      thickness: MediaQuery.of(context).size.width * 0.004,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.084, screenHeight * 0.455, 0, 0),
                  child: Container(
                    width: screenWidth * 0.84, // Adjust the width as needed
                    child: Divider(
                      color: const Color.fromARGB(255, 110, 113, 109),
                      thickness: MediaQuery.of(context).size.width * 0.004,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.09, screenHeight * 0.609, 0, 0),
                  child: rate(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.09, screenHeight * 0.545, 0, 0),
                  child: qty(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.09, screenHeight * 0.48, 0, 0),
                  child: bonus(),
                ),

                Positioned(
                  top: screenHeight * 0.0,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.053, screenHeight * 0.711, 0, 0),
                        child: BorderOnlyContainer(
                          child: Text(''),
                          borderColor: Color.fromARGB(255, 110, 113, 109),
                          borderWidth:
                              MediaQuery.of(context).size.width * 0.004,
                          width: screenWidth * 0.9,
                          height: screenHeight * .163,
                          borderRadius: BorderRadius.circular(20.0).r,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.08, screenHeight * 0.8, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: TextButton(
                            onPressed: () async {
                              if (bt == 1) {
                                Get.customSnackBar(
                                  statusType: StatusType.error,
                                  designType: SnackDesign.iconFocus,
                                  title: 'Bluetooth disconnected',
                                  compact: true,
                                );
                              }
                              String hexCommand = '400407000043';
                              appState.sendHexData(hexCommand, context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(80, 23, 161, 81),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(255, 62, 175, 17)
                                        .withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.water_drop,
                                    size: MediaQuery.of(context).size.width *
                                        0.03),
                                SizedBox(
                                    width: screenWidth *
                                        0.01), // Adjust the space between icon and label
                                Text(
                                  'TEST',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.024),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.3, screenHeight * 0.8, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: TextButton(
                            onPressed: () async {
                              if (bt == 1) {
                                Get.customSnackBar(
                                  statusType: StatusType.error,
                                  designType: SnackDesign.iconFocus,
                                  title: 'Bluetooth disconnected',
                                  compact: true,
                                );
                              }
                              String hexCommand = '400409000A47';
                              appState.sendHexData(hexCommand, context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(80, 6, 128, 147),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(255, 27, 79, 116)
                                        .withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cleaning_services,
                                    size: MediaQuery.of(context).size.width *
                                        0.03),
                                SizedBox(
                                    width: screenWidth *
                                        0.01), // Adjust the space between icon and label
                                Text(
                                  'CLEAN',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.024),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.73, screenHeight * 0.8, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: GestureDetector(
                            onLongPress: () async {
                              String hexCommand = '400447000003';
                              appState.sendHexData(hexCommand, context);
                              print('stop');
                            },
                            child: TextButton(
                              onPressed: () async {
                                if (bt == 1) {
                                  Get.customSnackBar(
                                    statusType: StatusType.error,
                                    designType: SnackDesign.iconFocus,
                                    title: 'Bluetooth disconnected',
                                    compact: true,
                                  );
                                }
                                String hexCommand = '4004010A004F';
                                appState.sendHexData(hexCommand, context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(80, 255, 3, 3),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.red.withOpacity(0.5);
                                    }
                                    return Colors.transparent;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0.r),
                                    side: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 127, 125, 125),
                                    ),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cancel_outlined,
                                      size: MediaQuery.of(context).size.width *
                                          0.03),
                                  SizedBox(
                                      width: screenWidth *
                                          0.01), // Adjust the space between icon and label
                                  Text(
                                    'EXIT',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.024),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.515, screenHeight * 0.8, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: TextButton(
                            onPressed: () async {
                              if (bt == 1) {
                                Get.customSnackBar(
                                  statusType: StatusType.error,
                                  designType: SnackDesign.iconFocus,
                                  title: 'Bluetooth disconnected',
                                  compact: true,
                                );
                              }

                              String hexCommand = '400401040041';
                              appState.sendHexData(hexCommand, context);
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(10.r, 25.r),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(80, 17, 199, 169),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(255, 18, 123, 34)
                                        .withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login,
                                    size: MediaQuery.of(context).size.width *
                                        0.03),
                                SizedBox(
                                    width: screenWidth *
                                        0.01), // Adjust the space between icon and label
                                Text(
                                  'OK',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.024),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.08, screenHeight * 0.7256, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: TextButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SavedFilesPage()),
                              );
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(10.r, 25.r),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(80, 147, 33, 165),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(255, 18, 123, 34)
                                        .withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_sharp,
                                  size: .03.sw,
                                ),
                                SizedBox(
                                    width: 4
                                        .r), // Adjust the space between icon and label
                                Text(
                                  'Local\nREPORT',
                                  style: TextStyle(
                                    fontSize: .023.sw,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.3, screenHeight * 0.7256, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                stati = !stati;
                                mpass = false;
                              });
                              print(mpass);
                              String hexCommand = '400447000003';
                              appState.sendHexDatabt(hexCommand);
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(10.r, 25.r),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(80, 17, 199, 169),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(255, 18, 123, 34)
                                        .withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work,
                                    size: MediaQuery.of(context).size.width *
                                        0.03),
                                SizedBox(
                                    width: screenWidth *
                                        0.01), // Adjust the space between icon and label
                                Text(
                                  'STATI',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0235),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.73, screenHeight * 0.7256, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: GestureDetector(
                            onLongPress: () async {
                              String hexCommand = '400447000003';
                              appState.sendHexData(hexCommand, context);
                              print('stop');
                            },
                            child: TextButton(
                              onPressed: () async {
                                if (bt == 1) {
                                  Get.customSnackBar(
                                    statusType: StatusType.error,
                                    designType: SnackDesign.iconFocus,
                                    title: 'Bluetooth disconnected',
                                    compact: true,
                                  );
                                }
                                AppState.ofController.text = '0';
                                String hexCommand = '400447000003';
                                appState.sendHexData(hexCommand, context);
                                print(test);
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(10.r, 25.r),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(80, 255, 3, 3),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.red.withOpacity(0.5);
                                    }
                                    return Colors.transparent;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0.r),
                                    side: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 127, 125, 125),
                                    ),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.stop,
                                      size: MediaQuery.of(context).size.width *
                                          0.03),

                                  SizedBox(
                                      width: screenWidth *
                                          0.01), // Adjust the space between icon and label
                                  Text(
                                    'STOP',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.024),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.515, screenHeight * 0.7256, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                mpass = !mpass;

                                stati = false;
                                String hexCommand = '40044800000C';
                                appState.sendHexDatabt(hexCommand);
                              });
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(10.r, 25.r),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(80, 199, 190, 17),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(255, 18, 123, 34)
                                        .withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.password,
                                    size: MediaQuery.of(context).size.width *
                                        0.03),
                                SizedBox(
                                    width: screenWidth *
                                        0.01), // Adjust the space between icon and label
                                Text(
                                  'PASS',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.024),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0).r,
                      //   child: Visibility(
                      //       visible: mpass, child: const MsettContainer()),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0).r,
                  child:
                      Visibility(visible: stati, child: const statiContainer()),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.0, screenHeight * 0, 0, 0),
                  child:
                      Visibility(visible: mpass, child: const mpassContainer()),
                ),
              ],
            ),
          ),
        ));
  }
}
