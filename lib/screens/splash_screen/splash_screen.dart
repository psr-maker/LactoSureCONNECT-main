import 'package:LactosureConnect/Constant/core/services/app_services.dart';
import 'package:LactosureConnect/Constant/screens/splash_screen/splash_screen.dart';
import 'package:LactosureConnect/widgets/background_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      color: Colors.black.withOpacity(0.2),
      extendBody: true,
      child: Center(
        child: SpinKitRipple(
          color: Colors.white30,
          size: controller.splashSize,
        ),
      ),
    );
  }
}
