import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/add_camera_service.dart';

class AddCameraPage extends StatefulWidget {
  final String token;
  final bool isdark;
  AddCameraPage({
    required this.token,
    required this.isdark,
  });

  @override
  _AddCameraPageState createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCameraName = 'Bedroom'; // Default selected name
  String _cameraUrl = '';

  final List<String> cameraNames = [
    'Bedroom',
    'Living Room',
    'Kitchen',
    'Park',
    'Garden'
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.isdark;

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
                        'Add Camera',
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
                      decoration:
                          const InputDecoration(labelText: 'Select Camera Name'),
                      dropdownColor: const Color(0xff9ecbd5),
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
                      initialValue:"https://",
                      decoration: const InputDecoration(labelText: 'Camera URL'),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter a camera URL';
                      validator: (value) {
                        if (value == null || value.trim().isEmpty || value == "https:// ") {
                          return 'Please enter a camera URL';
                        }

                        String pattern =
                            r'^(https?:\/\/)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/[^\s]*)?$';
                        RegExp regExp = RegExp(pattern);

                        if (!regExp.hasMatch(value)) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                      onSaved: (value) => _cameraUrl = value!,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        CameraService(widget.token)
                            .addCamera(_selectedCameraName, _cameraUrl);
                      }
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xff9ecbd5), Color(0xff9ecbd5)]),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255))),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text('Submit',
                            style: TextStyle(
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
