import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MachineCorrectionService {
  static const String baseUrl = "YOUR_BASE_URL_HERE";

  static Future<void> sendCorrection({
    required String societyID,
    required String machineType,
    required String machineId,
    required String selectedChannel,
    required Map<String, TextEditingController> controllers,
  }) async {
    try {
      Map<String, dynamic> body = {
        "societyID": societyID,
        "machineType": machineType,
        "machineId": machineId,
      };

      // Loop channels 1,2,3
      for (int i = 1; i <= 3; i++) {
        bool isSelected = selectedChannel == i.toString();

        body["ch$i"] = "$i";

        body["fat$i"] =
            isSelected ? controllers['ch${i}_fat']!.text : "0.00";
        body["snf$i"] =
            isSelected ? controllers['ch${i}_snf']!.text : "0.00";
        body["clr$i"] =
            isSelected ? controllers['ch${i}_clr']!.text : "0.00";
        body["t$i"] =
            isSelected ? controllers['ch${i}_temp']!.text : "0.00";
        body["p$i"] =
            isSelected ? controllers['ch${i}_protein']!.text : "0.00";
        body["w$i"] =
            isSelected ? controllers['ch${i}_water']!.text : "0.00";
      }

      print("📡 API REQUEST BODY:");
      print(jsonEncode(body));

      final response = await http.post(
        Uri.parse("$baseUrl/api/MachineCorrection/GetLatestMachineCorrection"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("📥 RESPONSE: ${response.statusCode}");
      print(response.body);

      if (response.statusCode != 200) {
        throw Exception("API failed");
      }
    } catch (e) {
      print("❌ API ERROR: $e");
    }
  }
}