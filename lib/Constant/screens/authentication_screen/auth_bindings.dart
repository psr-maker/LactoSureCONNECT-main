part of 'auth_screen.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    getUserDetailsFromSharedPreferences();

    Get.lazyPut<AuthController>(() => AuthController());
  }
}

Future<void> getUserDetailsFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  email = prefs.getString('email') ?? '';
  uid = prefs.getString('uid') ?? '';
  password = prefs.getString('password') ?? '';

  // Print retrieved values
  print('Retrieved User Details:');
  print('Email: $email');
  print('UID: $uid');
  print('Password: $password');
  EmailAndPasswordAuthForm.uidcontroller.text = uid;
  AuthController.emailController.text = email;
  AuthController.passwordController.text = password;

}

