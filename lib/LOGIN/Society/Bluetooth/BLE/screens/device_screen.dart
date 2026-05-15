import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:LactosureConnect/Constant/core/extensions/getx_custom_snackbar.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/BLE/screens/machine_Settings/offser_correction.dart.dart';
import 'package:LactosureConnect/Constant/datas/containers/containersble.dart';
import 'package:LactosureConnect/Constant/screens/authentication_screen/auth_screen.dart';
import 'package:LactosureConnect/LOGIN/Society/dashboard/dashboard.dart';
import 'package:LactosureConnect/LOGIN/Society/reports/localreport.dart';
import 'package:LactosureConnect/widgets/background_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/characteristic_tile.dart';
import '../widgets/descriptor_tile.dart';
import '../utils/snackbar.dart';
import '../utils/extra.dart';

String UniqueId = EmailAndPasswordAuthForm.uidcontroller.text;
String fatWithPercentage = '';
String snfWithPercentage = '';
String clrWithPercentage = '';
String waterWithPercentage = '';
String tempWithPercentage = '';
String proteinWithPercentage = '';
String saltWithPercentage = '';
String lactosWithPercentage = '';
String bonusWithPercentage = '';
String quantityWithPercentage = '';
String rateWithPercentage = '';
String totalamountWithPercentage = '';
String farmerid = '';
String machineid = '';
int x = 0;
String channel = '';
String fatWithPercentage1 = '';
String snfWithPercentage1 = '';
String clrWithPercentage1 = '';
String waterWithPercentage1 = '';
String tempWithPercentage1 = '';
String proteinWithPercentage1 = '';
String saltWithPercentage1 = '';
String lactosWithPercentage1 = '';
String bonusWithPercentage1 = '';
String quantityWithPercentage1 = '';
String rateWithPercentage1 = '';
String totalamountWithPercentage1 = '';
String farmerid1 = '';
String machineid1 = '';
double intValue = 0;
String channel1 = '';
int receivedotpLength = 0;
bool alertShown = false;
int write = 0;
int receivedTextLength = 0;
String finalotp = '';
String passworduserHex = '';
String passwordsuperHex = '';
String passwordwifiHex = '';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];
  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  bool shouldDisplayServiceTiles = false;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;
  StreamController<List<int>> fatstreamer = StreamController<List<int>>();
  StreamController<List<int>> snfstreamer = StreamController<List<int>>();
  StreamController<List<int>> clrstreamer = StreamController<List<int>>();
  StreamController<List<int>> waterstreamer = StreamController<List<int>>();
  StreamController<List<int>> tempstreamer = StreamController<List<int>>();
  StreamController<List<int>> proteinstreamer = StreamController<List<int>>();
  StreamController<List<int>> lactosstreamer = StreamController<List<int>>();
  StreamController<List<int>> saltstreamer = StreamController<List<int>>();
  StreamController<List<int>> bonusstreamer = StreamController<List<int>>();
  StreamController<List<int>> quantitystreamer = StreamController<List<int>>();
  StreamController<List<int>> ratestreamer = StreamController<List<int>>();
  StreamController<List<int>> totalamountstreamer =
      StreamController<List<int>>();
  StreamController<List<int>> farmeridstreamer = StreamController<List<int>>();
  StreamController<List<int>> machineidstreamer = StreamController<List<int>>();
  StreamController<List<int>> otpstreamer = StreamController<List<int>>();
  StreamController<List<int>> otplengthstreamer = StreamController<List<int>>();
  StreamController<List<int>> passworduserHexstreamer =
      StreamController<List<int>>();
  StreamController<List<int>> passwordsuperHexstreamer =
      StreamController<List<int>>();
  StreamController<List<int>> passwordwifiHexstreamer =
      StreamController<List<int>>();
  String data = '';
  bool isLoading = false;
  String otp = '';
  String otps = '';

  List<String> resultBoxes = List.generate(18, (index) => '');
  @override
  void initState() {
    super.initState();
    _connectionStateSubscription =
        widget.device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _services = []; // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await widget.device.readRssi();
      }
      if (mounted) {
        setState(() {});
      }
    });
    _mtuSubscription = widget.device.mtu.listen((value) {
      _mtuSize = value;
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    });
    _isConnectingSubscription = widget.device.isConnecting.listen((value) {
      _isConnecting = value;
      if (mounted) {
        setState(() {});
      }
      print('this is the place   $value');
    });
    _isDisconnectingSubscription =
        widget.device.isDisconnecting.listen((value) {
      _isDisconnecting = value;
      if (mounted) {
        setState(() {});
      }
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      onRequestMtuPressed();
    });
    Future.delayed(Duration(milliseconds: 500), () {
      onDiscoverServicesPressed();
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    fatstreamer.close();
    snfstreamer.close();
    clrstreamer.close();
    waterstreamer.close();
    tempstreamer.close();
    proteinstreamer.close();
    lactosstreamer.close();
    saltstreamer.close();
    bonusstreamer.close();
    quantitystreamer.close();
    ratestreamer.close();
    totalamountstreamer.close();
    farmeridstreamer.close();
    machineidstreamer.close();
    otpstreamer.close();
    otplengthstreamer.close();
    passworduserHexstreamer.close();
    passwordsuperHexstreamer.close();
    passwordwifiHexstreamer.close();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Future onConnectPressed() async {
    try {
      await widget.device.connectAndUpdateStream();
      Get.customSnackBar(
        statusType: StatusType.success,
        designType: SnackDesign.iconFocus,
        title: 'Bluetooth Connected',
        compact: true,
      );
      Future.delayed(Duration(milliseconds: 0), () {
        onRequestMtuPressed();
      });
      Future.delayed(Duration(milliseconds: 0), () {
        onDiscoverServicesPressed();
      });
    } catch (e) {
      if (e is FlutterBluePlusException &&
          e.code == FbpErrorCode.connectionCanceled.index) {
      } else {}
    }
  }

  Future onCancelPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream(queue: false);
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.iconFocus,
        title: 'Bluetooth disconnected',
        compact: true,
      );
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
    }
  }

  Future onDisconnectPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream();
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Bluetooth disconnected',
        compact: true,
      );
    } catch (e) {}
  }

  Future onDiscoverServicesPressed() async {
    if (mounted) {
      setState(() {
        _isDiscoveringServices = true;
      });
    }
    try {
      _services = await widget.device.discoverServices();
    } catch (e) {
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.iconFocus,
        title: 'Connection unavailable',
        compact: true,
      );
    }
    if (mounted) {
      setState(() {
        _isDiscoveringServices = false;
      });
    }
  }

  Future onRequestMtuPressed() async {
    try {
      await widget.device.requestMtu(223, predelay: 0);
    } catch (e) {}
  }

  List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
    List<Widget> characteristicTiles = [];
    if (_services.length >= 3) {
      BluetoothService thirdService = _services[2];
      characteristicTiles = thirdService.characteristics
          .map((c) => _buildCharacteristicTile(c))
          .toList();
    }
    return characteristicTiles;
  }

  String bytesToHex(List<int> value) {
    return value.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  String hexToDecimal(String hexString) {
    try {
      BigInt decimalValue = BigInt.parse(hexString, radix: 16);
      return decimalValue.toString();
    } catch (e) {
      return 'Invalid Hex';
    }
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

  CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
    c.lastValueStream.listen((value) {
      fatstreamer.add(value);
      snfstreamer.add(value);
      clrstreamer.add(value);
      waterstreamer.add(value);
      tempstreamer.add(value);
      proteinstreamer.add(value);
      lactosstreamer.add(value);
      saltstreamer.add(value);
      bonusstreamer.add(value);
      ratestreamer.add(value);
      totalamountstreamer.add(value);
      quantitystreamer.add(value);
      farmeridstreamer.add(value);
      machineidstreamer.add(value);
      otpstreamer.add(value);
      otplengthstreamer.add(value);
      data = value.toString();
      passworduserHexstreamer.add(value);
      passwordsuperHexstreamer.add(value);
      passwordwifiHexstreamer.add(value);
      String receivedText = String.fromCharCodes(value);
      otp = bytesToHex(value);
      print(receivedText);
      print(otp);
      receivedotpLength = otp.length;
      receivedTextLength = receivedText.length;
      if (receivedotpLength == 20) {
        String PassworduserHex1 = otp.substring(6, 10);
        String PasswordsuperHex1 = otp.substring(10, 14);
        String PasswordwifiHex1 = otp.substring(14, 18);
        String PasswordwifiHex2 =
            'User Pass            = ${hexToDecimal(PassworduserHex1)}\nSupervisor Pass = ${hexToDecimal(PasswordsuperHex1)}\nWifi Pass             = ${hexToDecimal(PasswordwifiHex1)}';
        passworduserHex = PasswordwifiHex2;
        passwordsuperHex = hexToDecimal(PasswordsuperHex1);
        passwordwifiHex = hexToDecimal(PasswordwifiHex1);
        print('user=$passworduserHex');
        print('super=$passwordsuperHex');
        print('wifi=$passwordwifiHex');
      }
      List<String> splitData = receivedText.split('|');
      List<String> resultBoxes = List.filled(18, '');
      for (int i = 0; i < min(splitData.length - 0, 18); i++) {
        resultBoxes[i] = splitData[i + 0];
      }
      finalotp = hexToDecimalAtPosition(otp, 8, 4);
      String fatValue = resultBoxes.isNotEmpty ? resultBoxes[3] : '0%';
      String f = fatValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double fatDouble = double.tryParse(f) ?? 0.0;
      if (fatDouble == 0.0) {
        String formattedFat = fatDouble.toStringAsFixed(0);
        fatWithPercentage1 = formattedFat;
        fatWithPercentage = '$formattedFat %';
      } else {
        String formattedFat = fatDouble.toStringAsFixed(1);
        fatWithPercentage1 = formattedFat;
        fatWithPercentage = '$formattedFat %';
      }
      String snfValue = resultBoxes.isNotEmpty ? resultBoxes[4] : '0%';
      String snf = snfValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double snfDouble = double.tryParse(snf) ?? 0.0;
      if (snfDouble == 0.0) {
        String formattedsnf = snfDouble.toStringAsFixed(0);
        snfWithPercentage1 = formattedsnf;
        snfWithPercentage = '$formattedsnf %';
      } else {
        String formattedsnf = snfDouble.toStringAsFixed(1);
        snfWithPercentage1 = formattedsnf;
        snfWithPercentage = '$formattedsnf %';
      }
      String clrValue = resultBoxes.isNotEmpty ? resultBoxes[5] : '0';
      String c = clrValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double clrDouble = double.tryParse(c) ?? 0.0;
      if (clrDouble == 0.0) {
        String formattedc = clrDouble.toStringAsFixed(0);
        clrWithPercentage1 = formattedc;
        clrWithPercentage = '$formattedc';
      } else {
        String formattedc = clrDouble.toStringAsFixed(1);
        clrWithPercentage1 = formattedc;
        clrWithPercentage = '$formattedc';
      }
      String wValue = resultBoxes.isNotEmpty ? resultBoxes[9] : '0%';
      String w = wValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double wDouble = double.tryParse(w) ?? 0.0;
      if (wDouble == 0.0) {
        String formattedw = wDouble.toStringAsFixed(0);
        waterWithPercentage1 = formattedw;
        waterWithPercentage = '$formattedw %';
      } else {
        String formattedw = wDouble.toStringAsFixed(1);
        waterWithPercentage1 = formattedw;
        waterWithPercentage = '$formattedw %';
      }
      String tValue = resultBoxes.isNotEmpty ? resultBoxes[10] : '0%';
      String t = tValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double tDouble = double.tryParse(t) ?? 0.0;
      if (tDouble == 0.0) {
        String formattedt = tDouble.toStringAsFixed(0);
        tempWithPercentage1 = formattedt;
        tempWithPercentage = '$formattedt %';
      } else {
        String formattedt = tDouble.toStringAsFixed(1);
        tempWithPercentage1 = formattedt;
        tempWithPercentage = '$formattedt %';
      }
      String pValue = resultBoxes.isNotEmpty ? resultBoxes[6] : '0%';
      String p = pValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double pDouble = double.tryParse(p) ?? 0.0;
      if (pDouble == 0.0) {
        String formattedp = pDouble.toStringAsFixed(0);
        proteinWithPercentage1 = formattedp;
        proteinWithPercentage = '$formattedp %';
      } else {
        String formattedp = pDouble.toStringAsFixed(1);
        proteinWithPercentage1 = formattedp;
        proteinWithPercentage = '$formattedp %';
      }
      String lValue = resultBoxes.isNotEmpty ? resultBoxes[7] : '0%';
      String l = lValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double lDouble = double.tryParse(l) ?? 0.0;
      if (lDouble == 0.0) {
        String formattedl = lDouble.toStringAsFixed(0);
        lactosWithPercentage1 = formattedl;
        lactosWithPercentage = '$formattedl %';
      } else {
        String formattedl = lDouble.toStringAsFixed(1);
        lactosWithPercentage1 = formattedl;
        lactosWithPercentage = '$formattedl %';
      }
      String sValue = resultBoxes.isNotEmpty ? resultBoxes[8] : '0%';
      String s = sValue.replaceAll(RegExp(r'[^0-9.]'), '');
      double sDouble = double.tryParse(s) ?? 0.0;
      if (sDouble == 0.0) {
        String formatteds = sDouble.toStringAsFixed(0);
        saltWithPercentage1 = formatteds;
        saltWithPercentage = '$formatteds %';
      } else {
        String formatteds = sDouble.toStringAsFixed(1);
        saltWithPercentage1 = formatteds;
        saltWithPercentage = '$formatteds %';
      }
      String q = resultBoxes.isNotEmpty ? resultBoxes[12] : '0%';
      String qu = q.replaceAll(RegExp(r'[^0-9.]'), '');
      double qua = double.tryParse(qu) ?? 0.0;
      if (qua == 0.0) {
        String quant = qua.toStringAsFixed(0);
        quantityWithPercentage1 = quant;
        quantityWithPercentage = '$quant';
      } else {
        String quant = qua.toStringAsFixed(2);
        quantityWithPercentage1 = quant;
        quantityWithPercentage = '$quant';
      }
      String a = resultBoxes.isNotEmpty ? resultBoxes[13] : '0 Rs/-';
      String am = a.replaceAll(RegExp(r'[^0-9.]'), '');
      double amo = double.tryParse(am) ?? 0.0;
      if (amo == 0.0) {
        String amou = amo.toStringAsFixed(0);
        totalamountWithPercentage1 = amou;
        totalamountWithPercentage = '$amou';
      } else {
        String amou = amo.toStringAsFixed(2);
        totalamountWithPercentage1 = amou;
        totalamountWithPercentage = '$amou';
      }
      String r = resultBoxes.isNotEmpty ? resultBoxes[14] : '0 Rs/-';
      String ra = r.replaceAll(RegExp(r'[^0-9.]'), '');
      double rat = double.tryParse(ra) ?? 0.0;
      if (rat == 0.0) {
        String rate = rat.toStringAsFixed(0);
        rateWithPercentage1 = rate;
        rateWithPercentage = '$rate';
      } else {
        String rate = rat.toStringAsFixed(2);
        rateWithPercentage1 = rate;
        rateWithPercentage = '$rate';
      }
      String b = resultBoxes.isNotEmpty ? resultBoxes[15] : '0 Rs/-';
      String bo = b.replaceAll(RegExp(r'[^0-9.]'), '');
      double bon = double.tryParse(bo) ?? 0.0;
      if (bon == 0.0) {
        String bonus = bon.toStringAsFixed(0);
        bonusWithPercentage1 = bonus;
        bonusWithPercentage = '$bonus';
      } else {
        String bonus = bon.toStringAsFixed(2);
        bonusWithPercentage1 = bonus;
        bonusWithPercentage = '$bonus';
      }
      String idfarmer = resultBoxes.isNotEmpty ? resultBoxes[11] : '0 Rs/-';
      String fid = idfarmer.replaceAll(RegExp(r'[^0-9.]'), '');
      int parsedFid = int.tryParse(fid) ?? 0;
      farmerid = parsedFid.toString();
      String idm = resultBoxes.isNotEmpty ? resultBoxes[16] : '0 Rs/-';
      String idma = idm.replaceAll(RegExp(r'[^0-9.]'), '');
      int idmac = int.tryParse(idma) ?? 0;
      machineid = idmac.toString();
      channel = resultBoxes.isNotEmpty ? resultBoxes[2] : '';
      print(intValue);
    });
    print(receivedTextLength);
    print(receivedotpLength);
    return CharacteristicTile(
      characteristic: c,
      descriptorTiles:
          c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
    );
  }

  Widget buildSpinner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildRemoteId(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${widget.device.remoteId}'),
    );
  }

  Widget buildRssiTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected
            ? IconButton(
                onPressed: () {
                  onCancelPressed();
                },
                icon: Icon(Icons.bluetooth_connected,
                    color: const Color.fromARGB(255, 255, 255, 255)),
              )
            : IconButton(
                onPressed: () {
                  onConnectPressed();
                },
                icon: Icon(Icons.bluetooth_disabled, color: Colors.grey),
              ),
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (_isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        TextButton(
          child: const Text("Get Services"),
          onPressed: onDiscoverServicesPressed,
        ),
        const IconButton(
          icon: SizedBox(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
            width: 18.0,
            height: 18.0,
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget circularLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildMtuTile(BuildContext context) {
    return ListTile(
        title: const Text('MTU Size'),
        subtitle: Text('$_mtuSize bytes'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onRequestMtuPressed,
        ));
  }

  Widget buildConnectButton(BuildContext context) {
    return Row(children: [
      if (_isConnecting || _isDisconnecting) buildSpinner(context),
      TextButton(
          onPressed: _isConnecting
              ? onCancelPressed
              : (isConnected ? onDisconnectPressed : onConnectPressed),
          child: Text(
            _isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
            style: Theme.of(context)
                .primaryTextTheme
                .labelLarge
                ?.copyWith(color: Colors.white),
          ))
    ]);
  }

  Future<void> _saveToLocalStorage(BuildContext context) async {
    if (fatWithPercentage1 != 0) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<Map<String, dynamic>> savedData = [];
        String? existingData = prefs.getString('table_data');
        if (existingData != null) {
          savedData =
              List<Map<String, dynamic>>.from(json.decode(existingData));
        }
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        savedData.add({
          'Save Date': formattedDate,
          'Society ID': UniqueId,
          'FarmerId': farmerid,
          'Machine ID': machineid,
          'Channel': channel,
          'FAT': fatWithPercentage1,
          'SNF': snfWithPercentage1,
          'CLR': clrWithPercentage1,
          'Protien': proteinWithPercentage1,
          'Lactos': lactosWithPercentage1,
          'Salt': saltWithPercentage1,
          'Water': waterWithPercentage1,
          'Temperature': tempWithPercentage1,
          'Rate': rateWithPercentage1,
          'Quantity': quantityWithPercentage1,
          'Total Amount': totalamountWithPercentage1,
          'Bonus': bonusWithPercentage1,
        });
        await prefs.setString('table_data', json.encode(savedData));
        fatWithPercentage1 = '0';
        showSuccessNotification(context);
      } catch (e) {
        showSnackbarerror(context, 'Error');
      }
    }
  }

  void showAlertBoxOTP(BuildContext context, String message) {
    if (alertShown) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        alertShown = false;
        Completer<void> completer = Completer<void>();
        Future.delayed(Duration(seconds: 5)).then((_) {
          if (!completer.isCompleted) {
            alertShown = false;
            Navigator.of(context).pop();
            completer.complete();
            receivedotpLength = 0;
          }
        });
        return AlertDialog(
          title: Center(
            child: Text(
              "OTP",
              style: TextStyle(color: Color.fromARGB(255, 26, 136, 30)),
            ),
          ),
          content: Container(
            height: 50,
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
                  alertShown = false;
                  Navigator.of(context).pop();
                  completer.complete();
                },
                child: Text("OK"),
              ),
            ),
          ],
          backgroundColor: Color.fromARGB(255, 17, 18, 17),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          titlePadding: EdgeInsets.all(20),
          actionsPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  void showSuccessNotification(BuildContext context) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Collection Saved',
      'Successfull',
      importance: Importance.high,
      priority: Priority.high,
      color: Color.fromARGB(255, 16, 135, 75),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Collection saved Successfully',
      '',
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .008;
    double y = fontsize * .03;
    double w = iconsize * 0.04;
    return ScaffoldMessenger(
        key: Snackbar.snackBarKeyC,
        child: BackgroundScaffolddash(
            resizeToAvoidBottomInset: true,
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            backgroundBlur: 0,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              actions: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.04, screenHeight * 0.007, 0, 0),
                  child: StreamBuilder<List<int>>(
                    stream: machineidstreamer.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String receivedText =
                            String.fromCharCodes(snapshot.data!);
                        return Container(
                          width: .4.sw,
                          height: .14.sw,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(0, 254, 0, 0),
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 0.01),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.04,
                                          screenHeight * 0.009,
                                          0,
                                          0),
                                      child: Text(
                                        'Machine ID = $machineid',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontsize * .008,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.r,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Text('', style: TextStyle(color: Colors.amber));
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, screenHeight * 0.007,
                      screenWidth * 0.0, screenWidth * 0.000),
                  child: StreamBuilder<List<int>>(
                    stream: farmeridstreamer.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String receivedText =
                            String.fromCharCodes(snapshot.data!);
                        return Container(
                          width: .4.sw,
                          height: .14.sw,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(0, 133, 35, 35),
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 0.01),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.04,
                                          screenHeight * 0.009,
                                          0,
                                          0),
                                      child: Text(
                                        'Farmer ID = $farmerid',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontsize * .008,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.r,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Text('', style: TextStyle(color: Colors.amber));
                      }
                    },
                  ),
                ),
                buildRssiTile(context),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.04, screenHeight * 0.007, 0, 0),
                        child: StreamBuilder<List<int>>(
                          stream: otpstreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print('otplenghth====$receivedotpLength');
                              if (receivedotpLength == 14) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (alertShown) {
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      alertShown = false;
                                      Completer<void> completer =
                                          Completer<void>();
                                      Future.delayed(Duration(seconds: 5))
                                          .then((_) {
                                        if (!completer.isCompleted) {
                                          setState(() {
                                            receivedotpLength = 0;
                                          });
                                          alertShown = false;
                                          Navigator.of(context).pop();
                                          completer.complete();
                                        }
                                      });
                                      return Stack(
                                        children: [
                                          BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                          AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    52, 84, 17, 108),
                                            title: Center(
                                              child: Text(
                                                "OTP",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 26, 136, 30)),
                                              ),
                                            ),
                                            content: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: Center(
                                                child: Text(
                                                  finalotp,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              Center(
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      receivedotpLength = 0;
                                                    });
                                                    alertShown = false;
                                                    Navigator.of(context).pop();
                                                    completer.complete();
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ),
                                            ],
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                            titlePadding: EdgeInsets.all(20),
                                            actionsPadding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                                return Container();
                              } else {
                                return Text('');
                              }
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.04,
                          screenHeight * 0.007,
                          0,
                          0,
                        ),
                        child: StreamBuilder<List<int>>(
                          stream: passworduserHexstreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print('otplenghth====$receivedotpLength');
                              if (receivedotpLength == 20) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (alertShown) {
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      alertShown = true;
                                      Completer<void> completer =
                                          Completer<void>();
                                      Future.delayed(Duration(seconds: 10))
                                          .then((_) {
                                        if (!completer.isCompleted) {
                                          setState(() {
                                            receivedotpLength = 0;
                                          });
                                          alertShown = false;
                                          Navigator.of(context).pop();
                                          completer.complete();
                                        }
                                      });
                                      return Stack(
                                        children: [
                                          BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                          AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    52, 84, 17, 108),
                                            title: Center(
                                              child: Text(
                                                "Machine Passcode",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 244, 6, 6),
                                                ),
                                              ),
                                            ),
                                            content: Container(
                                              height: 100,
                                              child: Center(
                                                child: Text(
                                                  passworduserHex,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              Center(
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      receivedotpLength = 0;
                                                    });
                                                    alertShown = false;
                                                    Navigator.of(context).pop();
                                                    completer.complete();
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ),
                                            ],
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                            titlePadding: EdgeInsets.all(20),
                                            actionsPadding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                                return Container();
                              } else {
                                return Text('');
                              }
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.03, screenHeight * 0.015, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FatContainer(),
                            SizedBox(
                              width: screenWidth * 0.023,
                            ),
                            SnfContainer(),
                            SizedBox(
                              width: screenWidth * 0.023,
                            ),
                          ],
                        ),
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
                            screenWidth * 0.528, screenHeight * 0.49, 0, 0),
                        child: Result(),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.085, screenHeight * 0.012, 0, 0),
                        child: StreamBuilder<List<int>>(
                          stream: fatstreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String receivedText =
                                  String.fromCharCodes(snapshot.data!);
                              intValue = 0.0;
                              intValue = double.parse(fatWithPercentage1);
                              print(fatWithPercentage);
                              print(fatWithPercentage1);
                              print('intvalue=$intValue');
                              if (intValue != 0.0) {
                                _saveToLocalStorage(context);
                                intValue = 0.0;
                              }
                              return Container(
                                width: screenWidth * .41,
                                height: screenHeight * .19,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(0, 147, 44, 6),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: screenHeight * 0.01),
                                      Row(
                                        children: [],
                                      ),
                                      SizedBox(height: screenHeight * 0.05),
                                      Text(
                                        fatWithPercentage == 0.0
                                            ? ''
                                            : fatWithPercentage,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: y,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.515, screenHeight * 0.012, 0, 0),
                        child: StreamBuilder<List<int>>(
                          stream: snfstreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String receivedText =
                                  String.fromCharCodes(snapshot.data!);
                              return Container(
                                width: screenWidth * .41,
                                height: screenHeight * .19,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(0, 147, 44, 6),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: screenHeight * 0.01),
                                      SizedBox(height: screenHeight * 0.05),
                                      Text(
                                        snfWithPercentage == 0.0
                                            ? '0%'
                                            : snfWithPercentage,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: y,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
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
                            StreamBuilder<List<int>>(
                              stream: proteinstreamer.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  String receivedText =
                                      String.fromCharCodes(snapshot.data!);
                                  return Container(
                                    width: screenWidth * .268,
                                    height: screenHeight * .113,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(0, 112, 27, 113),
                                      borderRadius:
                                          BorderRadius.circular(10.0.r),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: screenHeight * 0.05),
                                          Text(
                                            proteinWithPercentage == 0.0
                                                ? '0%'
                                                : proteinWithPercentage,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontsize * .015,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Text('',
                                      style: TextStyle(color: Colors.amber));
                                }
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            StreamBuilder<List<int>>(
                              stream: lactosstreamer.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  String receivedText =
                                      String.fromCharCodes(snapshot.data!);
                                  return Container(
                                    width: screenWidth * .268,
                                    height: screenHeight * .113,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(0, 112, 27, 113),
                                      borderRadius:
                                          BorderRadius.circular(10.0.r),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: screenHeight * 0.05),
                                          Text(
                                            lactosWithPercentage == 0.0
                                                ? '0%'
                                                : lactosWithPercentage,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontsize * .015,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Text('',
                                      style: TextStyle(color: Colors.amber));
                                }
                              },
                            ),
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
                                StreamBuilder<List<int>>(
                                  stream: clrstreamer.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String receivedText =
                                          String.fromCharCodes(snapshot.data!);
                                      return Container(
                                        width: screenWidth * .268,
                                        height: screenHeight * .113,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              0, 6, 147, 13),
                                          borderRadius:
                                              BorderRadius.circular(10.0.r),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: screenHeight * 0.05),
                                              Text(
                                                clrWithPercentage == 0.0
                                                    ? '0%'
                                                    : clrWithPercentage,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontsize * .015,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('',
                                          style:
                                              TextStyle(color: Colors.amber));
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: screenWidth * 0.018,
                                ),
                                StreamBuilder<List<int>>(
                                  stream: waterstreamer.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String receivedText =
                                          String.fromCharCodes(snapshot.data!);
                                      return Container(
                                        width: screenWidth * .268,
                                        height: screenHeight * .113,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              0, 6, 128, 147),
                                          borderRadius:
                                              BorderRadius.circular(10.0.r),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: screenHeight * 0.05),
                                              Text(
                                                waterWithPercentage == 0.0
                                                    ? '0%'
                                                    : waterWithPercentage,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontsize * .015,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('',
                                          style:
                                              TextStyle(color: Colors.amber));
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Row(
                              children: [
                                StreamBuilder<List<int>>(
                                  stream: saltstreamer.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String receivedText =
                                          String.fromCharCodes(snapshot.data!);
                                      return Container(
                                        width: screenWidth * .268,
                                        height: screenHeight * .113,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              0, 112, 27, 113),
                                          borderRadius:
                                              BorderRadius.circular(10.0.r),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: screenHeight * 0.05),
                                              Text(
                                                saltWithPercentage == 0.0
                                                    ? '0%'
                                                    : saltWithPercentage,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontsize * .015,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('',
                                          style:
                                              TextStyle(color: Colors.amber));
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: screenWidth * 0.018,
                                ),
                                StreamBuilder<List<int>>(
                                  stream: tempstreamer.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String receivedText =
                                          String.fromCharCodes(snapshot.data!);
                                      return Container(
                                        width: screenWidth * .268,
                                        height: screenHeight * .113,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              0, 147, 83, 6),
                                          borderRadius:
                                              BorderRadius.circular(10.0.r),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: screenHeight * 0.05),
                                              Text(
                                                tempWithPercentage == 0.0
                                                    ? '0%'
                                                    : tempWithPercentage,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontsize * .015,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('',
                                          style:
                                              TextStyle(color: Colors.amber));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.084, screenHeight * 0.455, 0, 0),
                        child: Container(
                          width: screenWidth * 0.84,
                          child: Divider(
                            color: const Color.fromARGB(255, 110, 113, 109),
                            thickness:
                                MediaQuery.of(context).size.width * 0.004,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.48, screenHeight * 0.47, 0, 0),
                        child: Container(
                          height: screenHeight * 0.21,
                          child: VerticalDivider(
                            color: const Color.fromARGB(255, 110, 113, 109),
                            thickness:
                                MediaQuery.of(context).size.width * 0.004,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.528, screenHeight * 0.49, 0, 0),
                        child: StreamBuilder<List<int>>(
                          stream: totalamountstreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String receivedText =
                                  String.fromCharCodes(snapshot.data!);
                              return Container(
                                width: screenWidth * .4,
                                height: screenHeight * .175,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 200, 13, 13),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: screenHeight * 0.065),
                                      Text(
                                        totalamountWithPercentage == 0.0
                                            ? '0%'
                                            : totalamountWithPercentage,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontsize * .022,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.09, screenHeight * 0.609, 0, 0),
                        child: StreamBuilder<List<int>>(
                          stream: ratestreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String receivedText =
                                  String.fromCharCodes(snapshot.data!);
                              return Container(
                                width: screenWidth * .37,
                                height: screenHeight * .055,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 6, 147, 13),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                screenWidth * 0.2,
                                                screenHeight * 0.017,
                                                0,
                                                0),
                                            child: Text(
                                              ' $rateWithPercentage',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: fontsize * .008,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5.r,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.09, screenHeight * 0.545, 0, 0),
                        child: StreamBuilder<List<int>>(
                          stream: quantitystreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String receivedText =
                                  String.fromCharCodes(snapshot.data!);
                              return Container(
                                width: screenWidth * .37,
                                height: screenHeight * .055,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 147, 116, 6),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                screenWidth * 0.2,
                                                screenHeight * 0.017,
                                                0,
                                                0),
                                            child: Text(
                                              '$quantityWithPercentage',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: fontsize * .008,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.r,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.09, screenHeight * 0.48, 0, 0),
                        child: StreamBuilder<List<int>>(
                          stream: bonusstreamer.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String receivedText =
                                  String.fromCharCodes(snapshot.data!);
                              return Container(
                                width: screenWidth * .37,
                                height: screenHeight * .055,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 6, 147, 147),
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                screenWidth * 0.2,
                                                screenHeight * 0.017,
                                                0,
                                                0),
                                            child: Text(
                                              '$bonusWithPercentage',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: fontsize * .008,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.r,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text('',
                                  style: TextStyle(color: Colors.amber));
                            }
                          },
                        ),
                      ),
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
                              setState(() {
                                intValue = 0;
                                write = 1;
                                print(write);
                                _connectionStateSubscription = widget
                                    .device.connectionState
                                    .listen((state) async {
                                  _connectionState = state;
                                  if (state ==
                                      BluetoothConnectionState.connected) {
                                    _services = [];
                                  }
                                  if (state ==
                                          BluetoothConnectionState.connected &&
                                      _rssi == null) {
                                    _rssi = await widget.device.readRssi();
                                  }
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _mtuSubscription =
                                    widget.device.mtu.listen((value) {
                                  _mtuSize = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _isConnectingSubscription =
                                    widget.device.isConnecting.listen((value) {
                                  _isConnecting = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  print('this is the place   $value');
                                });
                                Future.delayed(Duration(milliseconds: 500), () {
                                  onDiscoverServicesPressed();
                                });
                              });
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
                                SizedBox(width: screenWidth * 0.01),
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
                              setState(() {
                                write = 2;
                                print(write);
                                _connectionStateSubscription = widget
                                    .device.connectionState
                                    .listen((state) async {
                                  _connectionState = state;
                                  if (state ==
                                      BluetoothConnectionState.connected) {
                                    _services = [];
                                  }
                                  if (state ==
                                          BluetoothConnectionState.connected &&
                                      _rssi == null) {
                                    _rssi = await widget.device.readRssi();
                                  }
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _mtuSubscription =
                                    widget.device.mtu.listen((value) {
                                  _mtuSize = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _isConnectingSubscription =
                                    widget.device.isConnecting.listen((value) {
                                  _isConnecting = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  print('this is the place   $value');
                                });
                                Future.delayed(Duration(milliseconds: 500), () {
                                  onDiscoverServicesPressed();
                                });
                              });
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
                                SizedBox(width: screenWidth * 0.01),
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
                              String hexCommand = '4004010A004F';
                              print('stop');
                            },
                            child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  write = 4;
                                  _connectionStateSubscription = widget
                                      .device.connectionState
                                      .listen((state) async {
                                    _connectionState = state;
                                    if (state ==
                                        BluetoothConnectionState.connected) {
                                      _services = [];
                                    }
                                    if (state ==
                                            BluetoothConnectionState
                                                .connected &&
                                        _rssi == null) {
                                      _rssi = await widget.device.readRssi();
                                    }
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  });
                                  _isConnectingSubscription = widget
                                      .device.isConnecting
                                      .listen((value) {
                                    _isConnecting = value;
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  });
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    onDiscoverServicesPressed();
                                  });
                                });
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
                                  SizedBox(width: screenWidth * 0.01),
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
                              setState(() {
                                write = 3;
                                print(write);

                                _connectionStateSubscription = widget
                                    .device.connectionState
                                    .listen((state) async {
                                  _connectionState = state;
                                  if (state ==
                                      BluetoothConnectionState.connected) {
                                    _services = [];
                                  }
                                  if (state ==
                                          BluetoothConnectionState.connected &&
                                      _rssi == null) {
                                    _rssi = await widget.device.readRssi();
                                  }
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _mtuSubscription =
                                    widget.device.mtu.listen((value) {
                                  _mtuSize = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _isConnectingSubscription =
                                    widget.device.isConnecting.listen((value) {
                                  _isConnecting = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  print('this is the place   $value');
                                });
                                Future.delayed(Duration(milliseconds: 500), () {
                                  onDiscoverServicesPressed();
                                });
                              });
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
                                SizedBox(width: screenWidth * 0.01),
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
                                SizedBox(width: 4.r),
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
                                write = 5;
                                _connectionStateSubscription = widget
                                    .device.connectionState
                                    .listen((state) async {
                                  _connectionState = state;
                                  if (state ==
                                      BluetoothConnectionState.connected) {
                                    _services = [];
                                  }
                                  if (state ==
                                          BluetoothConnectionState.connected &&
                                      _rssi == null) {
                                    _rssi = await widget.device.readRssi();
                                  }
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _mtuSubscription =
                                    widget.device.mtu.listen((value) {
                                  _mtuSize = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                                _isConnectingSubscription =
                                    widget.device.isConnecting.listen((value) {
                                  _isConnecting = value;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  print('this is the place   $value');
                                });
                                Future.delayed(Duration(milliseconds: 500), () {
                                  onDiscoverServicesPressed();
                                });
                              });
                              print(test);
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
                                Icon(Icons.password_rounded, size: 10),
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  'Password',
                                  style: TextStyle(fontSize: 8),
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
                              print('stop');
                            },
                            child: TextButton(
                              onPressed: () async {},
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
                                  SizedBox(width: screenWidth * 0.01),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OfferCorrection(
                                    device: widget.device,
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(10.r, 25.r),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(80, 199, 190, 17),
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
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.feed_outlined, size: 8),
                                SizedBox(width: screenWidth * 0.01),
                                const Text(
                                  'Correction',
                                  style: TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 2, screenHeight * .1, 0, 0),
                        child: SizedBox(
                          width: screenWidth * .195,
                          height: screenHeight * .06,
                          child: TextButton(
                            onPressed: () async {},
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(10.r, 25.r),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(0, 199, 190, 17),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(0, 18, 123, 34)
                                        .withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: const BorderSide(
                                    color: Color.fromARGB(0, 127, 125, 125),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ..._buildServiceTiles(context, widget.device),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
