import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:homesecurity/profiles/profile_function.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final String token;

  const UserProfile({required this.token, super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? userData;
  bool isEditing = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  File? _image;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _fetchImage();
  }

  Future<void> fetchUserData() async {
    final profileData = await fetchUserProfile(widget.token);
    if (profileData != null) {
      setState(() {
        userData = profileData;
        usernameController.text = userData!['username'];
        firstNameController.text = userData!['first_name'];
        lastNameController.text = userData!['last_name'];
        emailController.text = userData!['email'];
      });
    }
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> updateUserProfile() async {
    final updatedData = await updateUserProfileRequest(
      token: widget.token,
      username: usernameController.text,
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      password: passwordController.text.isNotEmpty
          ? passwordController.text
          : null, // Optional password update
    );

    if (updatedData != null) {
      setState(() {
        userData = updatedData;
        usernameController.text = userData!['username'];
        firstNameController.text = userData!['first_name'];
        lastNameController.text = userData!['last_name'];
        emailController.text = userData!['email'];
      });
    }
  }

  Future<void> _fetchImage() async {
    String? imageUrl = await FetchProfileImage.fetchProfileImage(widget.token);
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${allbaseUrl}api/accounts/upload-profile-image/'),
    );
    request.headers['Authorization'] = 'Token ${widget.token}';
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);
      setState(() {
        _imageUrl = jsonData['image_url'];
      });
    } else {
      print('Image upload failed');
    }
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
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBars(
                  isDarkMode: isDarkMode,
                  name: isAmharic ? 'ፕሮፋይል' : 'Profile'),
              const SizedBox(height: 100),
              Center(
                  child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageUrl != null
                      ? NetworkImage(_imageUrl!)
                      : const AssetImage('assets/images/cctv.png') as ImageProvider,
                ),
              )),
              const SizedBox(height: 15),
              userData == null
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAmharic ? "ዩዘር-ስም" : 'Username:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              isAmharic ? "የመጀመሪያ ስም" : 'First Name:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              isAmharic ? "የመጨረሻ ስም" : 'Last Name:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              isAmharic ? "ኢሜል" : 'Email:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            buildEditableField(
                                usernameController, isDarkMode, isEditing),
                            const SizedBox(height: 5),
                            buildEditableField(
                                firstNameController, isDarkMode, isEditing),
                            const SizedBox(height: 5),
                            buildEditableField(
                                lastNameController, isDarkMode, isEditing),
                            const SizedBox(height: 5),
                            buildEditableField(
                                emailController, isDarkMode, isEditing),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: isDarkMode
                            ? const Color.fromARGB(220, 150, 148, 148)
                            : const Color.fromARGB(255, 242, 212, 176),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: isEditing ? updateUserProfile : toggleEditMode,
                      child: Text(
                          isEditing
                              ? isAmharic
                                  ? 'መዝግብ'
                                  : 'Save'
                              : isAmharic
                                  ? 'አስተካክል'
                                  : 'Edit',
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? const Color.fromARGB(220, 150, 148, 148)
                            : const Color.fromARGB(255, 242, 212, 176),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        showChangePasswordDialog(context, (newPassword) {
                          updateUserProfileRequest(
                            token: widget.token,
                            username: usernameController.text,
                            email: emailController.text,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            password: newPassword,
                          ).then((updatedData) {
                            if (updatedData != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  isAmharic
                                      ? 'ፓስወርድ በተሳካ ሁኔታ ተቀይሯል! እባኮወት እንደገና ይግቡ'
                                      : "Password updated successfully! Please login again ",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isAmharic
                                      ? 'ፓስወርድ መቀየር አልተሳካም'
                                      : "Failed to update password."),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 0, 0),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          });
                        }, isDarkMode);
                      },
                      child: Text(isAmharic ? "ፓስወርድ ይቀይሩ" : "Change Password",
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
