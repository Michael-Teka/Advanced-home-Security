import 'package:ethiopian_datetime/ethiopian_datetime.dart';
import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/add_camera.dart';
import 'package:homesecurity/camera%20settings/camera_lists.dart';
import 'package:homesecurity/camera%20settings/schedule/schedule_datas.dart';
import 'package:homesecurity/door%20settings/door_setting.dart';
import 'package:homesecurity/loginAndRegistor/login_notifier.dart';
import 'package:homesecurity/loginAndRegistor/login_page.dart';
import 'package:homesecurity/profiles/profile_function.dart';
import 'package:homesecurity/profiles/user_profile.dart';
import 'package:homesecurity/reusables/camera_in_row.dart';
import 'package:homesecurity/settings/app_settings.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({required this.token, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> _getGreeting() async {
    final hour = DateTime.now().hour;
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';

    String greeting;
    if (hour < 12) {
      greeting = isAmharic ? 'አንዴት አደሩ' : 'Good Morning';
    } else if (hour < 17) {
      greeting = isAmharic ? 'አንዴት ዋሉ' : 'Good Afternoon';
    } else {
      greeting = isAmharic ? 'አንዴት አመሹ' : 'Good Evening';
    }

    return greeting;
  }

  @override
  Widget build(BuildContext context) {
    String token = widget.token;
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
                SizedBox(
                  child: Row(
                    children: [
                      FutureBuilder<String>(
                        future: _getGreeting(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('Hello, User',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'F2'));
                          } else {
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'F2'),
                            );
                          }
                        },
                      ),
                      const Spacer(),
                      FutureBuilder(
                        future:
                            FetchProfileImage.fetchProfileImage(widget.token),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfile(token: token)),
                                );
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(snapshot.data as String),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfile(token: token)),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/cctv.png'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${DateTime.now().toLocal().day}/${DateTime.now().toLocal().month}/${DateTime.now().toLocal().year} GC',
                  style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${ETDateTime.now().toLocal().day}/${ETDateTime.now().toLocal().month}/${ETDateTime.now().toLocal().year} EC',
                  style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 50),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CamerasInRow(
                    isDarkMode: isDarkMode,
                    token: token,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Lottie.asset(
                    'assets/images/iconca.json',
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraLists(
                                        token: token,
                                      )),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 170,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[900]
                                  : const Color.fromARGB(91, 255, 255, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Image.asset(
                                          'assets/images/cctv.png')),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    isAmharic ? "ካሜራዎች" : "All Cameras",
                                    // style: TextStyle(
                                    //     fontSize: 20,
                                    //     fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCameraPage(
                                        token: token,
                                      )),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 170,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[900]
                                  : const Color.fromARGB(91, 255, 255, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                        'assets/images/addcamera.png')),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  isAmharic ? "ካሜራ ይጨምሩ" : "Add Camera",
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoorSetting(
                                        token: token,
                                      )),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 170,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[900]
                                  : const Color.fromARGB(91, 255, 255, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                        'assets/images/doorsign.png')),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  isAmharic ? "የበር ካሜራ" : "Door Camera",
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppSettings(
                                        token: token,
                                      )),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 170,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[900]
                                  : const Color.fromARGB(91, 255, 255, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                        'assets/images/setting.png')),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  isAmharic ? "ማስተካከያ" : "Settings",
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                )
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
                DetectionSchedulePage(token: token),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final loginNotifier =
                          Provider.of<LoginNotifier>(context, listen: false);
                      loginNotifier.logout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: Container(
                      height: 90,
                      width: 110,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[900]
                            : const Color.fromARGB(91, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          SizedBox(
                              height: 25,
                              width: 25,
                              child: Image.asset('assets/images/out.png')),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(isAmharic ? "ይውጡ" : "Logout"
                              // style: TextStyle(
                              //     fontSize: 20,
                              //     fontWeight: FontWeight.bold),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
