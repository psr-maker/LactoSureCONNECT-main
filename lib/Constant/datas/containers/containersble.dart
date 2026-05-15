// ignore_for_file: camel_case_types, unnecessary_string_interpolations, unused_element, unused_local_variable

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    double x = fontsize * .008;
    double y = fontsize * .03;

    double iconsize1 = screenWidth + screenHeight;
    double iconsize = iconsize1 + iconsize1 * .6;

    double w = iconsize * 0.04;

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
            SizedBox(height: screenHeight * 0.01),
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
                  Icons.water_drop_outlined,
                  color: Colors.white,
                  size: 16.r,
                ),
              ],
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
    double x = fontsize * .008;
    double y = fontsize * .03;
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
            SizedBox(height: screenHeight * 0.01),
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
    double x = fontsize * .008;
    double y = fontsize * .03;

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
            SizedBox(height: screenHeight * 0.01),
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
    double x = fontsize * .008;
    double y = fontsize * .03;

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
            SizedBox(height: 16.r),
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
    double x = fontsize * .008;
    double y = fontsize * .03;
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
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Text(
                  '  LACTOSE',
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
    double x = fontsize * .008;
    double y = fontsize * .03;

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
            SizedBox(height: screenHeight * 0.01),
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
    double x = fontsize * .008;
    double y = fontsize * .03;

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
          children: [],
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
    double x = fontsize * .008;
    double y = fontsize * .03;

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
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Text(
                  '      TOTAL AMOUNT  (Rs)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontsize * .0075,
                    fontWeight: FontWeight.w400,
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
    double x = fontsize * .008;
    double y = fontsize * .03;

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
            SizedBox(height: screenHeight * 0.017),
            Row(
              children: [
                Text(
                  '   Rate        = ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontsize * .008,
                    fontWeight: FontWeight.w400,
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
    double x = fontsize * .008;
    double y = fontsize * .03;

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
            SizedBox(height: screenHeight * 0.017),
            Row(
              children: [
                Text(
                  '   Quantity = ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontsize * .008,
                    fontWeight: FontWeight.w400,
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
    double x = fontsize * .008;
    double y = fontsize * .03;
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
            SizedBox(height: screenHeight * 0.017),
            Row(
              children: [
                Text(
                  '   Bonus    =',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontsize * .008,
                    fontWeight: FontWeight.w400,
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
  }
}

class BorderOnlyContainer extends Container {
  BorderOnlyContainer({
    Key? key,
    required Widget child,
    Color borderColor = Colors.black,
    double borderWidth = 1.0,
    double? width,
    double? height,
    BorderRadius borderRadius = BorderRadius.zero,
  }) : super(
          key: key,
          child: child,
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            borderRadius: borderRadius,
          ),
        );
}
