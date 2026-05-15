import 'package:LactosureConnect/Constant/routes/app_pages.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../enums.dart';

part 'firebase_helpers/auth_helper.dart';
part 'firebase_helpers/app_check.dart';

/// Contains all the app wide services related to the app.
class AppServices extends GetxService {
  static AppServices instance = Get.find();

  late final FirebaseApp firebaseApp;
  late final AuthHelper authHelper;

  Future<AppServices> init() async {
    firebaseApp = await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBu8srRSJflnL-YeWRy9AxdwAGPLzQxS6U',
        authDomain: 'localhost',
        projectId: 'poornasree-online',
        appId: '1:843857105917:android:074f1cda8e962bfe47ff94',
        messagingSenderId: '',
      ),
    );

    return this;
  }

  Future<void> bootStrap() async {
    authHelper = AuthHelper();
    //.... Initialize other helpers such as cloud storage or fire store database
  }
}
