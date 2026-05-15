import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Easycorrection extends StatefulWidget {
  final BluetoothDevice device;
  const Easycorrection({
    super.key,
    required this.device,
  });
  @override
  State<Easycorrection> createState() => _EasycorrectionState();
}

class _EasycorrectionState extends State<Easycorrection> {
  final Map<String, TextEditingController> controllers = {};
  String selectedChannel = '1';
  BluetoothCharacteristic? writeChar;
  BluetoothCharacteristic? notifyChar;
  bool isProcessing = false;
  List<int> bleBuffer = [];
  List<List<int>> expectedReplyHeaders = [];
  Completer<List<int>>? pendingReply;
  @override
  void initState() {
    super.initState();
    initControllers();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        discoverServices();
      },
    );
  }

  void initControllers() {
    List<String> channels = ['1', '2', '3'];
    List<String> fields = ['fat', 'snf'];
    for (var ch in channels) {
      for (var field in fields) {
        controllers['ch${ch}_$field'] = TextEditingController();
      }
    }
  }

  Future<void> discoverServices() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      BluetoothCharacteristic? write;
      BluetoothCharacteristic? notify;
      for (var service in services) {
        for (var char in service.characteristics) {
          print("CHAR UUID : ${char.uuid}");
          if (char.properties.write || char.properties.writeWithoutResponse) {
            write = char;
          }
          if (char.properties.notify) {
            notify = char;
          }
        }
      }
      if (write != null && notify != null) {
        writeChar = write;
        notifyChar = notify;
        await notifyChar!.setNotifyValue(true);
        notifyChar!.lastValueStream.listen((data) {
          if (data.isEmpty) return;

          bleBuffer.addAll(data);

          // FIND START BYTE
          int start = bleBuffer.indexOf(0x40);
          if (start == -1) {
            bleBuffer.clear();
            return;
          }
          // REMOVE GARBAGE BEFORE 40
          if (start > 0) {
            bleBuffer.removeRange(0, start);
          }
          // WAIT MINIMUM SIZE
          if (bleBuffer.length < 3) {
            return;
          }
          // MACHINE FRAME SIZE
          // 40 + LEN + DATA + XOR
          int len = bleBuffer[1];
          int totalLength = len + 2;
          // WAIT FULL FRAME
          if (bleBuffer.length < totalLength) {
            return;
          }
          List<int> frame = bleBuffer.sublist(0, totalLength);
          print(
            "✅ FULL FRAME : ${frame.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}",
          );
          final isExpectedFrame = expectedReplyHeaders.isEmpty ||
              expectedReplyHeaders.any((header) =>
                  frame.length >= 3 &&
                  frame[1] == header[0] &&
                  frame[2] == header[1]);
          if (pendingReply != null &&
              !pendingReply!.isCompleted &&
              isExpectedFrame) {
            pendingReply!.complete(frame);
            expectedReplyHeaders = [];
          } else if (!isExpectedFrame) {
            print(
              '   ⏳ Ignoring unexpected frame: ${frame.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}',
            );
          }
          bleBuffer.removeRange(0, totalLength);
        });
        print("✅ WRITE CHARACTERISTIC FOUND");
        print("✅ NOTIFY CHARACTERISTIC FOUND");
      } else {
        print("❌ BLE characteristics not found");
      }
    } catch (e) {
      print("❌ SERVICE DISCOVERY ERROR : $e");
    }
  }

  List<int> hex(String s) {
    return s.split(' ').map((e) => int.parse(e, radix: 16)).toList();
  }

  int calculateXor(List<int> bytes) {
    int xor = 0;
    for (var b in bytes) {
      xor ^= b;
      print(
        "XOR STEP : "
        "${b.toRadixString(16).padLeft(2, '0').toUpperCase()} "
        "=> "
        "${xor.toRadixString(16).padLeft(2, '0').toUpperCase()}",
      );
    }
    return xor & 0xFF;
  }

  Future<void> sendCommand(List<int> cmd) async {
    if (writeChar == null) {
      throw Exception("Write characteristic not found");
    }
    print(
      "📤 SEND : ${cmd.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}",
    );
    await writeChar!.write(cmd);
  }

  Future<List<int>?> sendCommandAndWait(
    List<int> cmd, {
    int timeoutSeconds = 5,
    List<List<int>> expectedHeaders = const [],
  }) async {
    bleBuffer.clear();
    pendingReply = Completer<List<int>>();
    expectedReplyHeaders = expectedHeaders;
    await sendCommand(cmd);
    try {
      final response = await pendingReply!.future.timeout(
        Duration(seconds: timeoutSeconds),
      );
      return response;
    } on TimeoutException {
      expectedReplyHeaders = [];
      return null;
    } finally {
      expectedReplyHeaders = [];
    }
  }

  List<int> buildCalibrationCommand({
    required int channel,
    required double fat,
    required double snf,
  }) {
    int fatValue = (fat * 100).round();
    int snfValue = (snf * 100).round();
    List<int> cmd = [
      0x40,
      0x0C,
      0x30,
      channel,
      0x00,
      (fatValue >> 8) & 0xFF,
      fatValue & 0xFF,
      (snfValue >> 8) & 0xFF,
      snfValue & 0xFF,
      0x00,
      0x00,
      0x00,
      0x00,
    ];
    int xor = calculateXor(cmd);
    cmd.add(xor);
    print(
      '📤 CALIBRATION CMD : '
      "${cmd.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}",
    );
    return cmd;
  }

  Future<void> onSavePressed() async {
    try {
      setState(() {
        isProcessing = true;
      });
      if (writeChar == null || notifyChar == null) {
        print("❌ BLE not ready");
        return;
      }
     int channelIndex = int.parse(selectedChannel) - 1;

// Start calibration
      List<int> startCmd = hex("40 04 04 01 00 41");

      await sendCommandAndWait(
        startCmd,
        timeoutSeconds: 2,
      );

// Read values
      double fat = double.tryParse(
            controllers['ch${selectedChannel}_fat']!.text,
          ) ??
          0.0;

      double snf = double.tryParse(
            controllers['ch${selectedChannel}_snf']!.text,
          ) ??
          0.0;

// Build calibration command
      List<int> calibrationCmd = buildCalibrationCommand(
        channel: channelIndex,
        fat: fat,
        snf: snf,
      );

// Send calibration command
      await sendCommandAndWait(
        calibrationCmd,
        timeoutSeconds: 3,
      );

// End calibration
      List<int> endCmd = hex("40 04 04 00 00 40");

      await sendCommandAndWait(
        endCmd,
        timeoutSeconds: 2,
      );

// Exit
      List<int> exitCmd = hex("40 04 01 0A 00 4F");

      await sendCommandAndWait(
        exitCmd,
        timeoutSeconds: 2,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Easy Correction Success"),
        ),
      );
    } catch (e) {
      print("❌ EASY CORRECTION ERROR : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error : $e"),
        ),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // -------------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChannelSelector(),
        const SizedBox(height: 20),
        _buildChannelCard(selectedChannel),
        const SizedBox(height: 30),
        Center(
          child: SizedBox(
            width: 120,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isProcessing ? null : onSavePressed,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelSelector() {
    return DropdownButtonFormField<String>(
      value: selectedChannel,
      dropdownColor: const Color(0xFF1E293B),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Select Channel',
        labelStyle: const TextStyle(
          color: Color(0xFF94A3B8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF334155),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
      items: ['1', '2', '3'].map((channel) {
        return DropdownMenuItem(
          value: channel,
          child: Text("CH $channel"),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedChannel = value!;
        });
      },
    );
  }

  Widget _buildChannelCard(String ch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selected Channel $ch",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _inputField(
                label: "FAT",
                controller: controllers['ch${ch}_fat']!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _inputField(
                label: "SNF",
                controller: controllers['ch${ch}_snf']!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF94A3B8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF334155),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
