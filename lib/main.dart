import 'package:LactosureConnect/LOGIN/Society/Bluetooth/state.dart';
import 'package:LactosureConnect/Constant/core/constants.dart';
import 'package:LactosureConnect/Constant/core/helper/preload_image.dart';

import 'package:LactosureConnect/Constant/routes/app_pages.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Fixed Portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Preload background Image
  await preLoadImage(const AssetImage(BACKGROUND_ASSET));

  {
    runApp(const MainApp());
    // [
    //   Permission.bluetooth,
    //   Permission.bluetoothScan,
    //   Permission.bluetoothConnect,
    //   // Add this line
    // ].request().then((status) {

    // });
  }

  // Print if storage permission is enabled
}

class MainApp extends StatelessWidget {
  const MainApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (_, __) {
      return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Poornasree Equipments',
          getPages: AppPages.pages,
          initialRoute: AppRoutes.SPLASH,
          theme: ThemeData(useMaterial3: true).copyWith(
            primaryColor: const Color(0xFFE58742),
            primaryColorLight: const Color(0xFFEDA53F),
          ),
          routes: const {});
    });
  }
}

