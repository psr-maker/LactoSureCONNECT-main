import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsWidget extends StatefulWidget {
  const ContactUsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactUsWidgetState createState() => _ContactUsWidgetState();
}

class _ContactUsWidgetState extends State<ContactUsWidget> {
  String selectedContact = ''; // Holds the selected contact info

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.contact_phone, color: Colors.white),
            title:
                const Text('Contact us', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Show the dropdown when "Contact us" is tapped
              showContactDropdown(context);
            },
          ),
        ],
      ),
    );
  }

  void showContactDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 180,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Mobile: +919400961291'),
                onTap: () {
                  // Set the selected contact and launch phone dialer
                  launchUrl(Uri.parse('tel:+919400961291'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Address: info@poornasree.com'),
                onTap: () {
                  // Set the selected contact and open Gmail compose
                  launchUrl(Uri.parse('mailto:info@poornasree.com'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text(
                    'Registered Address: 9/57, SRRA- 52, Society Road, Maradu, Ernakulam District, Kochi- 682304, Kerala, India'),
                onTap: () {
                  // Set the selected contact and open Gmail compose

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
