import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/add_camera_service.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AddCameraPage extends StatefulWidget {
  final String token;
  const AddCameraPage({super.key, 
    required this.token,
  });

  @override
  _AddCameraPageState createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCameraName;
  String _cameraUrl = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedCameraName based on the isAmharic flag
    _selectedCameraName = 'Bedroom';
  }

  List<String> get cameraNames {
    return ['Bedroom', 'Living Room', 'Kitchen', 'Park', 'Garden'];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final isAmharic = Provider.of<LanguageNotifier>(context).language == 'am';

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [Colors.black, Colors.grey.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xfff2d4b0),
                    Color(0xfffad7be),
                    Color(0xff9ecbd5),
                    Color(0xff9ecbd5)
                  ],
                ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey[900]
                              : const Color.fromARGB(91, 255, 255, 255),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 93),
                      Text(
                        isAmharic ? 'ካሜራ ይጨምሩ' : 'Add Camera',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 130,
                    width: MediaQuery.of(context).size.width - 25,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[900]
                          : const Color.fromARGB(91, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCameraName,
                      decoration: InputDecoration(
                        labelText:
                            isAmharic ? 'የካሜራ ስም ይምረጡ' : 'Select Camera Name',
                      ),
                      dropdownColor: const Color.fromARGB(255, 96, 93, 74),
                      items: cameraNames.map((name) {
                        return DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCameraName = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 100,
                    width: MediaQuery.of(context).size.width - 25,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[900]
                          : const Color.fromARGB(91, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: isAmharic ? 'ካሜራ URL' : 'Camera URL'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isAmharic
                              ? 'እባኮወት የካሜራ URL ያስገቡ'
                              : 'Please enter a camera URL';
                        }

                        String pattern =
                            r'^(https?:\/\/)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/[^\s]*)?$';
                        RegExp regExp = RegExp(pattern);

                        if (!regExp.hasMatch(value)) {
                          return isAmharic
                              ? 'እባኮወት ትክክለኛ URL ያስገቡ'
                              : 'Please enter a valid URL';
                        }
                        return null;
                      },
                      onSaved: (value) => _cameraUrl = value!,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? Lottie.asset(
                          'assets/images/loding.json',
                          width: 100,
                          height: 100,
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() => isLoading = true);

                              try {
                                CameraService(widget.token)
                                    .addCamera(_selectedCameraName, _cameraUrl);
                                setState(() => isLoading = false);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: isAmharic
                                        ? const Text(
                                            'ካሜራ በተሳካ ሁኔታ ተጨምረ',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : const Text(
                                            'Camera added successfully',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isAmharic
                                        ? 'ካመሬ መጨመር አልተሳካም'
                                        : 'Failed to add camera'),
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 0, 0),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xff9ecbd5),
                                  Color(0xff9ecbd5)
                                ]),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255))),
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(isAmharic ? 'ጨርስ' : 'Submit',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
}
