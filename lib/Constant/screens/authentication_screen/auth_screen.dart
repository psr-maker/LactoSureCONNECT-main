import 'dart:convert';

import 'package:LactosureConnect/Constant/core/constants.dart';
import 'package:LactosureConnect/Constant/core/extensions/custom_dialog_extension.dart';
import 'package:LactosureConnect/Constant/core/extensions/getx_custom_snackbar.dart';
import 'package:LactosureConnect/Constant/core/helper/text_helper.dart';
import 'package:LactosureConnect/Constant/core/services/app_services.dart';

import 'package:LactosureConnect/Constant/screens/welcome_screen/welcome_screen_choose.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:LactosureConnect/widgets/background_scaffold.dart';
import 'package:LactosureConnect/widgets/buttons.dart';
import 'package:LactosureConnect/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_controller.dart';
part 'auth_bindings.dart';

part 'enums/page_type.dart';
part 'enums/auth_state.dart';

part 'widgets/page_type_changer.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: controller.pageStartAniDelay,
      tween: Tween<double>(begin: 0.0, end: 8.0),
      builder: (_, double val, Widget? child) {
        return BackgroundScaffold(
          color: Colors.black.withOpacity(0.2),
          backgroundBlur: val,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          appBar: AppBar(
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreenchoose()),
                  );
                },
                color: Colors.white,
              )),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            // Page TITLE display
            Hero(
              tag: DISPLAY_HERO_TAG,
              child: Material(
                color: Colors.transparent,
                child: GetBuilder<AuthController>(
                  id: controller.pageTypeSwitcherTag,
                  builder: (_) => Text(
                    controller.pageType.value.title,
                    style: TextHelper.displayTextStyle,
                    textAlign: TextAlign.center,
                  )
                      .animate(target: controller.isSignInPage ? 1 : 0)
                      .shake(duration: controller.pageSwitchDuration),
                ),
              ),
            ),
            SizedBox(height: 50.r),
            const EmailAndPasswordAuthForm(),
            SizedBox(height: 50.r),
            providersDivider(),
            SizedBox(height: 50.r),

            SizedBox(height: 40.r),
            const _PageTypeChanger(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget providersDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0),
                  Colors.white.withOpacity(0.15),
                ],
                stops: const [0.2, 1],
              ),
            ),
            height: 1.5,
          ),
        )
            .animate(delay: controller.pageStartAniDelay * 1.6)
            .moveX(duration: controller.pageAniDuration, begin: -0.2.sw)
            .fadeIn(duration: controller.pageAniDuration),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0),
                ],
                stops: const [0, 0.8],
              ),
            ),
            height: 1.5,
          ),
        )
            .animate(delay: controller.pageStartAniDelay * 1.6)
            .moveX(duration: controller.pageAniDuration, begin: 0.2.sw)
            .fadeIn(duration: controller.pageAniDuration),
      ],
    );
  }
}
