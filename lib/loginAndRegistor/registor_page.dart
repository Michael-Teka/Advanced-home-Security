import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homesecurity/loginAndRegistor/login_page.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final String registerUrl = '${allbaseUrl}api/accounts/register/';

  Future<void> register() async {
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'username': _usernameController.text,
          'email': _emailController.text,
          'first_name': _fnameController.text,
          'last_name': _lnameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            isAmharic ? 'በተሳካ ሁኔታ ተመዝግበዋል' : 'Registered successfully!',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        ));
        // Navigate to login page after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Registration failed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            isAmharic
                ? 'ምዝገባው አልተሳካም፣ እባኮወት መልሰው ይሞክሩ'
                : 'Registration failed. Please try again.',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (error) {
      // Handle network errors
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          isAmharic
              ? 'ያልታወቀ ስህተት፣ እባኮወት መልሰው ይሞክሩ'
              : 'An error occurred. Please try again.',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        behavior: SnackBarBehavior.floating,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Lottie.asset(
                        'assets/images/register.json',
                        width: 300,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      isAmharic ? 'ይመዝገቡ' : 'Register',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    buildTextFormField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty
                          ? isAmharic
                              ? 'እባኮወት Userame ያስገቡ'
                              : 'Please enter your username'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextFormField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return isAmharic
                              ? 'እባኮወት email ያስገቡ'
                              : 'Please enter your email';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return isAmharic
                              ? 'እባኮወት ትክክለኛ ኢሜል አድራሻ ያስገቡ'
                              : 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    buildTextFormField(
                      controller: _fnameController,
                      label: 'First Name',
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty
                          ? isAmharic
                              ? 'እባኮወት የመጀመሪያ ስሞውን ያስገቡ'
                              : 'Please enter your First Name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextFormField(
                      controller: _lnameController,
                      label: 'Last Name',
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty
                          ? isAmharic
                              ? 'እባኮወት የመጨረሻ ስሞውን ያስገቡ'
                              : 'Please enter your Last Name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextFormField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) => value!.isEmpty
                          ? isAmharic
                              ? 'እባኮወት password ያስገቡ'
                              : 'Please enter your password'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? Lottie.asset(
                            'assets/images/loding.json',
                            width: 100,
                            height: 100,
                          )
                        :ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                await register(); // Make sure this is async
                                setState(() => isLoading = false);
                              }
                            },
                    
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xfff2d4b0), Color(0xfffad7be)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            isAmharic ? 'ይመዝገቡ' : 'Register',
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
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        isAmharic
                            ? 'Account አለወት? ከዚህ ይግቡ'
                            : 'Already have an account? Login here',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : const Color.fromARGB(255, 38, 0, 255),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to reduce redundancy in form fields
  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
