import 'dart:ui';

import 'package:LactosureConnect/Constant/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundScaffold1 extends StatelessWidget {
  const BackgroundScaffold1({
    required this.child,
    this.backgroundBlur = 8,
    this.resizeToAvoidBottomInset,
    this.appBar,
    super.key,
    required Color color,
  });

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromARGB(255, 0, 0, 0), // Set navigation bar color
      statusBarColor: Color.fromARGB(0, 125, 0, 0), // Set status bar color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background - Image or fallback to gradient
          Positioned(
            bottom: 60,
            right: 0,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(BACKGROUND_ASSET1),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFF0F0D13),
                    Color(0xFF423441),
                    Color(0xFF325D93),
                  ],
                ),
              ),
            ),
          ),
          // Gradient
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: backgroundBlur,
              sigmaY: backgroundBlur,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color(0xFF080B11).withOpacity(1.0),
                    const Color(0xFF080B11).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Child
          SizedBox(height: 1.sh, width: 1.sw, child: child),
          // Transparent container with circular border
        ],
      ),
    );
  }
}

class BackgroundScaffold2 extends StatelessWidget {
  const BackgroundScaffold2({
    required this.child,
    this.backgroundBlur = 6,
    this.resizeToAvoidBottomInset,
    this.appBar,
    super.key,
    required Color color,
  });

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromARGB(255, 0, 0, 0), // Set navigation bar color
      statusBarColor: Color.fromARGB(0, 125, 0, 0), // Set status bar color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background - Image or fallback to gradient
          Positioned(
            bottom: 60,
            right: 0,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/animal-3536058_1920.jpg'),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFF0F0D13),
                    Color(0xFF423441),
                    Color(0xFF325D93),
                  ],
                ),
              ),
            ),
          ),
          // Gradient
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: backgroundBlur,
              sigmaY: backgroundBlur,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color(0xFF080B11).withOpacity(1.0),
                    const Color(0xFF080B11).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Child
          SizedBox(height: 1.sh, width: 1.sw, child: child),
          // Transparent container with circular border
        ],
      ),
    );
  }
}

class BackgroundScaffold3 extends StatelessWidget {
  const BackgroundScaffold3({
    required this.child,
    this.backgroundBlur = 4,
    this.resizeToAvoidBottomInset,
    this.appBar,
    super.key,
    required Color color,
  });

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromARGB(255, 0, 0, 0), // Set navigation bar color
      statusBarColor: Color.fromARGB(0, 125, 0, 0), // Set status bar color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background - Image or fallback to gradient
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/b19f1683fa06f2b293c28a0c345ad44a.jpg'),
                  fit: BoxFit.fitHeight,
                  filterQuality: FilterQuality.medium,
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFF0F0D13),
                    Color(0xFF423441),
                    Color(0xFF325D93),
                  ],
                ),
              ),
            ),
          ),
          // Gradient
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: backgroundBlur,
              sigmaY: backgroundBlur,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color(0xFF080B11).withOpacity(1.0),
                    const Color(0xFF080B11).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Child
          SizedBox(height: 1.sh, width: 1.sw, child: child),
          // Transparent container with circular border
        ],
      ),
    );
  }
}
