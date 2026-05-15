// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

part of 'auth_screen.dart';

late bool _isSelected;

class AuthController extends GetxController {
  final authService = AppServices.instance.authHelper;
  static AuthController get instance => AuthController();
  // ===== GetBuilder Tags ======
  final pageTypeSwitcherTag = 'page-type-switcher';
  final authStateTag = 'auth-state';
  String uidd = '';
  static TextEditingController uid = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  @override
  void onInit() {
    if ((Get.arguments as String) == _PageType.signUp.title) {
      pageType.value = _PageType.signUp;
    }
    _workerInit();
    super.onInit();
  }

  void _workerInit() {
    debounce(
      pageType,
      (_) {
        emailErrorMessage.value = passwordErrorMessage.value = null;
        update([pageTypeSwitcherTag]);
      },
      time: pageSwitchDuration,
    );

    ever(emailAuthState, (_) => update([authStateTag]));
  }

  // ====== Page Type =======
  final pageType = _PageType.signIn.obs;
  bool get isSignInPage => pageType.value == _PageType.signIn;

  void switchPageType() {
    if (pageType.value == _PageType.signIn) {
      pageType.value = _PageType.signUp;
    } else {
      pageType.value = _PageType.signIn;
    }
  }

  // ====== ANIMATION =========
  final pageStartAniDelay = 200.ms;
  final pageAniDuration = 100.ms;
  final pageSwitchDuration = 400.ms;

  // ======== NATIVE AUTHENTICATION ========
  // ------- Email Pass Auth Properties-------
  final emailAuthState = _AuthState.initialized.obs;
  bool get isEmailAuthInProgress {
    return emailAuthState.value == _AuthState.inProgress;
  }

  bool get isEmailAuthInProgressOrComplete {
    return isEmailAuthInProgress || emailAuthState.value == _AuthState.complete;
  }

  final formKey = GlobalKey<FormState>();

  final passwordObscure = true.obs;
  final emailErrorMessage = RxnString();
  final passwordErrorMessage = RxnString();

  // ------- Reset Password Properties--------
  final resetFormKey = GlobalKey<FormState>();
  final resetEmailController = TextEditingController();
  final resetEmailErrorMessage = RxnString();

  // ------- Phone Auth Properties---------
  final phoneAuthState = _AuthState.initialized.obs;
  bool get isPhoneAuthInProgress {
    return phoneAuthState.value == _AuthState.inProgress;
  }

  bool get isPhoneAuthInProgressOrComplete {
    return isPhoneAuthInProgress || phoneAuthState.value == _AuthState.complete;
  }

  final isOTPMode = false.obs;
  final phoneNumberFormKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final phoneAuthErrorMessage = RxnString();
  final countryCode = '91'.obs;
  String? _verificationId;

  // ------ Native Helper METHOD --------
  void _resetErrorMessages() {
    emailErrorMessage.value = null;
    passwordErrorMessage.value = null;
    resetEmailErrorMessage.value = null;
    phoneAuthErrorMessage.value = null;
  }

  // ------ Email Auth Methods --------
  void passwordVisibilityToggler() {
    passwordObscure.value = !passwordObscure.value;
  }

  Future<void> emailPassOnSubmitHandler() async {
    if (isEmailAuthInProgressOrComplete) return;
    emailAuthState.value = _AuthState.inProgress;
    check5 = 0;
    if (!formKey.currentState!.validate()) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint('Email Validation Failed');

      return;
    }

    _resetErrorMessages();

    try {
      if (isSignInPage) {
        await authService.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        await authService.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      }
      emailAuthState.value = _AuthState.complete;
    } on FirebaseAuthException catch (e) {
      _resetErrorMessages();

      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());

      if (e.code == 'email-already-in-use') {
        check5 = 0;
        Get.customSnackBar(
          statusType: StatusType.error,
          designType: SnackDesign.line,
          title: 'Email already registered.',
          compact: true,
        );
        emailErrorMessage.value = 'Email already registered.';
      }
      if (e.code == 'wrong-password') {
        passwordErrorMessage.value = 'Invalid password.';
      }
      check5 = 5;
    } catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }

  // ------ Forgot Pass Method --------
  Future<void> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) {
      debugPrint('Reset Email Local Validation Failed');
    }

    _resetErrorMessages();

    try {
      await authService.resetPassword(email: resetEmailController.text);
      Get.customSnackBar(
        statusType: StatusType.success,
        designType: SnackDesign.line,
        title: 'Reset email sent successfully.',
        compact: true,
      );
      Get.close(1);
    } on FirebaseAuthException catch (e) {
      _resetErrorMessages();
      debugPrint(e.toString());

      if (e.code == 'user-not-found') {
        resetEmailErrorMessage.value = 'Please register first with the user.';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ------ Phone Auth Methods--------
  Future<void> phoneAuthOnSubmitHandler(String value) async {
    if (isPhoneAuthInProgressOrComplete) return;
    phoneAuthState.value = _AuthState.inProgress;

    if (!phoneNumberFormKey.currentState!.validate()) {
      phoneAuthState.value = _AuthState.initialized;
      debugPrint('${isOTPMode.value ? 'OTP' : 'Phone'} Validation Failed');
      return;
    }

    _resetErrorMessages();

    if (isOTPMode.value && _verificationId != null) {
      await verifyOTP(value);
      return;
    } else if (!isOTPMode.value) {
      await verifyPhoneNumber();
    }
  }

  Future<void> verifyPhoneNumber() async {
    final phoneNumber = '+${countryCode.value} ${phoneNumberController.text}';

    try {
      await authService.verifyPhoneNumber(
        phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          // Move to OTP verification
          isOTPMode.value = true;
          _verificationId = verificationId;
          // This is not `complete` state because we will use the same state for OTP.
          phoneAuthState.value = _AuthState.initialized;
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            phoneAuthErrorMessage.value = 'Invalid Phone Number';
          } else if (e.code == 'too-many-requests') {
            Get.customSnackBar(
              statusType: StatusType.error,
              compact: true,
              designType: SnackDesign.line,
              title: 'Too Many Requests',
            );
          } else {
            Get.customSnackBar(
              statusType: StatusType.error,
              designType: SnackDesign.line,
              title: 'Server Error',
              message: 'Something went wrong. Try again or contact support.',
            );
          }
          phoneAuthState.value = _AuthState.initialized;
          _verificationId = null;
          debugPrint('Verification error: $e');
        },
      );
    } catch (e) {
      phoneAuthState.value = _AuthState.initialized;
      _verificationId = null;
      debugPrint('Phone Number error: $e');
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Unknown Error',
        message: 'Please check your network and try again.',
      );
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        throw Exception('Verification Id Not Set');
      }

      await authService.verifyOTP(otp, _verificationId!);
      phoneAuthState.value = _AuthState.complete;
    } on FirebaseAuthException catch (e) {
      _resetErrorMessages();
      phoneAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());

      if (e.code == 'invalid-verification-code') {
        phoneAuthErrorMessage.value = 'Incorrect code.';
      } else {
        Get.customSnackBar(
          statusType: StatusType.error,
          designType: SnackDesign.line,
          title: 'Server Error',
          message: 'Something went wrong. Try again or contact support.',
        );
      }
    } catch (e) {
      phoneAuthState.value = _AuthState.initialized;
      debugPrint('Phone Number error: $e');
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Unknown Error',
        message: 'Please check your network and try again.',
      );
    }
  }

  void editButtonOnTap() {
    if (isPhoneAuthInProgressOrComplete) {
      return;
    }
    isOTPMode.value = false;
    phoneAuthErrorMessage.value = null;
    _verificationId = null;
  }

  // ------ Local Validation --------
  String? emailValidation(
    String? value, {
    bool isResetEmailValidation = false,
  }) {
    if (value == null || value.isEmpty) {
      isResetEmailValidation
          ? resetEmailErrorMessage.value = 'Please enter an email.'
          : emailErrorMessage.value = 'Please enter an email.';
      return isResetEmailValidation
          ? resetEmailErrorMessage.value
          : emailErrorMessage.value;
    }

    const String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final RegExp emailRegex = RegExp(emailPattern);

    if (!emailRegex.hasMatch(value)) {
      isResetEmailValidation
          ? resetEmailErrorMessage.value = 'Please enter a valid email address.'
          : emailErrorMessage.value = 'Please enter a valid email address.';
      return isResetEmailValidation
          ? resetEmailErrorMessage.value
          : emailErrorMessage.value;
    }

    resetEmailErrorMessage.value = null;
    emailErrorMessage.value = null;
    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      passwordErrorMessage.value = 'Please enter a password';
      return passwordErrorMessage.value;
    }
    passwordErrorMessage.value = null;
    return passwordErrorMessage.value;
  }

  String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      phoneAuthErrorMessage.value = 'Please enter a phone number';
      return phoneAuthErrorMessage.value;
    }

    const String numericPattern = r'^-?[0-9]+$';
    final RegExp numericRegex = RegExp(numericPattern);

    if (!numericRegex.hasMatch(value)) {
      phoneAuthErrorMessage.value = 'Please enter a valid phone number.';
      return phoneAuthErrorMessage.value;
    }

    if (value.length != 10) {
      phoneAuthErrorMessage.value = 'Please enter 10 digit phone number.';
      return phoneAuthErrorMessage.value;
    }

    phoneAuthErrorMessage.value = null;
    return null;
  }

  String? otpValidationHandler(String? value) {
    if (value == null || value.isEmpty) {
      phoneAuthErrorMessage.value = 'Please enter the OTP.';
      return phoneAuthErrorMessage.value;
    } else {
      const String otpPattern = r'^\d+$';
      final RegExp otpRegex = RegExp(otpPattern);
      if (!otpRegex.hasMatch(value)) {
        phoneAuthErrorMessage.value = 'OTP should contain only numbers.';
        return phoneAuthErrorMessage.value;
      }

      if (value.length != 6) {
        phoneAuthErrorMessage.value = 'Please enter a 6-digit code.';
        return phoneAuthErrorMessage.value;
      }
    }

    phoneAuthErrorMessage.value = null;
    return phoneAuthErrorMessage.value;
  }

  // ========== GOOGLE SIGN IN ==========
  Future<void> googleSignInHandler() async {
    if (isEmailAuthInProgressOrComplete) return;
    emailAuthState.value = _AuthState.inProgress;

    try {
      // Google Sign In
      await authService.signInWithGoogle();
      emailAuthState.value = _AuthState.complete;
    } on PlatformException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Please check your connectivity and try again later.',
        compact: true,
      );
    } on FirebaseAuthException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());

      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: e.message,
        compact: true,
      );
    } catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }

  // ========== FACEBOOK SIGN IN ==========
  Future<void> facebookSignInHandler() async {
    if (isEmailAuthInProgressOrComplete) return;
    emailAuthState.value = _AuthState.inProgress;

    try {
      // Google Sign In
      await authService.signInWithFacebook();
      emailAuthState.value = _AuthState.complete;
    } on PlatformException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Please check your connectivity and try again later.',
        compact: true,
      );
    } on FirebaseAuthException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());

      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: e.message,
        compact: true,
      );
    } catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }
}

int check1 = 0;
int check2 = 0;
int check3 = 0;
int check4 = 0;
int check5 = 0;
Future<void> saveUserDetailsToSharedPreferences(
    String email, String uid, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('uid', uid);
  await prefs.setString('password', password);

  // Print a message indicating that the data has been saved
}

String email = '';
String uid = '';
String password = '';

class EmailAndPasswordAuthForm extends GetView<AuthController> {
  const EmailAndPasswordAuthForm({super.key});
  static TextEditingController uidcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: AuthController.emailController,
            labelText: 'Email or Username',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onTap: () {
              check1 = 0;
              check2 = 0;
              check3 = 0;
              check4 = 0;
              check5 = 0;
            },
          )
              .animate(delay: controller.pageStartAniDelay * 0.55)
              .moveX(duration: controller.pageAniDuration, begin: 0.1.sw)
              .fadeIn(duration: controller.pageAniDuration),
          SizedBox(height: 2.r),
          CustomTextField(
            controller: uidcontroller,
            labelText: 'Unique ID',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.visiblePassword,
            onTap: () {
              check1 = 0;
              check2 = 0;
              check3 = 0;
              check4 = 0;
              check5 = 0;
            },
          )
              .animate(delay: controller.pageStartAniDelay * 0.55)
              .moveX(duration: controller.pageAniDuration, begin: 0.1.sw)
              .fadeIn(duration: controller.pageAniDuration),
          SizedBox(height: 2.r),
          Obx(() {
            return CustomTextField(
              controller: AuthController.passwordController,
              labelText: 'Password',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.passwordObscure.value,
              passwordVisibilityHandler: controller.passwordVisibilityToggler,
              validator: controller.passwordValidation,
              onTap: () {
                check1 = 0;
                check2 = 0;
                check3 = 0;
                check4 = 0;
                check5 = 0;
              },
            );
          })
              .animate(delay: controller.pageStartAniDelay * 0.8)
              .moveX(duration: controller.pageAniDuration, begin: 0.1.sw)
              .fadeIn(duration: controller.pageAniDuration),
          SizedBox(height: 2.r),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12).r,
              child: ObxValue((passErrorMsg) {
                return Text(
                  passErrorMsg.value ?? '',
                  style: TextHelper.captionTextStyle.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }, controller.passwordErrorMessage),
            ),
          ),
          SizedBox(height: 0.r),
          Align(
            alignment: Alignment.centerRight,
            child: _forgotPasswordButton(),
          ),
          SizedBox(height: 30.r),
          GetBuilder<AuthController>(
            id: controller.authStateTag,
            builder: (_) {
              return PrimaryButton(
                onTap: () {
                  if (_isSelected == false) {
                    if (!controller.isEmailAuthInProgress) {
                      saveUserDetailsToSharedPreferences('', '', '');
                      controller
                          .emailPassOnSubmitHandler(); // Call your existing handler function
                      Future.delayed(const Duration(seconds: 2), () {
                        saveUserDetailsToSharedPreferences('', '', '');
                        getCurrentUserUid();
                      });
                   
                    }
                  } else if (!controller.isEmailAuthInProgress) {
                    saveUserDetailsToSharedPreferences(
                        AuthController.emailController.text,
                        'Admin',
                        AuthController.passwordController.text);
                    controller
                        .emailPassOnSubmitHandler(); // Call your existing handler function
                    Future.delayed(const Duration(seconds: 2), () {
                      saveUserDetailsToSharedPreferences(
                          AuthController.emailController.text,
                          uidcontroller.text,
                          AuthController.passwordController.text);
                      getCurrentUserUid();
                    });
                
                  }
                },
                maxHeight: 56,
                maxWidth: 0.7.sw,
                child: GetBuilder<AuthController>(
                    id: controller.pageTypeSwitcherTag,
                    builder: (_) {
                      return AnimatedSwitcher(
                        duration: controller.pageSwitchDuration,
                        child: controller.isEmailAuthInProgress
                            ? Center(
                                key: const ValueKey('loading'),
                                child: SpinKitRipple(
                                  color: TextHelper.buttonTextStyle.color,
                                ),
                              )
                            : controller.isSignInPage
                                ? Text(
                                    key: const ValueKey(0),
                                    controller.pageType.value.title,
                                    style: TextHelper.buttonTextStyle,
                                  )
                                : Text(
                                    key: const ValueKey(1),
                                    controller.pageType.value.title,
                                    style: TextHelper.buttonTextStyle,
                                  ),
                      );
                    }),
              )
                  .animate(target: controller.isEmailAuthInProgress ? 1 : 0)
                  .desaturate(duration: controller.pageSwitchDuration);
            },
          )
              .animate(delay: controller.pageStartAniDelay * 1.6)
              .fadeIn(duration: controller.pageAniDuration * 0.6),
          SizedBox(height: 20.r),
          Padding(
            padding: EdgeInsets.fromLTRB(
                screenWidth * 0.43, screenHeight * 0.0, 0, 0),
            child: Row(
              children: [
                tick(),
                Align(
                  alignment: Alignment.centerRight,
                  child: _remembermeButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return GetBuilder<AuthController>(
      id: controller.pageTypeSwitcherTag,
      builder: (context) {
        return GestureDetector(
          onTap: _resetPasswordDialog,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.001),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              'Forgot Password?',
              style: TextHelper.forgotPassTextStyle,
            ),
          ),
        )
            .animate(target: controller.isSignInPage ? 0 : 1)
            .moveY(duration: controller.pageSwitchDuration, end: 20)
            .fadeOut(duration: controller.pageSwitchDuration)
            .swap(builder: (_, __) {
          return SizedBox(
            height: TextHelper.textSize(
                  'Forgot Password?',
                  TextHelper.forgotPassTextStyle,
                ).height +
                7.5 * 2,
          );
        });
      },
    )
        .animate(delay: controller.pageStartAniDelay)
        .moveY(duration: controller.pageAniDuration, begin: 16)
        .fadeIn(duration: controller.pageAniDuration);
  }

  Widget _remembermeButton() {
    return GetBuilder<AuthController>(
      id: controller.pageTypeSwitcherTag,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.001),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 0,
            ),
            child: Text('Remember me?', style: TextHelper.forgotPassTextStyle),
          ),
        )
            .animate(target: controller.isSignInPage ? 0 : 1)
            .moveY(duration: controller.pageSwitchDuration, end: 20)
            .fadeOut(duration: controller.pageSwitchDuration)
            .swap(builder: (_, __) {
          return SizedBox(
            height: TextHelper.textSize(
                  'Remember me?',
                  TextHelper.forgotPassTextStyle,
                ).height +
                6 * 2,
          );
        });
      },
    )
        .animate(delay: controller.pageStartAniDelay)
        .moveY(duration: controller.pageAniDuration, begin: 16)
        .fadeIn(duration: controller.pageAniDuration);
  }

  Widget tick() {
    return GetBuilder<AuthController>(
      id: controller.pageTypeSwitcherTag,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.001),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 0,
            ),
            child: TickBoxButton(
              initialValue: true,
              onChanged: (newValue) {},
            ),
          ),
        )
            .animate(target: controller.isSignInPage ? 0 : 1)
            .moveY(duration: controller.pageSwitchDuration, end: 20)
            .fadeOut(duration: controller.pageSwitchDuration)
            .swap(builder: (_, __) {
          return SizedBox(
            height: TextHelper.textSize(
                  'Remember me?',
                  TextHelper.forgotPassTextStyle,
                ).height +
                6 * 2,
          );
        });
      },
    )
        .animate(delay: controller.pageStartAniDelay)
        .moveY(duration: controller.pageAniDuration, begin: 16)
        .fadeIn(duration: controller.pageAniDuration);
  }

  void _resetPasswordDialog() {
    Get.customDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      barrierLabel: 'Reset Password Dialog',
      barrierDismissible: true,
      child: Form(
        key: controller.resetFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reset password',
              style: TextHelper.dialogHeaderTextStyle,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: controller.resetEmailController,
              hintText: 'Enter email',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => controller.emailValidation(
                value,
                isResetEmailValidation: true,
              ),
              fillColor: Colors.white.withOpacity(0.05),
              borderColor: Colors.transparent,
              onTap: () {},
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12).r,
                child: ObxValue((emailErrorMsg) {
                  return Text(
                    emailErrorMsg.value ?? '',
                    style: TextHelper.captionTextStyle.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }, controller.resetEmailErrorMessage),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'An reset link will be sent to your email address for verification.',
              style: TextHelper.dialogCaptionTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CaptionButton(
                    onTap: () => Get.close(1),
                    maxWidth: 160,
                    maxHeight: 60,
                    text: 'Cancel',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PrimaryButton(
                        maxHeight: 60,
                        onTap: controller.resetPassword,
                        text: 'Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).then((_) {
      controller.resetEmailController.clear();
      controller.resetEmailErrorMessage.value = null;
    });
  }
}

String uidd = '';
void getCurrentUserUid() {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    // User is signed in
    uidd = user.uid;
  } else {
    // User is not signed in
  }
}




class TickBoxButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const TickBoxButton({
    super.key,
    required this.initialValue,
    this.onChanged,
  });

  @override
  _TickBoxButtonState createState() => _TickBoxButtonState();
}

class _TickBoxButtonState extends State<TickBoxButton> {
  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChanged?.call(_isSelected);
        });
      },
      child: Container(
        width: 24.0, // Adjust the size as needed
        height: 24.0, // Adjust the size as needed
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.0, color: const Color.fromARGB(255, 192, 183, 183)),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: _isSelected
            ? const Icon(Icons.check,
                size: 20.0,
                color: Colors.green) // Green color for the tick icon
            : null,
      ),
    );
  }
}

void showNotSuccessNotification(BuildContext context) {
  check1 = check1 + check2 + check3 + check4 + check5;

  print(check1);
  if (check1 == 15) {
    Get.customSnackBar(
      statusType: StatusType.error,
      designType: SnackDesign.line,
      title: 'Invalid Credentials',
      compact: true,
    );
  }
}
