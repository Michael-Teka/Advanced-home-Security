// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/schedule/noticationService.dart';
import 'package:homesecurity/home_page.dart';
import 'package:homesecurity/loginAndRegistor/registor_page.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Method to save the token using shared_preferences
  // Future<void> saveToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('auth_token', token);
  // }

@override
void initState() {
  super.initState();
  _setupFCM();
}

void _setupFCM() async {
  // Ask permission on iOS
  await FirebaseMessaging.instance.requestPermission();

  // Get FCM token
  String? token = await FirebaseMessaging.instance.getToken();
  print("📲 FCM Token: $token");

  // TODO: Send this token to your Django backend

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔔 Foreground message received!');
    print('📩 Message data: ${message.data}');
    if (message.notification != null) {
      print('📢 Notification: ${message.notification!.title}');
        print("📩 Body: ${message.notification!.body}");
      // Show a snackbar or local notification
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.notification!.body ?? '')),
    );
    }
  });

  // When the app is opened from a terminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print('📥 App opened from terminated state with message: ${message.messageId}');
    }
  });

  // When the app is opened from background via notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🕹️ App opened from background with message: ${message.messageId}');
  });
}


  Future<void> login() async {
    const url =
        'http://10.144.36.25:8000/api/accounts/login/';
        // 'http://127.0.0.1:8000/api/accounts/login/';
        // 'https://advanced-home-security-backend-production.up.railway.app/api/accounts/login/';


    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Login successful!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 0, 255, 30),
          behavior: SnackBarBehavior.floating,
        ));

         // 🔔 Initialize OneSignal after login
      await PushNotificationService.initOneSignal(token);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Login failed. Please check your credentials.',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'An error occurred. Please try again.',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromRGBO(0, 212, 255, 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      'assets/images/caani.json',
                      width: 300,
                      height: 200,
                      fit: BoxFit.fill, // Adjust as needed
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xfff2d4b0),
                            Color(0xfffad7be),
                          ]),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255))),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text('Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(
                          color: Color.fromARGB(255, 38, 0, 255), fontSize: 15),
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
