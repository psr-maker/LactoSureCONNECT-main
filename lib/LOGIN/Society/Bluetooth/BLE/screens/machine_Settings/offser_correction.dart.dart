import 'dart:async';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/BLE/screens/machine_Settings/easy_correction.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/BLE/screens/machine_Settings/service/models/gethistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OfferCorrection extends StatefulWidget {
  final BluetoothDevice device;
  const OfferCorrection({super.key, required this.device});

  @override
  State<OfferCorrection> createState() => _MsettingsState();
}

class _MsettingsState extends State<OfferCorrection> {
  final Map<String, TextEditingController> controllers = {};
  int selectedTab = 0;
  String selectedChannel = '1';
  BluetoothCharacteristic? writeChar;
  BluetoothCharacteristic? notifyChar;
  List<int> buffer = [];
  Map<String, double> lastReadValues = {};
  Map<String, double> finalWrittenValues = {};
  bool isReadClicked = false;
  String formattedDate = "";
  final String apiBaseUrl = 'https://lactosure.azurewebsites.net';
// -------------------- INIT --------------------
  @override
  void initState() {
    super.initState();
    initControllers();
    Future.delayed(Duration(milliseconds: 500), () {
      discoverServices();
    });
  }

  void initControllers() {
    List<String> channels = ['1', '2', '3'];
    List<String> fields = ['fat', 'snf', 'clr', 'temp', 'protein', 'water'];
    for (var ch in channels) {
      for (var f in fields) {
        controllers['ch${ch}_$f'] = TextEditingController();
      }
    }
    controllers['society'] = TextEditingController();
    controllers['machineId'] = TextEditingController();
    controllers['model'] = TextEditingController();
  }

  bool isRequiredFieldsFilled() {
    return controllers['society']!.text.trim().isNotEmpty &&
        controllers['machineId']!.text.trim().isNotEmpty &&
        controllers['model']!.text.trim().isNotEmpty;
  }

  void showTopSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 120,
        left: 20,
        right: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();

    BluetoothCharacteristic? write;
    BluetoothCharacteristic? notify;

    for (var service in services) {
      for (var char in service.characteristics) {
        print("CHAR: ${char.uuid}");
        print("  write: ${char.properties.write}");
        print("  writeNoResp: ${char.properties.writeWithoutResponse}");
        print("  notify: ${char.properties.notify}");

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

      print("✅ WRITE CHAR: ${write.uuid}");
      print("✅ NOTIFY CHAR: ${notify.uuid}");
    } else {
      print("❌ Required characteristics not found");
    }
  }

  Future<void> readChannel() async {
    if (writeChar == null || notifyChar == null) {
      print("❌ Characteristics not ready");
      return;
    }

    late StreamSubscription sub;

    sub = notifyChar!.lastValueStream.listen((data) {
      if (data.isEmpty) return;

      buffer.addAll(data);

      final frame = extractFrame(buffer);

      if (frame != null) {
        print(
            "📦 FRAME RECEIVED: ${frame.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}");

        if (frame[1] != 0x0E || frame[2] != 0xA1) {
          print("❌ Invalid response (not memory response)");
          buffer.clear();
          return;
        }

        try {
          final result = parseData(frame);
          print("✅ PARSED VALUES:");
          result.forEach((key, value) {
            print("   $key: $value");
          });

          updateControllers(result);
          buffer.removeRange(0, frame.length);
        } catch (e) {
          print("❌ Parse error: $e");
        }
      }
    });

    try {
      print("🔐 LOGIN...");
      await writeChar!.write(hex("40 04 06 00 00 42"));
      await Future.delayed(const Duration(seconds: 1));

      buffer.clear();

      print("📖 Requesting values from channel ${selectedChannel}...");
      int channelIndex = int.parse(selectedChannel) - 1;
      List<int> cmd = buildReadCommand(channelIndex);

      print(
          "📤 READ CMD: ${cmd.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}");

      await writeChar!.write(cmd);
      await Future.delayed(const Duration(seconds: 2));

      print("🔓 LOGOUT...");
      await writeChar!.write(hex("40 04 D1 00 00 95"));

      print("✅ Read completed\n");
      setState(() {
        isReadClicked = true;
      });
    } catch (e) {
      print("❌ BLE ERROR: $e");
    } finally {
      await sub.cancel();
    }
  }

  Future<void> readChannelForWrite(int channelIndex) async {
    if (writeChar == null || notifyChar == null) {
      print("❌ Characteristics not ready");
      return;
    }

    Completer<void> readComplete = Completer();
    late StreamSubscription sub;
    bool dataReceived = false;

    print("📋 Setting up notification listener...");

    sub = notifyChar!.lastValueStream.listen((data) {
      if (data.isEmpty) return;

      print("🔔 Notification received: ${data.length} bytes");
      print(
          "   Data: ${data.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}");

      buffer.addAll(data);
      print("   Buffer size: ${buffer.length}");

      final frame = extractFrame(buffer);

      if (frame != null) {
        print(
            "📦 FRAME EXTRACTED: ${frame.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}");

        if (frame[1] != 0x0E || frame[2] != 0xA1) {
          print("❌ Invalid response (type mismatch)");
          buffer.clear();
          return;
        }

        try {
          final result = parseData(frame);
          print("✅ OLD VALUES RETRIEVED:");
          result.forEach((key, value) {
            print("   $key: $value");
          });

          lastReadValues = result;
          dataReceived = true;
          buffer.removeRange(0, frame.length);

          if (!readComplete.isCompleted) {
            readComplete.complete();
          }
        } catch (e) {
          print("❌ Parse error: $e");
        }
      } else {
        print("⏳ Frame not complete yet, waiting for more data...");
      }
    }, onError: (error) {
      print("❌ Stream error: $error");
      if (!readComplete.isCompleted) {
        readComplete.completeError(error);
      }
    });

    try {
      buffer.clear();

      print("📖 Reading current values from channel ${channelIndex + 1}...");
      List<int> cmd = buildReadCommand(channelIndex);

      await Future.delayed(const Duration(milliseconds: 200));

      print("📤 Sending read command...");
      await writeChar!.write(cmd);
      await readComplete.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print("⏱️  Read timeout after 5 seconds");
          if (!dataReceived) {
            print("❌ No data received - device may not have responded");
            print("   Retrying with last known values...");
          }
        },
      );

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print("❌ BLE ERROR during read: $e");
    } finally {
      await sub.cancel();
      print("✅ Read operation completed (data received: $dataReceived)\n");
    }
  }

  List<int> buildReadCommand(int channel) {
    int address = 34 + (channel * 70);

    int high = (address >> 8) & 0xFF;
    int low = address & 0xFF;

    List<int> cmd = [
      0x40,
      0x06,
      0xFA,
      0xA1,
      high,
      low,
      0x0C,
    ];

    int lrc = calculateLRC(cmd);
    cmd.add(lrc);

    print(
        "   📋 READ CMD for CH${channel + 1}: ${cmd.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}");

    return cmd;
  }

  List<int>? extractFrame(List<int> buffer) {
    int start = buffer.indexOf(0x40);
    if (start == -1) return null;

    if (buffer.length < start + 17) return null;

    return buffer.sublist(start, start + 17);
  }

  Map<String, double> parseData(List<int> frame) {
    if (frame.length < 17) {
      throw Exception("Invalid frame length: ${frame.length}");
    }

    int readInt16(int high, int low) {
      int value = (high << 8) | low;

      if (value & 0x8000 != 0) {
        value = value - 0x10000;
      }
      return value;
    }

    double getVal(int i, String name) {
      int raw = readInt16(frame[i], frame[i + 1]);
      double val = raw / 100.0;
      print(
          "      $name: raw=0x${raw.toRadixString(16).padLeft(4, '0')} → $val");
      return val;
    }

    print("   📊 Parsing frame data:");
    return {
      "fat": getVal(3, "Fat"),
      "protein": getVal(5, "Protein"),
      "snf": getVal(7, "SNF"),
      "temp": getVal(9, "Temp"),
      "water": getVal(11, "Water"),
      "clr": getVal(13, "CLR"),
    };
  }

  void updateControllers(Map<String, double> data) {
    lastReadValues = data;
    print("   💾 Storing values in memory: $data");
    setState(() {
      controllers['ch${selectedChannel}_fat']!.text = data['fat'].toString();
      controllers['ch${selectedChannel}_snf']!.text = data['snf'].toString();
      controllers['ch${selectedChannel}_clr']!.text = data['clr'].toString();
      controllers['ch${selectedChannel}_temp']!.text = data['temp'].toString();
      controllers['ch${selectedChannel}_protein']!.text =
          data['protein'].toString();
      controllers['ch${selectedChannel}_water']!.text =
          data['water'].toString();
    });
    print("   ✅ UI updated with read values\n");
  }

  List<int> buildWriteCommand(int channel) {
    int address = 34 + (channel * 70);

    int high = (address >> 8) & 0xFF;
    int low = address & 0xFF;

    double getFinal(String key, String field) {
      double oldVal = lastReadValues[field] ?? 0.0;

      if (!isChanged(key)) {
        print("⏭️  $field: unchanged, keeping old value: $oldVal");
        return oldVal;
      }

      double input = double.tryParse(controllers[key]!.text) ?? 0;

      if ((input - oldVal).abs() < 0.001) {
        print("🔄 $field: INPUT=$input equals OLD=$oldVal, keeping old value");
        return oldVal;
      } else {
        double finalVal = oldVal + input;
        print("✏️  $field: OLD=$oldVal + INPUT=$input = FINAL=$finalVal");
        return finalVal;
      }
    }

    double fat = getFinal('ch${selectedChannel}_fat', 'fat');
    double protein = getFinal('ch${selectedChannel}_protein', 'protein');
    double snf = getFinal('ch${selectedChannel}_snf', 'snf');
    double temp = getFinal('ch${selectedChannel}_temp', 'temp');
    double water = getFinal('ch${selectedChannel}_water', 'water');
    double clr = getFinal('ch${selectedChannel}_clr', 'clr');

    finalWrittenValues = {
      'fat': fat,
      'snf': snf,
      'clr': clr,
      'temp': temp,
      'protein': protein,
      'water': water,
    };

    List<int> toBytes(double val) {
      int v = (val * 100).round();
      if (v < 0) {
        v = 0x10000 + v;
      }
      if (v < 0 || v > 0xFFFF) {
        print("⚠️  Value out of range: $val → $v");
      }

      return [(v >> 8) & 0xFF, v & 0xFF];
    }

    print("\n📋 BUILDING WRITE COMMAND FOR CHANNEL ${channel + 1}");
    print(
        "Address: 0x${address.toRadixString(16)} (High: 0x${high.toRadixString(16)}, Low: 0x${low.toRadixString(16)})");

    List<int> cmd = [
      0x40,
      0x12,
      0xFA,
      0xA0,
      high,
      low,
      0x0C,
      ...toBytes(fat),
      ...toBytes(protein),
      ...toBytes(snf),
      ...toBytes(temp),
      ...toBytes(water),
      ...toBytes(clr)
    ];

    int lrc = calculateLRC(cmd);
    cmd.add(lrc);

    print(
        "📤 FINAL COMMAND: ${cmd.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase()}");
    print(
        "✅ CHECKSUM: 0x${lrc.toRadixString(16).padLeft(2, '0').toUpperCase()}\n");

    return cmd;
  }

  bool isChanged(String key) {
    final text = controllers[key]!.text.trim();
    return text.isNotEmpty && text != "0" && text != "0.0";
  }

  List<int> hex(String s) =>
      s.split(' ').map((e) => int.parse(e, radix: 16)).toList();

  int calculateLRC(List<int> bytes) {
    int xor = 0;
    for (var b in bytes) {
      xor ^= b;
    }
    return xor & 0xFF;
  }

  Future<void> updateMachineCorrection() async {
    try {
      print("\n☁️ UPDATING CLOUD WITH CORRECTIONS...");

      String society = controllers['society']?.text.trim() ?? '';
      String machineId = controllers['machineId']?.text.trim() ?? '';
      String model = controllers['model']?.text.trim() ?? '';

      if (society.isEmpty || machineId.isEmpty || model.isEmpty) {
        print("❌ Missing required fields");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please enter Society ID, Machine ID and Model",
            ),
          ),
        );

        return;
      }

      Map<String, dynamic> payload = {
        'SocietyID': society,
        'MachineId': machineId,
        'MachineType': model,

        // ---------------- CHANNEL 1 ----------------
        'ch1': selectedChannel == "1" ? "1" : null,
        'fat1': selectedChannel == "1" ? finalWrittenValues['fat'] : null,
        'snf1': selectedChannel == "1" ? finalWrittenValues['snf'] : null,
        'clr1': selectedChannel == "1" ? finalWrittenValues['clr'] : null,
        't1': selectedChannel == "1" ? finalWrittenValues['temp'] : null,
        'w1': selectedChannel == "1" ? finalWrittenValues['water'] : null,
        'p1': selectedChannel == "1" ? finalWrittenValues['protein'] : null,

        // ---------------- CHANNEL 2 ----------------
        'ch2': selectedChannel == "2" ? "2" : null,
        'fat2': selectedChannel == "2" ? finalWrittenValues['fat'] : null,
        'snf2': selectedChannel == "2" ? finalWrittenValues['snf'] : null,
        'clr2': selectedChannel == "2" ? finalWrittenValues['clr'] : null,
        't2': selectedChannel == "2" ? finalWrittenValues['temp'] : null,
        'w2': selectedChannel == "2" ? finalWrittenValues['water'] : null,
        'p2': selectedChannel == "2" ? finalWrittenValues['protein'] : null,

        // ---------------- CHANNEL 3 ----------------
        'ch3': selectedChannel == "3" ? "3" : null,
        'fat3': selectedChannel == "3" ? finalWrittenValues['fat'] : null,
        'snf3': selectedChannel == "3" ? finalWrittenValues['snf'] : null,
        'clr3': selectedChannel == "3" ? finalWrittenValues['clr'] : null,
        't3': selectedChannel == "3" ? finalWrittenValues['temp'] : null,
        'w3': selectedChannel == "3" ? finalWrittenValues['water'] : null,
        'p3': selectedChannel == "3" ? finalWrittenValues['protein'] : null,

        'Timestamp': DateTime.now().toIso8601String(),
      };

      print("📤 FINAL PAYLOAD:");
      print(jsonEncode(payload));

      final response = await http.post(
        Uri.parse(
          '$apiBaseUrl/api/MachineCorrection/GetLatestMachineCorrection',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      print("📦 STATUS CODE: ${response.statusCode}");
      print("📦 RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ CLOUD UPDATE SUCCESSFUL");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Correction Saved Successfully",
            ),
          ),
        );
      } else {
        print("❌ CLOUD UPDATE FAILED");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed: ${response.statusCode}",
            ),
          ),
        );
      }
    } catch (e) {
      print("❌ CLOUD UPDATE ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    }
  }

  Future<List<CorrectionHistory>> fetchCorrectionHistory() async {
    try {
      String society = controllers['society']?.text.trim() ?? '';
      String machineId = controllers['machineId']?.text.trim() ?? '';
      String model = controllers['model']?.text.trim() ?? '';

      final uri =
          Uri.parse('$apiBaseUrl/api/MachineCorrection/GetCorrectionByDetails')
              .replace(
        queryParameters: {
          'SocietyID': society,
          'MachineID': machineId,
          'MachineType': model,
        },
      );

      print("📥 FETCHING HISTORY...");
      print(uri);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data.....🤠🤠🤠🤠");
        print(data);

        if (data is List) {
          return data.map((e) => CorrectionHistory.fromJson(e)).toList();
        }

        return [];
      } else {
        print("❌ HISTORY FETCH FAILED: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ HISTORY ERROR: $e");
      return [];
    }
  }

  Future<void> showHistoryDialog() async {
    List<CorrectionHistory> history = await fetchCorrectionHistory();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E293B),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Correction History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: history.isEmpty
                      ? const Center(
                          child: Text(
                            "No History Found",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final item = history[index];
                            try {
                              DateTime dt = DateTime.parse(item.backupDateTime);

                              formattedDate =
                                  "${dt.day.toString().padLeft(2, '0')}-"
                                  "${dt.month.toString().padLeft(2, '0')}-"
                                  "${dt.year}  "
                                  "${dt.hour.toString().padLeft(2, '0')}:"
                                  "${dt.minute.toString().padLeft(2, '0')}";
                            } catch (e) {
                              formattedDate = item.backupDateTime;
                            }
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Channel ${item.ch1 ?? item.ch2 ?? item.ch3 ?? '-'}",
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Date: $formattedDate",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      _historyChip(
                                        "Fat",
                                        item.fat1 ??
                                            item.fat2 ??
                                            item.fat3 ??
                                            "0",
                                      ),
                                      _historyChip(
                                        "SNF",
                                        item.snf1 ??
                                            item.snf2 ??
                                            item.snf3 ??
                                            "0",
                                      ),
                                      _historyChip(
                                        "CLR",
                                        item.clr1 ??
                                            item.clr2 ??
                                            item.clr3 ??
                                            "0",
                                      ),
                                      _historyChip(
                                        "Temp",
                                        item.t1 ?? item.t2 ?? item.t3 ?? "0",
                                      ),
                                      _historyChip(
                                        "Protein",
                                        item.p1 ?? item.p2 ?? item.p3 ?? "0",
                                      ),
                                      _historyChip(
                                        "Water",
                                        item.w1 ?? item.w2 ?? item.w3 ?? "0",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Machine Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 0;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedTab == 0
                              ? const Color.fromARGB(255, 16, 134, 109)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Common Offsets',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 1;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedTab == 1
                              ? const Color.fromARGB(255, 16, 134, 109)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Easy Corrections',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selectedTab == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Corrections',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await showHistoryDialog();
                    },
                    icon: const Icon(
                      Icons.history,
                      color: Colors.orange,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              _buildCommonCard(),
              const SizedBox(height: 20),
              _buildChannelCard(selectedChannel),
              const SizedBox(height: 25),
              Center(child: _submitButton()),
            ] else ...[

              Easycorrection(
                device: widget.device,
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChannelCard(String ch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected channel $ch',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _input('Fat', controllers['ch${ch}_fat']!,
                  keyboardType: TextInputType.number),
              _input('SNF', controllers['ch${ch}_snf']!,
                  keyboardType: TextInputType.number),
              _input('CLR', controllers['ch${ch}_clr']!,
                  keyboardType: TextInputType.number),
              _input('Temp', controllers['ch${ch}_temp']!,
                  keyboardType: TextInputType.number),
              _input('Protein', controllers['ch${ch}_protein']!,
                  keyboardType: TextInputType.number),
              _input('Water', controllers['ch${ch}_water']!,
                  keyboardType: TextInputType.number),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCommonCard() {
    return Row(
      children: [
        Expanded(child: _input('Society', controllers['society']!)),
        const SizedBox(width: 10),
        Expanded(child: _input('Machine ID', controllers['machineId']!)),
        const SizedBox(width: 10),
        Expanded(child: _input('Model', controllers['model']!)),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: selectedChannel,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Channel',
              labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
            items: ['1', '2', '3'].map((channel) {
              return DropdownMenuItem(
                value: channel,
                child: Text('CH $channel'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedChannel = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _input(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: (isReadClicked && isRequiredFieldsFilled())
                  ? Colors.orange
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isReadClicked
                ? () async {
                    // ✅ CHECK REQUIRED FIELDS
                    if (!isRequiredFieldsFilled()) {
                      showTopSnackBar(
                        "Please fill all required fields",
                      );
                      return;
                    }

                    if (writeChar == null) {
                      print("❌ Write characteristic not initialized");
                      return;
                    }

                    try {
                      print("\n" + "=" * 60);
                      print("📤 SEND OPERATION STARTED");
                      print("=" * 60);

                      print("\n🔐 LOGIN...");
                      await writeChar!.write(hex("40 04 06 00 00 42"));
                      await Future.delayed(const Duration(seconds: 1));

                      print("\n📖 STEP 1: Reading current channel data...");
                      int channelIndex = int.parse(selectedChannel) - 1;
                      await readChannelForWrite(channelIndex);

                      print(
                          "\n📝 STEP 2: Building write command with updated values...");
                      List<int> cmd = buildWriteCommand(channelIndex);

                      print("\n✉️  STEP 3: Sending write command to device...");
                      await writeChar!.write(cmd);
                      await Future.delayed(const Duration(seconds: 2));

                      print("\n🔓 LOGOUT...");
                      await writeChar!.write(hex("40 04 D1 00 00 95"));

                      print("\n✅ Write completed successfully!");

                      print("\n🔐 LOGIN (for verification)...");
                      await writeChar!.write(hex("40 04 06 00 00 42"));
                      await Future.delayed(const Duration(seconds: 1));

                      print(
                          "\n📖 STEP 5: Verifying written values by reading back...");
                      await readChannelForWrite(channelIndex);

                      print("\n🔓 LOGOUT...");
                      await writeChar!.write(hex("40 04 D1 00 00 95"));

                      print("\n✅ VERIFICATION COMPLETE\n");
                      print("=" * 60);

                      await updateMachineCorrection();

                      setState(() {
                        isReadClicked = false;
                      });
                    } catch (e) {
                      print("❌ SEND ERROR: $e");
                    }
                  }
                : null,
            child: const Text('Send',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: () async {
            if (writeChar == null) {
              print("❌ Characteristic not ready");
              return;
            }

            print("\n📖 READ REQUEST...");
            await readChannel();
          },
          child: const Text('Read',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _historyChip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "$title : $value",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
