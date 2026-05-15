// ignore_for_file: library_private_types_in_public_api

import 'package:LactosureConnect/Constant/core/extensions/getx_custom_snackbar.dart';
import 'package:LactosureConnect/widgets/background_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontsize1 = screenWidth + screenHeight;
    double fontsize = fontsize1 + fontsize1 * .4;
    return BackgroundScaffoldb(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 108, 75, 75),
        title: Text(
          'Feedback Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: fontsize * .01,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 120, 10, 10),
        child: Card(
          color: const Color.fromARGB(0, 242, 242, 242),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _fbKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Provide Your Feedback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontsize * .01,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  FormBuilderTextField(
                    name: 'name',
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'email',
                    style: const TextStyle(color: Colors.white),
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Your Email',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'feedback',
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Feedback',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.01, screenHeight * 0.02, 0, 0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          // Submit feedback logic goes here
                          Map<String, dynamic> formData =
                              _fbKey.currentState!.value;
                          // Send email
                          sendEmail(formData);
                        }
                      },
                      icon: const Icon(
                        Icons.feedback,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 2, 39, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendEmail(Map<String, dynamic> formData) async {
    final String customerEmail = formData['email'];
    final String customerName = formData['name'] ?? 'User';

    // Replace 'your_generated_app_password' with the actual app password
    final smtpServer = gmail(
        'tishnu.engineer.at.poornasree.eqp@gmail.com', 'odxv pqgq mnbl ohkk');

    final message = Message()
      ..from = Address(
          customerEmail, customerName) // Use customer's email as the sender
      ..recipients.add('tishnu.engineer.at.poornasree.eqp@gmail.com')
      ..subject = 'Feedback from $customerName'
      ..text = 'Customer Email: $customerEmail\n\n${formData['feedback']}';

    try {
      await send(message, smtpServer);
      Get.customSnackBar(
        statusType: StatusType.success,
        designType: SnackDesign.line,
        title: 'Feedback email sent successfully.',
        compact: true,
      );
    } on MailerException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Please provide mentioned details correctly..',
        compact: true,
      );
    } catch (e) {
      handleUnknownError(e);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(
            255, 16, 135, 75), // Set the background color to green
      ),
    );
  }

  void handleMailerException(MailerException e) {
    if (e.message.contains('535 5.7.8')) {
      showSnackBar('Authentication failed. Please check your credentials.');
    } else {
      showSnackBar('Please provide mentioned details correctly..');
    }
  }

  void handleUnknownError(dynamic e) {
    Get.customSnackBar(
      statusType: StatusType.error,
      designType: SnackDesign.line,
      title: 'An unknown error occurred. Please try again later.',
      compact: true,
    );
  }
}
