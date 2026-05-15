import 'dart:async';
import 'dart:math';

import 'package:LactosureConnect/LOGIN/Society/Bluetooth/BLE/screens/device_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import "../utils/snackbar.dart";

import "descriptor_tile.dart";

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  CharacteristicTile(
      {Key? key, required this.characteristic, required this.descriptorTiles})
      : super(key: key);
  List<String> resultBoxes = List.generate(18, (index) => '');
  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _value = [];

  List<String> resultBoxes = List.generate(18, (index) => '');
  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    onSubscribePressed();
    print('hellooooooo');
    _lastValueSubscription =
        widget.characteristic.lastValueStream.listen((value) {
      _value = value;
      if (mounted) {
        setState(() {});
      }
      print('this issssss=====$write');
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothCharacteristic get c => widget.characteristic;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  Future onReadPressed() async {
    try {
      await c.read();
    } catch (e) {}
  }

  Future<void> onWritePressedtest() async {
    try {
      final List<int> data = hexStringToBytes("400407000043");
      await c.write(data, withoutResponse: c.properties.writeWithoutResponse);

      if (c.properties.read) {
        await c.read();
      }

      setState(() {
        write = 0;
      });
    } catch (e) {}
  }

  Future<void> onWritePressedclean() async {
    try {
      final List<int> data = hexStringToBytes("400409000A47");
      await c.write(data, withoutResponse: c.properties.writeWithoutResponse);

      if (c.properties.read) {
        await c.read();
      }

      setState(() {
        write = 0;
      });
    } catch (e) {}
  }

  Future<void> onWritePressedok() async {
    try {
      final List<int> data = hexStringToBytes("400401040041");
      await c.write(data, withoutResponse: c.properties.writeWithoutResponse);

      if (c.properties.read) {
        await c.read();
      }

      setState(() {
        write = 0;
      });
    } catch (e) {}
  }

  Future<void> onWritePressedexit() async {
    try {
      final List<int> data = hexStringToBytes("4004010A004F");
      await c.write(data, withoutResponse: c.properties.writeWithoutResponse);

      if (c.properties.read) {
        await c.read();
      }

      setState(() {
        write = 0;
      });
    } catch (e) {}
  }

  Future<void> onWritePressedstop() async {
    try {
      final List<int> data = hexStringToBytes("40044800000C");
      await c.write(data, withoutResponse: c.properties.writeWithoutResponse);

      if (c.properties.read) {
        await c.read();
      }

      setState(() {
        write = 0;
      });
    } catch (e) {}
  }

  List<int> hexStringToBytes(String hexString) {
    final List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 2) {
      bytes.add(int.parse(hexString.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  void onSubscribePressed() async {
    try {
      await c.setNotifyValue(true); // Always subscribe

      if (c.properties.read) {
        await c.read();
      }
      if (mounted) {
        setState(() {});
      }

      if (write == 1) {
        onWritePressedtest();
      }

      if (write == 2) {
        onWritePressedclean();
      }
      if (write == 3) {
        onWritePressedok();
      }
      if (write == 4) {
        onWritePressedexit();
      }

      if (write == 5) {
        onWritePressedstop();
      }
    } catch (e) {}
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: TextStyle(fontSize: 13));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: Text("Read"),
        onPressed: () async {
          await onReadPressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
        child: Text(withoutResp ? "WriteNoResp" : "Write"),
        onPressed: () async {
          await onWritePressedtest();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        onPressed: () async {
          onSubscribePressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(),
      children: widget.descriptorTiles,
    );
  }
}
