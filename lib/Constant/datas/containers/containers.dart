// ignore_for_file: camel_case_types, unnecessary_string_interpolations, unused_element, unused_local_variable

import 'dart:ui';

import 'package:LactosureConnect/Constant/core/extensions/getx_custom_snackbar.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/state.dart';
import 'package:LactosureConnect/LOGIN/Society/dashboard/dashboard.dart';
import 'package:LactosureConnect/widgets/buttons.dart';
import 'package:LactosureConnect/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MachineId extends StatelessWidget {
  const MachineId({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;

    double x = fontsize * .008;

    final appState = Provider.of<AppState>(context, listen: true);

    final String idfarmer =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[16] : '0%';
    final String fid = idfarmer.replaceAll(RegExp(r'[^0-9.]'), '');

    // Parse the value as a double and format it with one digit before the decimal point
    int parsedFid = int.tryParse(fid) ??
        0; // Try parsing as an integer, default to 0 if parsing fails
    String formattedFid = parsedFid.toString();

    return Container(
      width: .4.sw,
      height: .14.sw,
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 255, 0, 0),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, screenHeight * 0.0,
                  screenWidth * 0.09, screenWidth * 0.000),
              child: Text(
                'Machine ID = $formattedFid', // Display formattedFid with a percentage sign
                style: TextStyle(
                  color: Colors.white,
                  fontSize: x,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class farmcontainer extends StatelessWidget {
  const farmcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;

    double x = fontsize * .008;

    final appState = Provider.of<AppState>(context, listen: true);

    final String idfarmer =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[11] : '0%';
    final String fid = idfarmer.replaceAll(RegExp(r'[^0-9.]'), '');

    // Parse the value as a double and format it with one digit before the decimal point
    int parsedFid = int.tryParse(fid) ??
        0; // Try parsing as an integer, default to 0 if parsing fails
    String formattedFid = parsedFid.toString();

    return Container(
      width: .42.sw,
      height: .14.sw,
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 255, 0, 0),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 2.r),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.0, screenHeight * 0.0, screenWidth * 0.2, 0),
              child: Text(
                'Farmer ID = $formattedFid', // Display formattedFid with a percentage sign
                style: TextStyle(
                  color: Colors.white,
                  fontSize: x,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FatContainer extends StatelessWidget {
  const FatContainer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double x = fontsize * .008;
    double y = fontsize * .03;
    final appState = Provider.of<AppState>(context, listen: true);

    final String fatValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[3] : '0%';
    final String f = fatValue.replaceAll(RegExp(r'[^0-9.]'), '');

    // Parse the value as a double and format it with one digit before the decimal point
    final double fatDouble = double.tryParse(f) ?? 0.0;
    final String formattedFat = fatDouble.toStringAsFixed(1);

    // Add a percentage sign to the formatted value
    final String fatWithPercentage = '$formattedFat %';

    return Container(
      width: screenWidth * .41, // Set the desired width
      height: screenHeight * .19,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 147, 44, 6),
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
                Text(
                  '   FAT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.percent,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              fatDouble == 0.0
                  ? '0%'
                  : fatWithPercentage, // Display snf with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SnfContainer extends StatelessWidget {
  const SnfContainer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;

    double x = fontsize * .008;
    double y = fontsize * .03;

    final appState = Provider.of<AppState>(context, listen: true);

    final String snfValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[4] : '0%';
    final String snf = snfValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double snfDouble = double.tryParse(snf) ?? 0.0;
    final String formattedsnf = snfDouble.toStringAsFixed(1);

    // Add a percentage sign to the value
    final String snfWithPercentage = '$formattedsnf %';

    return Container(
      width: screenWidth * .41, // Set the desired width
      height: screenHeight * .19,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 147, 44, 6),
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
                Text(
                  '   SNF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.percent,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              snfDouble == 0.0
                  ? '0%'
                  : snfWithPercentage, // Display snf with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class clrcontainer extends StatelessWidget {
  const clrcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .015;
    double w = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String clrValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[5] : '';
    final String c = clrValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double clrDouble = double.tryParse(c) ?? 0.0;
    final String formattedc = clrDouble.toStringAsFixed(0);

    // Add a percentage sign to the value
    final String clrWithPercentage = '$formattedc';
    String getFatWithPercentage() {
      return clrWithPercentage;
    }

    return Container(
      width: screenWidth * .268, // Set the desired width
      height: screenHeight * .113,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 6, 147, 13),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                Text(
                  '    CLR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: 10.r),
            Text(
              clrDouble == 0.0
                  ? '0'
                  : clrWithPercentage, // Display clr with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class water extends StatelessWidget {
  const water({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .015;
    double ww = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String wValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[9] : '0%';
    final String w = wValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double wDouble = double.tryParse(w) ?? 0.0;
    final String formattedw = wDouble.toStringAsFixed(2);

    // Add a percentage sign to the water value
    final String waterWithPercentage = '$formattedw %';

    return Container(
      width: screenWidth * .268, // Set the desired width
      height: screenHeight * .113,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 6, 128, 147),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                Text(
                  '   WATER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.percent,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: 10.r),
            Text(
              wDouble == 0.0
                  ? '0%'
                  : waterWithPercentage, // Display the water value with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class temp extends StatelessWidget {
  const temp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .015;
    double w = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    // Access resultBoxes[0] from the appState
    final String tValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[10] : '0%';
    final String t = tValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double tDouble = double.tryParse(t) ?? 0.0;
    final String formattedt = tDouble.toStringAsFixed(2);

    // Add a percentage sign to the temperature value
    final String temperatureWithPercentage = '$formattedt %';

    return Container(
      width: screenWidth * .268, // Set the desired width
      height: screenHeight * .113,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 147, 83, 6),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                Text(
                  '   TEMP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.percent,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: 10.r),
            Text(
              tDouble == 0.0
                  ? '0%'
                  : temperatureWithPercentage, // Display the temperature with a percentage sign
              style: TextStyle(
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Other widgets and classes can go here

class Protein extends StatelessWidget {
  const Protein({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .015;
    double w = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String pValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[6] : '0%';

    final String p = pValue.replaceAll(RegExp(r'[^0-9.]'), '');

    final double pDouble = double.tryParse(p) ?? 0.0;
    final String formattedp = pDouble.toStringAsFixed(2);

    // Add percentage signs to the values
    final String pWithPercentage = '$formattedp %';

    return Container(
      width: screenWidth * .268, // Set the desired width
      height: screenHeight * .113,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 112, 27, 113),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                Text(
                  '  PROTEIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.percent,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: 10.r),
            Text(
              pDouble == 0.0
                  ? '0%'
                  : pWithPercentage, // Display protein with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lactos extends StatelessWidget {
  const Lactos({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .015;
    double w = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String lValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[7] : '0%';

    final String l = lValue.replaceAll(RegExp(r'[^0-9.]'), '');

    final double lDouble = double.tryParse(l) ?? 0.0;
    final String formattedl = lDouble.toStringAsFixed(2);

    final String lWithPercentage = '$formattedl %';

    return Container(
      width: screenWidth * .268, // Set the desired width
      height: screenHeight * .113,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 112, 27, 113),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.r),
            Row(
              children: [
                Text(
                  '  LACTOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.percent,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: 10.r),
            Text(
              lDouble == 0.0
                  ? '0%'
                  : lWithPercentage, // Display lactose with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Salt extends StatelessWidget {
  const Salt({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .015;
    double w = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String sValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[8] : '0%';

    final String s = sValue.replaceAll(RegExp(r'[^0-9.]'), '');

    final double sDouble = double.tryParse(s) ?? 0.0;
    final String formatteds = sDouble.toStringAsFixed(2);

    final String sWithPercentage = '$formatteds %';

    return Container(
      width: screenWidth * .268, // Set the desired width
      height: screenHeight * .113,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 112, 27, 113),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                Text(
                  '  SALT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.r,
                ),
                Icon(
                  Icons.percent,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
            ),
            SizedBox(height: 10.r),
            Text(
              sDouble == 0.0
                  ? '0%'
                  : sWithPercentage, // Display salt with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class qtrcontainer extends StatelessWidget {
  const qtrcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .016;
    double w = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String qt =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[12] : '0%';
    final String qtr = qt.replaceAll(RegExp(r'[^0-9.]'), '');
    final double qtrValue = double.tryParse(qtr) ?? 0.0;
    final String formattedQtr =
        qtrValue.toString(); // This removes leading zeros

    return Container(
      width: .578.sw,
      height: .12.sw,
      decoration: BoxDecoration(
        color: const Color.fromARGB(122, 21, 29, 98),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 2.r),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0).r,
                  child: Text(
                    'QUANTITY (L)',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 0, 0),
                      fontSize: x,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.r,
                ),
                Icon(
                  Icons.water_damage,
                  color: Colors.white,
                  size: 12.r,
                ),
              ],
            ),
            Text(
              formattedQtr, // Display qtr without leading zeros with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .0075;
    double y = fontsize * .022;
    double w = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String sValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[13] : '0 Rs/-';

    final String s = sValue.replaceAll(RegExp(r'[^0-9.]'), '');

    final double sDouble = double.tryParse(s) ?? 0.0;
    final String formatteds = sDouble.toStringAsFixed(2);

    final String sWithPercentage = '$formatteds';

    return Container(
      width: screenWidth * .4, // Set the desired width
      height: screenHeight * .175,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 200, 13, 13),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                SizedBox(width: 8.r),
                Text(
                  '      TOTAL AMOUNT  (Rs)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              sDouble == 0.0
                  ? '0'
                  : sWithPercentage, // Display salt with a percentage sign
              style: TextStyle(
                color: Colors.white,
                fontSize: y,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class rate extends StatelessWidget {
  const rate({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .008;
    double y = fontsize * .016;
    double ww = iconsize * 0.04;
    final appState = Provider.of<AppState>(context, listen: true);

    final String wValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[14] : '';
    final String w = wValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double wDouble = double.tryParse(w) ?? 0.0;
    final String formattedw = wDouble.toStringAsFixed(2);

    // Add a percentage sign to the water value
    final String waterWithPercentage = '$formattedw';
    wDouble == 0.0 ? '0' : waterWithPercentage;
    return Container(
      width: screenWidth * .37, // Set the desired width
      height: screenHeight * .055,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 6, 147, 13),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.r),
            Row(
              children: [
                Text(
                  '   Rate        = $wDouble  Rs/-',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class qty extends StatelessWidget {
  const qty({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .008;
    final appState = Provider.of<AppState>(context, listen: true);

    final String wValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[12] : '';
    final String w = wValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double wDouble = double.tryParse(w) ?? 0.0;
    final String formattedw = wDouble.toStringAsFixed(2);

    // Add a percentage sign to the water value
    final String waterWithPercentage = '$formattedw';
    wDouble == 0.0 ? '0' : waterWithPercentage;
    return Container(
      width: screenWidth * .37, // Set the desired width
      height: screenHeight * .055,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 147, 116, 6),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.r),
            Row(
              children: [
                Text(
                  '   Quantity = $wDouble  (L)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class bonus extends StatelessWidget {
  const bonus({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;
    double x = fontsize * .008;
    final appState = Provider.of<AppState>(context, listen: true);

    final String wValue =
        appState.resultBoxes.isNotEmpty ? appState.resultBoxes[15] : '';
    final String w = wValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final double wDouble = double.tryParse(w) ?? 0.0;
    final String formattedw = wDouble.toStringAsFixed(2);

    // Add a percentage sign to the water value
    final String waterWithPercentage = '$formattedw';
    wDouble == 0.0 ? '0' : waterWithPercentage;
    return Container(
      width: screenWidth * .37, // Set the desired width
      height: screenHeight * .055,
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 6, 147, 147),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.r),
            Row(
              children: [
                Text(
                  '   Bonus     = $wDouble  Rs/-',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: x,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BorderOnlyContainer extends Container {
  BorderOnlyContainer({
    super.key,
    required Widget super.child,
    Color borderColor = Colors.black,
    double borderWidth = 1.0,
    super.width,
    super.height,
    BorderRadius borderRadius = BorderRadius.zero,
  }) : super(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            borderRadius: borderRadius,
          ),
        );
}

class TestValueContainer extends StatelessWidget {
  const TestValueContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final String test = appState.testValuehex;
    print(test);
    return Container(
      width: 0.3.sw,
      height: 0.145.sw,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 22, 21),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                SizedBox(
                  width: 4.r,
                ),
                Text(
                  'Tests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.r,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 3.r,
                ),
                Icon(
                  Icons.water_drop_sharp,
                  color: Colors.white,
                  size: 10.r,
                ),
              ],
            ),
            SizedBox(height: 5.r),
            Text(
              test,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class cleandailyContainer extends StatelessWidget {
  const cleandailyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final String cleanvalue = appState.cleanDailyValuehex;
    print(cleanvalue);
    return Container(
      width: 0.3.sw,
      height: 0.145.sw,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 22, 21),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                SizedBox(
                  width: 4.r,
                ),
                Text(
                  'Clean (D)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.r,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 3.r,
                ),
                Icon(
                  Icons.cleaning_services,
                  color: Colors.white,
                  size: 10.r,
                ),
              ],
            ),
            SizedBox(height: 5.r),
            Text(
              cleanvalue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class cleanwContainer extends StatelessWidget {
  const cleanwContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final String cleanwvalue = appState.cleanWeeklyValuehex;
    print(cleanwvalue);
    return Container(
      width: 0.3.sw,
      height: 0.145.sw,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 22, 21),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                SizedBox(
                  width: 4.r,
                ),
                Text(
                  'Clean (W)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.r,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 3.r,
                ),
                Icon(
                  Icons.cleaning_services_rounded,
                  color: Colors.white,
                  size: 10.r,
                ),
              ],
            ),
            SizedBox(height: 5.r),
            Text(
              cleanwvalue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class cleanskipContainer extends StatelessWidget {
  const cleanskipContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final String cleanskip = appState.skipValuehex;
    print(cleanskip);
    return Container(
      width: 0.3.sw,
      height: 0.145.sw,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 1, 22, 21),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.r),
            Row(
              children: [
                SizedBox(
                  width: 4.r,
                ),
                Text(
                  'Auto Clean Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.r,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 3.r,
                ),
                Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 10.r,
                ),
              ],
            ),
            SizedBox(height: 5.r),
            Text(
              cleanskip,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class mpassContainer extends StatefulWidget {
  const mpassContainer({super.key});

  @override
  State<mpassContainer> createState() => _mpassContainerState();
}

String user = '';
String supervisor = '';
String wifi = '';

class _mpassContainerState extends State<mpassContainer> {
  // Add this boolean variable to track the visibility

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final appState = Provider.of<AppState>(context, listen: true);
    final String qq = appState.passalert;

    user = appState.PassworduserHex;
    supervisor = appState.PasswordsuperHex;
    wifi = appState.PasswordwifiHex;
    print('userpasswordfromcontainer: $user');
    DeviceScreen.userpassController.text = user;
    DeviceScreen.superpassController.text = supervisor;
    DeviceScreen.wifipassController.text = wifi;
    return SingleChildScrollView(
      child: Stack(
        // Use Stack to overlay blur effect
        children: [
          // Background with blur effect
          if (mpass)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          Column(
            // Wrap with a Column to include the button
            children: [
              mpass
                  ? Container(
                      width: 1.sw,
                      height: 1.sw,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(0, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, .5.sw, 0, 0),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: 15.r),
                              Text(
                                'Machine password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.r,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16.r),
                              Row(
                                children: [
                                  SizedBox(width: 16.r),
                                  Expanded(
                                    child: CustomTextField3(
                                      controller:
                                          DeviceScreen.userpassController,
                                      labelText: 'User',
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 15.r),
                                  Expanded(
                                    child: CustomTextField3(
                                      controller:
                                          DeviceScreen.superpassController,
                                      labelText: 'Supervisor',
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 15.r),
                                  Expanded(
                                    child: CustomTextField3(
                                      controller:
                                          DeviceScreen.wifipassController,
                                      labelText: 'Wifi',
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 16.r),
                                ],
                              ),
                              SizedBox(height: 10.r),
                              Row(
                                children: [
                                  SizedBox(width: 25.r),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.01,
                                        screenHeight * 0.0,
                                        0,
                                        0),
                                    child: SecondaryButton(
                                      maxWidth: .3.sw,
                                      maxHeight: .05.sh,
                                      onTap: () {
                                        setState(() {
                                          mpass =
                                              !mpass; // Toggle the visibility
                                        });
                                      },
                                      text: (mpass ? 'Close' : 'Show'),
                                    ),
                                  ),
                                  SizedBox(width: 10.r),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.0,
                                        screenHeight * 0.0,
                                        0,
                                        0),
                                    child: PrimaryButton(
                                      maxHeight: .05.sh,
                                      maxWidth: .5.sw,
                                      onTap: () async {
                                        String userPass = DeviceScreen
                                            .userpassController.text;
                                        int parsedUserPass =
                                            int.parse(userPass);
                                        String hexUserPass = parsedUserPass
                                            .toRadixString(16)
                                            .toUpperCase();
                                        hexUserPass =
                                            hexUserPass.padLeft(4, '0');
                                        String superPass = DeviceScreen
                                            .superpassController.text;
                                        int parsedsuperPass =
                                            int.parse(superPass);
                                        String hexsuperPass = parsedsuperPass
                                            .toRadixString(16)
                                            .toUpperCase();
                                        hexsuperPass =
                                            hexsuperPass.padLeft(4, '0');
                                        String wifiPass = DeviceScreen
                                            .wifipassController.text;
                                        int parsedwifiPass =
                                            int.parse(wifiPass);
                                        String hexwifiPass = parsedwifiPass
                                            .toRadixString(16)
                                            .toUpperCase();
                                        hexwifiPass =
                                            hexwifiPass.padLeft(4, '0');

                                        // Calculate ex values
                                        String ex1 = (int.parse(
                                                    hexUserPass.substring(0, 2),
                                                    radix: 16) ^
                                                int.parse(
                                                    hexUserPass.substring(2, 4),
                                                    radix: 16))
                                            .toRadixString(16)
                                            .toUpperCase()
                                            .padLeft(2, '0');
                                        String ex2 = (int.parse(
                                                    hexsuperPass.substring(
                                                        0, 2),
                                                    radix: 16) ^
                                                int.parse(
                                                    hexsuperPass.substring(
                                                        2, 4),
                                                    radix: 16))
                                            .toRadixString(16)
                                            .toUpperCase()
                                            .padLeft(2, '0');
                                        String ex3 = (int.parse(
                                                    hexwifiPass.substring(0, 2),
                                                    radix: 16) ^
                                                int.parse(
                                                    hexwifiPass.substring(2, 4),
                                                    radix: 16))
                                            .toRadixString(16)
                                            .toUpperCase()
                                            .padLeft(2, '0');

                                        // Print the entered numbers and ex values
                                        print('User Pass: $hexUserPass');
                                        print('Supervisor Pass: $hexsuperPass');
                                        print('Wifi Pass: $hexwifiPass');
                                        print('ex1: $ex1');
                                        print('ex2: $ex2');
                                        print('ex3: $ex3');

                                        // XOR of ex1, ex2, and ex3
                                        int result = int.parse(ex1, radix: 16) ^
                                            int.parse(ex2, radix: 16) ^
                                            int.parse(ex3, radix: 16) ^
                                            1;
                                        String resultHex = result
                                            .toRadixString(16)
                                            .toUpperCase()
                                            .padLeft(2, '0');
                                        print('XOR Result: $resultHex');

                                        String hexCommand =
                                            '400849$hexUserPass$hexsuperPass$hexwifiPass$resultHex';
                                        print(hexCommand);
                                        appState.sendHexDatabt(hexCommand);
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        final String qq = appState.passalert;
                                        print('passalert:$qq');
                                        if (qq == '4002490b') {
                                          // Show an alert box indicating password change successful
                                          Get.customSnackBar(
                                            statusType: StatusType.success,
                                            designType: SnackDesign.line,
                                            title:
                                                'Password change successfully.',
                                            compact: true,
                                          );

                                          String hexCommand = '40044800000C';
                                          appState.sendHexDatabt(hexCommand);
                                        }
                                      },
                                      text: 'Change Password',
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(), // Return an empty container if pass is false
            ],
          ),
        ],
      ),
    );
  }
}

class statiContainer extends StatefulWidget {
  const statiContainer({super.key});

  @override
  State<statiContainer> createState() => _statiContainerState();
}

class _statiContainerState extends State<statiContainer> {
  // Add this boolean variable to track the visibility

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final String qq = appState.passalert;
    return Stack(
      // Use Stack to overlay blur effect
      children: [
        // Background with blur effect
        if (stati)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        Column(
          // Wrap with a Column to include the button
          children: [
            stati
                ? Container(
                    width: 1.sw,
                    height: 1.5.sw,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(.14.sw, .2.sh, 0, 0),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(height: 15.r),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.sh, .13.sw, 0),
                              child: Text(
                                'Statistics',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.r,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 16.r),
                            Row(
                              children: [
                                SizedBox(width: 14.r),
                                TestValueContainer(),
                                SizedBox(width: 10.r),
                                cleandailyContainer(),
                              ],
                            ),
                            SizedBox(height: 8.r),
                            Row(
                              children: [
                                SizedBox(width: 14.r),
                                cleanwContainer(),
                                SizedBox(width: 10.r),
                                cleanskipContainer()
                              ],
                            ),
                            SizedBox(height: 10.r),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.sh, .13.sw, 0),
                              child: SecondaryButton(
                                maxWidth: 100,
                                maxHeight: 40,
                                onTap: () {
                                  setState(() {
                                    stati = !stati; // Toggle the visibility
                                  });
                                  String hexCommand = '40044800000C';
                                  appState.sendHexDatabt(hexCommand);
                                },
                                text: (stati ? 'Close' : 'Show'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(), // Return an empty container if pass is false
          ],
        ),
      ],
    );
  }
}
