import 'package:LactosureConnect/Constant/routes/app_pages.dart';
import 'package:LactosureConnect/Constant/screens/authentication_screen/auth_screen.dart';

import 'package:LactosureConnect/Constant/screens/splash_screen/splash_screen.dart';
import 'package:LactosureConnect/Constant/screens/welcome_screen/welcome_screen_choose.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
      preventDuplicates: true,
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.WELCOME,
      page: () => const WelcomeScreenchoose(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.AUTH,
      page: () => const AuthScreen(),
      binding: AuthBindings(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
      transitionDuration: 600.milliseconds,
    ),
  ];
}
