// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/schedule/notification/notification_service.dart';
import 'package:homesecurity/home_page.dart';
import 'package:homesecurity/loginAndRegistor/login_notifier.dart';
import 'package:homesecurity/loginAndRegistor/registor_page.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;


@override
void initState() {
  super.initState();
  _setupFCM();
  
}

void _setupFCM() async {
    await Firebase.initializeApp();

  // Ask permission on iOS
  await FirebaseMessaging.instance.requestPermission();

  // Get FCM token
  String? token = await FirebaseMessaging.instance.getToken();
  print("📲 FCM Token: $token");


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
    const url = '${allbaseUrl}api/accounts/login/';
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';
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

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            isAmharic ? 'በተሳካ ገብተዋል!' : 'Login successful!',
            style: const TextStyle(color:  Colors.black),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
      await PushNotificationService.initOneSignal(token);

            final loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
            loginNotifier.login(token);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              token: token,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            isAmharic
                ? 'መግባት አልተሳካም፣ እባኮወት መልሰው ይሞክሩ'
                : 'Login failed. Please check your credentials.',
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          isAmharic
              ? 'ያልታወቀ ስህተት፣ እባኮወት መልሰው ይሞክሩ'
              : 'An error occurred. Please try again.',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final isAmharic = Provider.of<LanguageNotifier>(context).language == 'am';

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isAmharic ? 'እንኳን ደህና መጡ!' : 'Welcome!',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Center(
                      child: Lottie.asset(
                        'assets/images/login.json',
                        width: 300,
                        height: 200,
                        fit: BoxFit.fill, // Adjust as needed
                      ),
                    ),
                    const SizedBox(height: 32),
                    isAmharic
                        ? const Text(
                            'ይግቡ',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'User Name',
                        border: const OutlineInputBorder(),
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.person,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isAmharic
                              ? 'እባኮወት username ያስገቡ'
                              : 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isAmharic
                              ? 'እባኮወት password ያስገቡ'
                              : 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                await login(); // Make sure this is async
                                setState(() => isLoading = false);
                              }
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xfff2d4b0),
                                    Color(0xfffad7be)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  isAmharic ? 'ግባ' : 'Login',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                        child: Text(
                          isAmharic
                              ? "Account የለውትም? ከዚህ ይመዝገቡ"
                              : "Don't have an account? Register here",
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color.fromARGB(255, 38, 0, 255),
                              fontSize: 15),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
