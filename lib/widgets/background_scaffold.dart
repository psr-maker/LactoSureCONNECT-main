import 'dart:ui';

import 'package:LactosureConnect/Constant/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    required this.child,
    this.backgroundBlur = 8,
    this.resizeToAvoidBottomInset,
    this.appBar,
    super.key,
    required Color color,
    this.bottomNavigationBar,
    required bool extendBody, // Add this property for customization
  });

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final BottomNavigationBar? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromARGB(255, 0, 0, 0), // Set navigation bar color
      statusBarColor: Color.fromARGB(0, 125, 0, 0), // Set status bar color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      backgroundColor: const Color.fromARGB(
          255, 0, 0, 0), // Set background color to transparent
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 60,
            right: 0,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(BACKGROUND_ASSET),
                  fit: BoxFit.fill,
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
          SizedBox(height: 1.sh, width: 1.sw, child: child),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BackgroundScaffoldd extends StatelessWidget {
  const BackgroundScaffoldd({
    required this.child,
    this.backgroundBlur = 8,
    this.resizeToAvoidBottomInset,
    this.appBar,
    super.key,
    required Color color,
    this.bottomNavigationBar,
    required bool extendBody,
    required Widget body, // Add this property for customization
  });

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final BottomNavigationBar? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromARGB(255, 0, 0, 0), // Set navigation bar color
      statusBarColor: Color.fromARGB(0, 125, 0, 0), // Set status bar color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      backgroundColor:
          Colors.transparent, // Set background color to transparent
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 60,
            right: 0,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(BACKGROUND_ASSET),
                  fit: BoxFit.fill,
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
          SizedBox(height: 1.sh, width: 1.sw, child: child),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BackgroundScaffoldx extends StatelessWidget {
  const BackgroundScaffoldx({
    required this.child,
    this.backgroundBlur = 8,
    this.resizeToAvoidBottomInset,
    this.appBar,
    Key? key,
    required Color color,
    this.bottomNavigationBar, // Make this property optional
  }) : super(key: key);

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final BottomNavigationBar? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromARGB(255, 0, 0, 0), // Set navigation bar color
      statusBarColor: Color.fromARGB(0, 125, 0, 0), // Set status bar color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 60,
            right: 0,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(BACKGROUND_ASSET),
                  fit: BoxFit.fitHeight,
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
          SizedBox(height: 1.sh, width: 1.sw, child: child),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BackgroundScaffoldb extends StatelessWidget {
  const BackgroundScaffoldb({
    required this.child,
    this.backgroundBlur = 0,
    this.resizeToAvoidBottomInset,
    this.appBar,
    Key? key,
    required this.color,
  }) : super(key: key);

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              height: screenHeight * 1,
              width: screenWidth * 1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/4.png'),
                  fit: BoxFit.fill,
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
              decoration: BoxDecoration(),
            ),
          ),
          // Black screen
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          // Child
          SizedBox(
            height: screenHeight * 1,
            width: screenWidth * 1,
            child: child,
          ),
          // Transparent container with circular border
        ],
      ),
    );
  }
}

class BackgroundScaffolddash extends StatelessWidget {
  const BackgroundScaffolddash({
    required this.child,
    this.backgroundBlur = 0,
    this.resizeToAvoidBottomInset,
    this.appBar,
    Key? key,
    required this.color,
  }) : super(key: key);

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              height: screenHeight * 1,
              width: screenWidth * 1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/5.png'),
                  fit: BoxFit.fill,
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
              decoration: BoxDecoration(),
            ),
          ),
          // Black screen
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          // Child
          SizedBox(
            height: screenHeight * 1,
            width: screenWidth * 1,
            child: child,
          ),
          // Transparent container with circular border
        ],
      ),
    );
  }
}
