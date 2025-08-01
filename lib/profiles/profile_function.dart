import 'dart:convert';
import 'package:homesecurity/loginAndRegistor/login_page.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> fetchUserProfile(String token) async {
  const url =
      '${allbaseUrl}api/accounts/profile/';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print('Failed to load profile. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching profile: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> updateUserProfileRequest({
  required String token,
  required String username,
  required String email,
  required String firstName,
  required String lastName,
  String? password,
}) async {
  const url = '${allbaseUrl}api/accounts/update-profile/';

  try {
    final Map<String, dynamic> body = {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };

    // Include password only if it's provided
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to update profile. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error updating profile: $e');
    return null;
  }
}

Widget buildEditableField(
    TextEditingController controller, bool isDarkMode, bool isEditing,
    {bool readOnly = false}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
      height: 45,
      width: 250,
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[900]
            : const Color.fromARGB(91, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditing || readOnly,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black, fontSize: 18),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    ),
  );
}

void showChangePasswordDialog(
    BuildContext context, Function(String) onConfirm, bool isDarkMode) {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: isDarkMode
            ? Colors.grey.shade900
            : const Color.fromARGB(255, 176, 242, 241),
        title: Text(
          "Change Password",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "New Password",
                    labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : Colors.black),
                    ))),
            const SizedBox(height: 10),
            TextField(
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                  fillColor: isDarkMode ? Colors.white : Colors.black,
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white : Colors.black),
                  )),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isDarkMode
                  ? const Color.fromARGB(220, 150, 148, 148)
                  : const Color.fromARGB(255, 242, 212, 176),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel",
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? const Color.fromARGB(220, 150, 148, 148)
                  : const Color.fromARGB(255, 242, 212, 176),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              String newPassword = newPasswordController.text;
              String confirmPassword = confirmPasswordController.text;

              if (newPassword.isEmpty || confirmPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Fields cannot be empty! Please fill all fields"),
                    backgroundColor: Color.fromARGB(255, 255, 0, 0),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Passwords do not match! Please try again"),
                    backgroundColor: Color.fromARGB(255, 255, 0, 0),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              onConfirm(newPassword);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(
                  ),
                ),
              );
            },
            child: Text("Change",
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          ),
        ],
      );
    },
  );
}

class FetchProfileImage {
  static Future<String?> fetchProfileImage(String token) async {
    final response = await http.get(
      Uri.parse('${allbaseUrl}api/accounts/get-profile-image/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['image_url'];
    }
    return null;
  }
}
