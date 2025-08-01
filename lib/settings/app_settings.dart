// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/schedule/notification/notification_page.dart';
import 'package:homesecurity/loginAndRegistor/login_notifier.dart';
import 'package:homesecurity/loginAndRegistor/login_page.dart';
import 'package:homesecurity/profiles/user_profile.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/services/terms_condition.dart';
import 'package:homesecurity/settings/display/display.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:homesecurity/settings/language/language.dart';
import 'package:provider/provider.dart';

class AppSettings extends StatefulWidget {
  final String token;
  const AppSettings({
    super.key,
    required this.token,
  });

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
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
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBars(
                isDarkMode: isDarkMode,
                name: isAmharic ? 'ማስተካከያ' : 'Settings',
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                isAmharic ? 'አካውንት' : 'Account',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width - 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color.fromARGB(91, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        token: widget.token,
                                      )));
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_2_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'ፕሮፋይል' : "Profile",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage(
                                        token: widget.token,
                                      )));
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.notifications_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'መልእክት' : "Notification",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(isAmharic ? 'ዲስፕለይ ' : 'Display & Language',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width - 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color.fromARGB(91, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DisplayPage(
                                        token: widget.token,
                                      )));
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.wb_sunny_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'ዲስፕለይ' : "Display",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Language(token: widget.token)));
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.language_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'ቋንቋ' : "Language",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(isAmharic ? 'Support' : 'Support & About',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 170,
                width: MediaQuery.of(context).size.width - 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color.fromARGB(91, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.support_agent_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'ደግፍ' : "Support",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                                                    width: MediaQuery.of(context).size.width - 25,

                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'ስለኛ' : "About",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()),
                  );},
                        child: SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.rule_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'ውሎች እና መመሪያዎች' : "Terms and Policies",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(isAmharic ? 'ውጣ' : 'Logout',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  final loginNotifier =
                      Provider.of<LoginNotifier>(context, listen: false);
                  loginNotifier.logout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 25,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[900]
                        : const Color.fromARGB(91, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.logout_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(isAmharic ? 'ውጣ' : "Logout",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
