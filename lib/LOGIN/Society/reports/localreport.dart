import 'dart:convert'; // Import json for decoding JSON strings
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:LactosureConnect/Constant/core/extensions/getx_custom_snackbar.dart';
import 'package:LactosureConnect/Constant/screens/authentication_screen/auth_screen.dart';
import 'package:LactosureConnect/widgets/buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:LactosureConnect/widgets/custom_text_field.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime fromDate =
    DateTime.now().subtract(Duration(days: 0)); // Example: 7 days ago
DateTime toDate = DateTime.now();

String fromd = fromDate.toString().substring(0, 10);

String tod = fromDate.toString().substring(0, 10);

class SavedFilesPage extends StatefulWidget {
  @override
  _SavedFilesPageState createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {
  List<Map<String, dynamic>> _savedData = [];
  TextEditingController farmeridreport = TextEditingController();
  TextEditingController machineidreport = TextEditingController();
  TextEditingController passwordd = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('table_data');
    if (jsonData != null) {
      List<dynamic> decodedData = json.decode(jsonData);
      List<Map<String, dynamic>> savedData = List<Map<String, dynamic>>.from(
          decodedData); // Convert decoded data to list of maps
      setState(() {
        _savedData = savedData;
      });
    }
  }

  Future<void> showClearAllConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text('Are you sure you want to clear all data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 2, 39, 70)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _clearAllData();

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: const Size(0, 35),
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showNotSuccessNotification(BuildContext context) async {
    Get.customSnackBar(
      statusType: StatusType.error,
      designType: SnackDesign.line,
      title: 'Wrong password',
      compact: true,
    );
  }

  void showSuccessNotification(BuildContext context) async {
    Get.customSnackBar(
      statusType: StatusType.success,
      designType: SnackDesign.line,
      title: 'Successfully cleared',
      compact: true,
    );
  }

  void password(BuildContext context) {
    bool obscureText = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Enter Password',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: passwordd,
                    obscureText: obscureText,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                    onTap: () {},
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                checkCredentialsSociety(context);
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkCredentialsSociety(BuildContext context) async {
    String collectionCenterName = AuthController.emailController.text;
    String uidc = EmailAndPasswordAuthForm.uidcontroller.text;
    String p = passwordd.text;
    print(collectionCenterName);
    print(uidc);
    print(passwordd);
    const apiUrl =
        'https://LactosureConnect.azurewebsites.net/api/CollectionCenterAdd/checkCredentials';

    final response = await http.get(
      Uri.parse(
          '$apiUrl?collectionCenterName=$collectionCenterName&uniqueID=$uidc&Password=$p'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _clearAllData();
      showSuccessNotification(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      showNotSuccessNotification(context);
      final data = json.decode(response.body);

      print('Invalid credentials: ${data['Message']}');
      // Add your logic for handling invalid credentials
    }
  }

  Future<void> _clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('table_data');
    setState(() {
      _savedData.clear();
    });
    showSuccessNotification(context);
  }

  Future<void> _downloadCSV() async {
    print('hello');

    // Request storage permission
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Storage permission is required to download the file.'),
      ));
      return;
    }

    List<List<dynamic>> csvData = [];

    // Add big heading
    csvData.add([
      'Local Report', // Adjust the heading text as needed
    ]);

    // Add empty rows for spacing
    for (int i = 0; i < 1; i++) {
      csvData.add(['']);
    }

    // Add header row
    csvData.add([
      'DateTime',
      'Society ID',
      'Farmer ID',
      'Channel',
      'Fat (%)',
      'SNF (%)',
      'CLR',
      'Water (%)',
      'Rate',
      'Quantity (L)',
      'Total Amount',
      'Incentive',
    ]);

    // Add data rows
    csvData.addAll(_savedData.map((data) => [
          data['Save Date'] ?? 'N/A',
          data['Society ID'] ?? 'N/A',
          data['FarmerId'] ?? 'N/A',
          data['Channel'] ?? 'N/A',
          data['FAT'] ?? 'N/A',
          data['SNF'] ?? 'N/A',
          data['CLR'] ?? 'N/A',
          data['Water'] ?? 'N/A',
          data['Rate'] ?? 'N/A',
          data['Quantity'] ?? 'N/A',
          data['Total Amount'] ?? 'N/A',
          data['Bonus'] ?? 'N/A',
        ]));
    csvData.add([
      '', // Adjust the heading text as needed
    ]);
    csvData.add([
      'Thank you', // Adjust the heading text as needed
    ]);
    csvData.add([
      'Poornasree Equipments',
    ]);
    // Add empty rows for spacing
    for (int i = 0; i < 1; i++) {
      csvData.add(['']);
    }

    String csv = const ListToCsvConverter().convert(csvData);

    // Specify the desired folder path
    String desiredFolderPath =
        '/storage/emulated/0/Download'; // Replace with your desired folder path

    // Create the folder if it doesn't exist
    Directory desiredFolder = Directory(desiredFolderPath);
    if (!await desiredFolder.exists()) {
      await desiredFolder.create(recursive: true);
    }

    String fileName = 'Local Report.csv'; // Set your desired file name
    File file = File('$desiredFolderPath/$fileName');

    // Check for file existence and rename if necessary
    int count = 1;
    while (await file.exists()) {
      fileName = 'local Report_$count.csv';
      file = File('$desiredFolderPath/$fileName');
      count++;
    }
    _showFileDownloadNotification(context, file, fileName);

    try {
      await file.writeAsBytes(Uint8List.fromList(utf8.encode(csv)));
      print('File saved at: ${file.path}');
      _handleNotificationTap(file.path); // Print the file path
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Failed to save CSV file.'),
      ));
    }
  }

  void _showFileDownloadNotification(
      BuildContext context, File file, String fileName) async {
    Get.customSnackBar(
      statusType: StatusType.success,
      designType: SnackDesign.line,
      title: 'Downloaded Successfully',
      compact: true,
    );
    Future.delayed(Duration(seconds: 2), () {
      _handleNotificationTap(file.path); // Print the file path
    });
  }

  Future<void> _handleNotificationTap(String payload) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        OpenFile.open(file.path);
      } else {
        print('User canceled the file picking');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  void showr(BuildContext context) async {
    final List<Map<String, dynamic>> options = [
      {'name': 'DateTime', 'icon': Icons.calendar_today},
      {'name': 'Channel', 'icon': Icons.water_drop},
      {'name': 'Machine-ID', 'icon': Icons.device_hub},
      {'name': 'Farmer-ID', 'icon': Icons.person},
      {'name': 'Reset', 'icon': Icons.restore_sharp},
    ];

    String? selectedOption = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(10, 90, 0, 0),
      items: options.map((Map<String, dynamic> option) {
        return PopupMenuItem<String>(
          value: option['name'],
          child: Row(
            children: [
              Icon(option['icon']),
              SizedBox(width: 8), // Adjust the spacing between icon and text
              Text(option['name']),
            ],
          ),
          textStyle: TextStyle(
            backgroundColor: Color.fromARGB(255, 10, 6, 33),
          ),
        );
      }).toList(),
      elevation: 8, // Adjust the elevation if needed
    );

    // Handle the selected option here
    if (selectedOption != null) {
      if (selectedOption == 'DateTime') {
        // Your DateTime logic here
      } else if (selectedOption == 'Channel') {
        String? selectedChannel = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(10, 90, 0, 0),
          items: ['CH1', 'CH2', 'CH3'].map((String channel) {
            return PopupMenuItem<String>(
              value: channel,
              child: Text(channel),
            );
          }).toList(),
          elevation: 8, // Adjust the elevation if needed
        );

        if (selectedChannel != null) {
          // Filter _savedData based on the selected channel
          setState(() {
            _savedData = _savedData.where((item) {
              return item['Channel'] == selectedChannel;
            }).toList();
          });
        }
      } else if (selectedOption == 'Machine-ID') {
        Machineidwise(context);
        // Your Machine-ID logic here
      } else if (selectedOption == 'Farmer-ID') {
        Farmeridwise(context);
      } else if (selectedOption == 'Reset') {
        // Resetting the data to its original state
        _loadSavedData();
      }
      setState(() {}); // Update UI
    }
  }

  void Machineidwise(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5), // Adjust the sigmaX and sigmaY for blur intensity
          child: AlertDialog(
            backgroundColor: Color.fromARGB(
                149, 17, 3, 22), // Make AlertDialog background transparent
            title: Text(
              'Enter details\n', // Add your title text here
              style: TextStyle(
                color: const Color.fromARGB(255, 187, 183, 183),
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            content: CustomTextField(
              controller: machineidreport,
              labelText: 'Machine ID',
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.number,
              onTap: () {},
            ),
            actions: <Widget>[
              SecondaryButton(
                maxHeight: 40,
                maxWidth: 80,
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
              PrimaryButton(
                maxHeight: 40,
                maxWidth: 60,
                onTap: () {
                  String enteredMachineID = machineidreport.text.trim();
                  double parsedMachineID = double.tryParse(enteredMachineID) ??
                      0.0; // Parsing machine ID as double, defaulting to 0.0 if parsing fails
                  String formattedMachineID = parsedMachineID
                      .toStringAsFixed(1); // Formatting to one decimal point

                  if (enteredMachineID.isNotEmpty) {
                    // Filter _savedData based on the entered machine ID
                    List<Map<String, dynamic>> filteredData = _savedData
                        .where(
                            (item) => item['Machine ID'] == formattedMachineID)
                        .toList();
                    setState(() {
                      _savedData.clear();
                      _savedData.addAll(filteredData);
                    });
                  }
                  print(enteredMachineID);
                  print(formattedMachineID);
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void Farmeridwise(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5), // Adjust the sigmaX and sigmaY for blur intensity
          child: AlertDialog(
            backgroundColor: Color.fromARGB(
                149, 17, 3, 22), // Make AlertDialog background transparent
            title: Text(
              'Enter details\n', // Add your title text here
              style: TextStyle(
                color: const Color.fromARGB(255, 187, 183, 183),
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            content: CustomTextField(
              controller: farmeridreport,
              labelText: 'Farmer ID',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              onTap: () {},
            ),
            actions: <Widget>[
              SecondaryButton(
                maxHeight: 40,
                maxWidth: 80,
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
              PrimaryButton(
                maxHeight: 40,
                maxWidth: 60,
                onTap: () {
                  String enteredFarmerID = farmeridreport.text.trim();
                  double parsedFarmerID = double.tryParse(enteredFarmerID) ??
                      0.0; // Parsing machine ID as double, defaulting to 0.0 if parsing fails
                  String formattedFarmerID = parsedFarmerID
                      .toStringAsFixed(1); // Formatting to one decimal point

                  if (formattedFarmerID.isNotEmpty) {
                    // Filter _savedData based on the entered machine ID
                    List<Map<String, dynamic>> filteredData = _savedData
                        .where((item) => item['FarmerId'] == formattedFarmerID)
                        .toList();
                    setState(() {
                      _savedData.clear();
                      _savedData.addAll(filteredData);
                    });
                  }
                  print(enteredFarmerID);
                  print(formattedFarmerID);
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    double iconSize = screenWidth * 0.06; // Adjust the icon size as needed
    double paddingValueright = screenWidth * 0.05;
    double paddingValueleft =
        screenWidth * 0.05; // Adjust the padding value as needed
    double fontSize = screenWidth * 0.03; // Adjust the font size as needed
    double fontSize1 = screenWidth * 0.04;
    return PopScope(
        canPop: true,
        onPopInvoked: (_) async {},
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Local Collection Reports',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize1),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _downloadCSV();
                  },
                  icon: Icon(
                    Icons.download,
                    color: Color.fromARGB(
                        255, 17, 131, 15), // Set the color to red
                  ),
                  iconSize: iconSize,
                ),
                IconButton(
                  onPressed: () {
                    showClearAllConfirmationDialog();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red, // Set the color to red
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _loadSavedData();

                    Future.delayed(Duration(seconds: 1), () {
                      showr(context);
                    });
                  },
                  icon: Icon(
                    Icons.sort,
                    color:
                        Color.fromARGB(255, 62, 62, 62), // Set the color to red
                  ),
                  iconSize: iconSize,
                ),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _savedData.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.38, screenHeight * 0.5, 0, 0),
                          child: Text('No saved files found'),
                        ),
                      )
                    : DataTable(
                        columns: [
                          DataColumn(
                              label: Text('Date Time',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Society ID',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Machine ID',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Farmer ID',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Channel',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('FAT(%)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('SNF(%)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('CLR',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Protein(%)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Lactose(%)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Salts(%)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Water(%)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Temperature(D)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Rate(Rs.)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Quantity(L)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Total Amount(Rs.)',
                                  style: TextStyle(fontSize: fontSize))),
                          DataColumn(
                              label: Text('Bonus(Rs.)',
                                  style: TextStyle(fontSize: fontSize))),
                        ],
                        rows: _savedData
                            .map(
                              (data) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      formatSaveDate(
                                          data['Save Date'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(data['Society ID'] ?? 'N/A',
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      (double.parse(data['Machine ID'] ?? '0')
                                              .toInt())
                                          .toString(), // Convert to integer string
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      (double.parse(data['FarmerId'] ?? '0')
                                              .toInt())
                                          .toString(), // Convert to integer string
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      removeDecimal(data['Channel'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['FAT'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['SNF'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['CLR'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['Protien'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['Lactos'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['Salt'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['Water'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(
                                          data['Temperature'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['Rate'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['Quantity'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(
                                          data['Total Amount'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                  DataCell(Text(
                                      _formatValue(data['Bonus'] ?? 'N/A'),
                                      style: TextStyle(fontSize: fontSize))),
                                ],
                              ),
                            )
                            .toList(),
                      ),
              ),
            )));
  }
}

String _formatValue(String value) {
  if (value == null || value.isEmpty) {
    return '0.00';
  } else {
    double parsedValue = double.parse(value);
    if ((parsedValue * 100) % 10 == 0) {
      return parsedValue.toStringAsFixed(2);
    } else {
      return parsedValue.toString();
    }
  }
}

RegExp regExp = RegExp(r'\.0$');
String removeDecimal(String value) {
  // Replace ".0" at the end of the string with an empty string
  return value.replaceAll(regExp, '');
}

String formatSaveDate(String saveDate) {
  // Parse the input date string
  DateTime dateTime = DateTime.parse(saveDate);

  // Format the date as desired
  String formattedDate = DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);

  return formattedDate;
}
