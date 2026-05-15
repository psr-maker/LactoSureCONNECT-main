import 'dart:ui';

import 'package:LactosureConnect/Constant/core/constants.dart';
import 'package:LactosureConnect/Constant/core/helper/text_helper.dart';
import 'package:LactosureConnect/Constant/routes/app_pages.dart';
import 'package:LactosureConnect/LOGIN/Society/Bluetooth/BLE/screens/scan_screen.dart';

import 'package:LactosureConnect/LOGIN/Society/dashboard/dashboard.dart';

import 'package:LactosureConnect/widgets/background_scaffold.dart';
import 'package:LactosureConnect/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreenchoose extends StatefulWidget {
  const WelcomeScreenchoose({super.key});

  // =========== ANIMATIONS ============
  // Animation Durations
  static final _welcomeAniDuration = 600.ms;

  @override
  State<WelcomeScreenchoose> createState() => _WelcomeScreenchooseState();
}

class _WelcomeScreenchooseState extends State<WelcomeScreenchoose> {
  Duration get _modalAniDelay {
    return WelcomeScreenchoose._welcomeAniDuration * 0.8;
  }

  Duration get _modalContentDelay {
    return WelcomeScreenchoose._welcomeAniDuration * 0.8 * 2;
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isDenied) {
      // Permission has been denied.
      // You may want to display a dialog explaining why the permission is needed
      // and allow the user to go to the app settings to enable the permission.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundBlur: 0,
      color: Colors.black,
      extendBody: true,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, 0.085),
                    child: Hero(
                      tag: DISPLAY_HERO_TAG,
                      child: Text(
                        'Welcome',
                        style: TextHelper.displayTextStyle,
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .moveY(
                            begin: TextHelper.textSize(
                                  '',
                                  TextHelper.displayTextStyle,
                                ).height *
                                0.7,
                            duration: WelcomeScreenchoose._welcomeAniDuration,
                          )
                          .fadeIn(
                              begin: 0.0,
                              duration:
                                  WelcomeScreenchoose._welcomeAniDuration),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.black.withOpacity(0.2),
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.primaryColor.withOpacity(0.07),
                    blurRadius: 20,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8.0,
                  sigmaY: 8.0,
                ),
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 42).r,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Transform.scale(
                            scale: 0.5, // Adjust the scale factor as needed
                            child: Image.asset(
                              'assets/POONASREE OFFICIAL FULL LOGO PNG.png', // Replace with your image file path
                            ),
                          )
                              .animate()
                              .moveY(
                                begin: TextHelper.textSize(
                                      'Welcome',
                                      TextHelper.displayTextStyle,
                                    ).height *
                                    0.7,
                                duration:
                                    WelcomeScreenchoose._welcomeAniDuration,
                              )
                              .fadeIn(
                                  begin: 0.0,
                                  duration:
                                      WelcomeScreenchoose._welcomeAniDuration),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  maxHeight: 35.r,
                                  onTap: () {
                                    _requestLocationPermission();
                                    Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          ScanScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final begin = Offset(0.00010.sw, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOutCubic;
                                        var tween =
                                            Tween(begin: begin, end: end).chain(
                                          CurveTween(curve: curve),
                                        );

                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ));
                                  },
                                  text: 'Get Started ',
                                ),
                              )
                                  .animate(delay: _modalContentDelay)
                                  .fadeIn(
                                    duration: WelcomeScreenchoose
                                            ._welcomeAniDuration *
                                        0.68,
                                  )
                                  .moveY(
                                    begin: 30,
                                    duration: WelcomeScreenchoose
                                            ._welcomeAniDuration *
                                        0.68,
                                  ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Powered by\nPoornasree Equipments',
                        textAlign: TextAlign.center,
                        style: TextHelper.captionTextStyle.copyWith(
                          fontStyle: FontStyle.normal,
                        ),
                      ).animate(delay: _modalContentDelay * 1.2).fadeIn(),
                    ],
                  ),
                ),
              ),
            )
                .animate(
                  delay: _modalAniDelay,
                )
                .moveY(
                  duration: WelcomeScreenchoose._welcomeAniDuration,
                  begin: 300,
                  end: 0,
                ),
          ],
        ),
      ),
    );
  }
}
