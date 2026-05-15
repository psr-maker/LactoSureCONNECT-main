import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:LactosureConnect/Constant/core/extensions/getx_custom_snackbar.dart';
import 'package:LactosureConnect/Constant/screens/authentication_screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String UniqueId = EmailAndPasswordAuthForm.uidcontroller.text;
BluetoothConnection? connexion;

class AppState extends ChangeNotifier {
  AppState();
  static TextEditingController ofController = TextEditingController();

  final StreamController<String> dataStreamController =
      StreamController<String>();

  List<String> resultBoxes =
      List.generate(18, (index) => ''); // Initialize with 11 empty strings
  String testValuehex = '';
  String cleanDailyValuehex = '';
  String cleanWeeklyValuehex = '';
  String skipValuehex = '';
  String PassworduserHex = '';
  String PasswordsuperHex = '';
  String PasswordwifiHex = '';
  String passalert = '';
  String otp = '';
  String otps = '';
  void setConnexion(BluetoothConnection conn) {
    connexion = conn;
    // You can perform additional actions here if needed
    notifyListeners();
  }

  void disposeConnexion() {
    connexion?.close(); // Check for null before calling close()
  }

  String hexToDecimalAtPosition(
      String hexString, int startPosition, int length) {
    try {
      String subHexString =
          hexString.substring(startPosition, startPosition + length);
      BigInt decimalValue = BigInt.parse(subHexString, radix: 16);
      return decimalValue.toString();
    } catch (e) {
      return 'Invalid Hex';
    }
  }

  void listenForIncoming(BuildContext context) {
    connexion?.input?.listen((Uint8List data) {
      String receivedText = String.fromCharCodes(data);

      otp = bytesToHex(data);

      int receivedTextLength = receivedText.length;

      int receivedotpLength = otp.length;
      print('Received text: $receivedText');
      print('Received hex: $otp');
      print('Received otp: $otps');
      print('Received Text Length: $receivedTextLength');
      print('Received otp Length: $receivedotpLength');
      String positionDecimalValue = hexToDecimalAtPosition(otp, 8, 4);
      print('Decimal Value at position 4: $positionDecimalValue');
      ofController.text = '1';
      // Print the received string

      // Convert the received text to hex
      String hexString = bytesToHex(data);

      passalert = hexString;
      if (receivedotpLength != 14) {
        if (receivedotpLength == 20) {
          String PassworduserHex1 = hexString.substring(6, 10);
          String PasswordsuperHex1 = hexString.substring(10, 14);
          String PasswordwifiHex1 = hexString.substring(14, 18);
          PassworduserHex = hexToDecimal(PassworduserHex1);
          PasswordsuperHex = hexToDecimal(PasswordsuperHex1);
          PasswordwifiHex = hexToDecimal(PasswordwifiHex1);

          print('user=$PassworduserHex');
          print('super=$PasswordsuperHex');
          print('wifi=$PasswordwifiHex');
        }
        String testValue = hexString.substring(6, 14);
        String cleanDailyValue = hexString.substring(24, 32);
        String cleanWeeklyValue = hexString.substring(32, 36);
        String skipValue = hexString.substring(36, 40);
        testValuehex = hexToDecimal(testValue);
        cleanDailyValuehex = hexToDecimal(cleanDailyValue);
        cleanWeeklyValuehex = hexToDecimal(cleanWeeklyValue);
        skipValuehex = hexToDecimal(skipValue);
      }
      if (receivedTextLength > 69) {
        List<String> splitData = receivedText.split('|');

        // Iterate through the splitData, skipping the first 3 elements, and update the result boxes
        for (int i = 0; i < min(splitData.length - 0, 18); i++) {
          resultBoxes[i] = splitData[i + 0]; // Skip the first 3 elements
        }

        print('Received Hex: $hexString');

        ;

        // Notify listeners to update the UI
        notifyListeners();

        // Show Snackbar when new data is received
        if (receivedTextLength > 69) {
          _saveToLocalStorage(context);
        }
      }
      if (receivedotpLength == 14) {
        showAlertBoxOTP(context, positionDecimalValue);
      }
    });
  }

  String bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  // Function to convert hex string to decimal string
  String hexToDecimal(String hexString) {
    try {
      BigInt decimalValue = BigInt.parse(hexString, radix: 16);
      return decimalValue.toString();
    } catch (e) {
      return 'Invalid Hex';
    }
  }

  void sendHexDatabt(String hexData) {
    // Check for null before using connexion
    if (connexion == null) {
      // Handle the case where connexion is not initialized
      return;
    }

    // Convert hex string to Uint8List
    Uint8List dataToSend = Uint8List.fromList(List<int>.generate(
        hexData.length ~/ 2,
        (index) =>
            int.parse(hexData.substring(index * 2, index * 2 + 2), radix: 16)));

    // Print the hex data being sent

    // Send the data
    connexion!.output.add(dataToSend);
    connexion!.output.allSent.then((_) {
      // Notify listeners after the data is sent
      notifyListeners();

      // If the sent hex code is for stopping, listen for incoming data
      // if (hexData == '400447000003') {
      //   listenForIncomingData();
      // }
    });
  }

  void sendHexData(String hexData, BuildContext context) {
    // Check for null before using connexion
    if (connexion == null) {
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.iconFocus,
        title: 'Bluetooth is not connected',
        compact: true,
      );
      return;
    }

    // Convert hex string to Uint8List
    Uint8List dataToSend = Uint8List.fromList(List<int>.generate(
        hexData.length ~/ 2,
        (index) =>
            int.parse(hexData.substring(index * 2, index * 2 + 2), radix: 16)));

    // Print the hex data being sent

    // Send the data
    connexion!.output.add(dataToSend);
    connexion!.output.allSent.then((_) {
      // Notify listeners after the data is sent
      notifyListeners();

      // If the sent hex code is for stopping, listen for incoming data
      // if (hexData == '400447000003') {
      //   listenForIncomingData();
      // }
    });
  }

  Future<void> _saveToLocalStorage(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    final String fatValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[3] : '0%';
    final String f = fatValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double fatDouble = double.tryParse(f) ?? 0.0;
    final String formattedFat = fatDouble.toStringAsFixed(1);
    final String fatWithPercentage = formattedFat;

    final String clrValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[5] : '';
    final String c = clrValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double clrDouble = double.tryParse(c) ?? 0.0;
    final String formattedc = clrDouble.toStringAsFixed(0);
    final String clrWithPercentage = formattedc;

    final String snfValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[4] : '0%';
    final String snf = snfValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double snfDouble = double.tryParse(snf) ?? 0.0;
    final String formattedsnf = snfDouble.toStringAsFixed(1);
    final String snfWithPercentage = formattedsnf;

    final String wValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[9] : '0%';
    final String w = wValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double wDouble = double.tryParse(w) ?? 0.0;
    final String formattedw = wDouble.toStringAsFixed(2);

    final String q =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[12] : '0%';
    final String qu = q.replaceAll(RegExp(r'[^0-9.]'), '');
    final double qua = double.tryParse(qu) ?? 0.0;
    final String quan = qua.toStringAsFixed(1);
    final String quantityi = quan;

    final String r =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[14] : '0%';
    final String ra = r.replaceAll(RegExp(r'[^0-9.]'), '');
    final double rat = double.tryParse(ra) ?? 0.0;
    final String rates = rat.toStringAsFixed(1);
    final String ratess = rates;

    final String t =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[13] : '0%';
    final String to = t.replaceAll(RegExp(r'[^0-9.]'), '');
    final double total = double.tryParse(to) ?? 0.0;
    final String amount = total.toStringAsFixed(1);
    final String totalAmount = amount;

    final String fa =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[11] : '0%';
    final String far = fa.replaceAll(RegExp(r'[^0-9.]'), '');
    final double farm = double.tryParse(far) ?? 0;
    final String farme = farm.toStringAsFixed(1);
    final String farmer = farme;
    final String channel =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[2] : '0%';

    final String tValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[10] : '0%';
    final String tem = tValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double temp = double.tryParse(tem) ?? 0.0;
    final String temperature = temp.toStringAsFixed(2);

    final String p =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[6] : '0%';
    final String pr = p.replaceAll(RegExp(r'[^0-9.]'), '');
    final double pro = double.tryParse(pr) ?? 0.0;
    final String prot = pro.toStringAsFixed(1);
    final String protien = prot;

    final String l =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[7] : '0%';
    final String la = l.replaceAll(RegExp(r'[^0-9.]'), '');
    final double lac = double.tryParse(la) ?? 0.0;
    final String lact = lac.toStringAsFixed(1);
    final String lactos = lact;

    final String s =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[8] : '0%';
    final String sa = s.replaceAll(RegExp(r'[^0-9.]'), '');
    final double sal = double.tryParse(sa) ?? 0.0;
    final String salt = sal.toStringAsFixed(1);
    final String saltt = salt;

    final String m =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[16] : '0%';
    final String ma = m.replaceAll(RegExp(r'[^0-9.]'), '');
    final double mac = double.tryParse(ma) ?? 0.0;
    final String mach = mac.toStringAsFixed(1);
    final String machineid = mach;

    final String b =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[15] : '0%';
    final String bo = b.replaceAll(RegExp(r'[^0-9.]'), '');
    final double bon = double.tryParse(bo) ?? 0.0;
    final String bonu = bon.toStringAsFixed(1);
    final String bonus = bonu;

    if (fatWithPercentage.isNotEmpty &&
        snfWithPercentage.isNotEmpty &&
        clrWithPercentage.isNotEmpty) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Load existing data or initialize an empty list if there's no data
        List<Map<String, dynamic>> savedData = [];
        String? existingData = prefs.getString('table_data');
        if (existingData != null) {
          savedData =
              List<Map<String, dynamic>>.from(json.decode(existingData));
        }

        // Get current date and time
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        // Append new row to the existing data with current date and time
        savedData.add({
          'Save Date': formattedDate,
          'Society ID': UniqueId,
          'FarmerId': farmer,
          'Machine ID': machineid,
          'Channel': channel,
          'FAT': fatWithPercentage,
          'SNF': snfWithPercentage,
          'CLR': clrWithPercentage,
          'Protien': protien,
          'Lactos': lactos,
          'Salt': saltt,
          'Water': formattedw,
          'Temperature': temperature,
          'Rate': ratess,
          'Quantity': quantityi,
          'Total Amount': totalAmount,
          'Bonus': bonus,
        });

        // Save updated data
        await prefs.setString('table_data', json.encode(savedData));

        showSuccessNotification(context);
      } catch (e) {
        showSnackbarerror(context, 'Error');
      }
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor:
            Color.fromARGB(255, 16, 135, 75), // Adjust the duration as needed
      ),
    );
  }

  void showSuccessNotification(BuildContext context) async {
    // Create a FlutterLocalNotificationsPlugin instance
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize the plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Define notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Collection Saved', // Change this to your channel ID
      'Successfull', // Change this to your channel name
      // Change this to your channel description
      importance: Importance.high,
      priority: Priority.high,
      color:
          Color.fromARGB(255, 16, 135, 75), // Set the background color to red
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Collection saved Successfully', // Notification title
      '', // Notification body
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void showSnackbarerror(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red),
    );
  }

  void showAlertBoxOTP(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Completer<void> completer = Completer<void>();

        Future.delayed(Duration(seconds: 5)).then((_) {
          if (!completer.isCompleted) {
            Navigator.of(context).pop();
            completer.complete();
          }
        });

        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            AlertDialog(
              backgroundColor: const Color.fromARGB(52, 84, 17, 108),
              title: Center(
                child: Text(
                  "OTP",
                  style: TextStyle(color: Color.fromARGB(255, 26, 136, 30)),
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                ),
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      completer.complete();
                    },
                    child: Text("OK"),
                  ),
                ),
              ],
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              titlePadding: EdgeInsets.all(20),
              actionsPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust border radius
              ),
            ),
          ],
        );
      },
    );
  }
}
