import 'package:flutter/material.dart';
import 'package:homesecurity/profiles/profile_function.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';

class UserProfile extends StatefulWidget {
  final bool isdark;
  final String token;

  const UserProfile({required this.isdark, required this.token, super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final profileData = await fetchUserProfile(widget.token);
    if (profileData != null) {
      setState(() {
        userData = profileData;
      });
    }
  }

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
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBars(
                isDarkMode: isDarkMode,
                name: 'Profile',
              ),
              const SizedBox(height: 100),
              const Padding(
                padding: EdgeInsets.fromLTRB(160, 0, 10, 16),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/image1.png'),
                ),
              ),
              const SizedBox(height: 15),
              userData == null
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Username:',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Full Name:',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Email:',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              height: 45,
                              width: 280,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[900]
                                    : const Color.fromARGB(91, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${userData!['username']}',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              height: 45,
                              width: 280,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[900]
                                    : const Color.fromARGB(91, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${userData!['first_name']} ${userData!['last_name']}',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              height: 45,
                              width: 280,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[900]
                                    : const Color.fromARGB(91, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${userData!['email']}',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {},
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xfff2d4b0),
                              Color(0xfffad7be),
                            ]),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255))),
                        child: Container(
                          height: 50,
                          width: 150,
                          alignment: Alignment.center,
                          child: const Text('Edit',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {},
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xfff2d4b0),
                              Color(0xfffad7be),
                            ]),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255))),
                        child: Container(
                          height: 50,
                          width: 200,
                          alignment: Alignment.center,
                          child: const Text('Change Password',
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
            ],
          ),
        ),
      ),
    );
  }
}
