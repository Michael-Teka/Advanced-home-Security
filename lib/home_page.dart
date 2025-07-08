import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/add_camera.dart';
import 'package:homesecurity/camera%20settings/camera_lists.dart';
import 'package:homesecurity/camera%20settings/schedule/noticationService.dart';
import 'package:homesecurity/detection_history.dart/detection_history_screen.dart';
// import 'package:homesecurity/door%20settings/door_setting.dart';
import 'package:homesecurity/door_cam/door_setting.dart';
import 'package:homesecurity/loginAndRegistor/login_page.dart';
import 'package:homesecurity/profiles/user_profile.dart';
import 'package:homesecurity/reusables/camera_in_row.dart';
import 'package:lottie/lottie.dart';
// import 'package:http/http.dart' as http;
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:homesecurity/services/clock_function.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({required this.token, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;

  // final List<String> carouselImages = [
  //   'assets/images/image1.png',
  //   'assets/images/image2.png',
  //   'assets/images/image3.png',
  // ];
  // @override
// void initState() {
//   super.initState();
//   NotificationService.initOneSignal(widget.token);
// }
    Future<String> _getGreeting() async {
    final hour = DateTime.now().hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return greeting;
  }

  @override
  Widget build(BuildContext context) {
    String token = widget.token;

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                        const SizedBox(width: 160),
                        // Container(
                        //   width: 100,
                        //   height: 100,
                        //   child: Clock(),
                        // ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                      isdark: isDarkMode, token: token)),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/images/image1.png'),
                          ),
                        ),
                      ],
                    ),
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
                      'assets/images/caani.json',
                      width: 300,
                      height: 200,
                      fit: BoxFit.fill, // Adjust as needed
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 25),
                  //   child: CarouselSlider(
                  //     options: CarouselOptions(
                  //       height: 160,
                  //       autoPlay: true,
                  //       enlargeCenterPage: true,
                  //       enableInfiniteScroll: true,
                  //       viewportFraction: 0.9,
                  //     ),
                  //     items: carouselImages.map((imagePath) {
                  //       return ClipRRect(
                  //         borderRadius: BorderRadius.circular(12),
                  //         child: Container(
                  //           color: const Color.fromRGBO(0, 212, 255, 100),
                  //           child: Image.asset(
                  //             imagePath,
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //           ),
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraLists(
                                        token: token,
                                        isDarkMode: isDarkMode,
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
                                  const Text(
                                    "All Cameras",
                                    // style: TextStyle(
                                    //     fontSize: 20,
                                    //     fontWeight: FontWeight.bold),
                                  ),
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
                                        isdark: isDarkMode,
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
                                const Text(
                                  "Add Camera",
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => DoorSetting(
                  //                 name: 'Door Settings',
                  //                 token: token,
                  //                 isdark: isDarkMode,
                  //               )),
                  //     );
                  //   },
                  //   child: Container(
                  //     height: 60,
                  //     width: 170,
                  //     decoration: BoxDecoration(
                  //       color: isDarkMode
                  //           ? Colors.grey[900]
                  //           : const Color.fromARGB(91, 255, 255, 255),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Center(
                  //             child: Row(
                  //               children: [
                  //                 const Padding(
                  //                     padding: EdgeInsets.only(left: 10)),
                  //                 SizedBox(
                  //                     height: 25,
                  //                     width: 25,
                  //                     child: Image.asset(
                  //                         'assets/images/doorsign.png')),
                  //                 const SizedBox(
                  //                   width: 8,
                  //                 ),
                  //                 const Text(
                  //                   "Door Camera",
                  //                   // style: TextStyle(
                  //                   //     fontSize: 20,
                  //                   //     fontWeight: FontWeight.bold),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //     // child: Row(
                  //     //   children: [
                  //     //     const Padding(padding: EdgeInsets.only(left: 10)),
                  //     //     SizedBox(
                  //     //         height: 25,
                  //     //         width: 25,
                  //     //         child: Image.asset('assets/images/doorsign.png')),
                  //     //     const SizedBox(
                  //     //       width: 8,
                  //     //     ),
                  //     //     const Text(
                  //     //       "Door Camera",
                  //     //       // style: TextStyle(
                  //     //       //     fontSize: 20,
                  //     //       //     fontWeight: FontWeight.bold),
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => DetectionHistoryScreen(
                  //                       token: token,
                  //                       // isdark: isDarkMode,
                  //                       name: 'History',
                  //                       // isDark: isDarkMode,
                  //                       isdark: isDarkMode,
                  //                     )),
                  //           );
                  //         },
                  //         child: Container(
                  //           height: 60,
                  //           width: 170,
                  //           decoration: BoxDecoration(
                  //             color: isDarkMode
                  //                 ? Colors.grey[900]
                  //                 : const Color.fromARGB(91, 255, 255, 255),
                  //             borderRadius: BorderRadius.circular(20),
                  //           ),
                  //           child: Row(
                  //             children: [
                  //               const Padding(
                  //                   padding: EdgeInsets.only(left: 10)),
                  //               SizedBox(
                  //                   height: 25,
                  //                   width: 25,
                  //                   child: Image.asset(
                  //                       'assets/images/addcamera.png')),
                  //               const SizedBox(
                  //                 width: 8,
                  //               ),
                  //               const Text(
                  //                 "Detection History",
                  //                 // style: TextStyle(
                  //                 //     fontSize: 20,
                  //                 //     fontWeight: FontWeight.bold),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                   SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoorSetting(
                                        token: token,
                                        // isDarkMode: isDarkMode,
                                        name: 'Door Settings',
                                        isdark: isDarkMode,
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
                                          'assets/images/doorsign.png')),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    "Door Camera",
                                    // style: TextStyle(
                                    //     fontSize: 20,
                                    //     fontWeight: FontWeight.bold),
                                  ),
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
                                  builder: (context) => DetectionHistoryScreen(
                                        token: token,
                                        isdark: isDarkMode,
                                        name: 'History',
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
                                        'assets/images/hstryy.png')),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Detection History",
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                        const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width - 25,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[900]
                          : const Color.fromARGB(91, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 0, 0)),
                          SizedBox(
                              height: 25,
                              width: 25,
                              child: Image.asset('assets/images/mode.png')),
                          const SizedBox(
                            width: 5,
                          ),
                          isDarkMode
                              ? const Text(
                                  "Dark Mode",
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  "Light Mode",
                                  // style: TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold),
                                ),
                          const SizedBox(
                            width: 170,
                          ),
                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                            activeColor: const Color.fromARGB(
                                255, 255, 255, 255), // Sunny mode color
                            inactiveThumbColor: const Color.fromARGB(
                                255, 58, 58, 58), // Night mode color
                            inactiveTrackColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 210,
                    // width: MediaQuery.of(context).size.width - 25,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[900]
                          : const Color.fromARGB(91, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: Text('No Scheduled Data')),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => DoorSetting(
                  //                 name: 'Door Settings',
                  //                 token: token,
                  //                 isdark: isDarkMode,
                  //               )),
                  //     );
                  //   },
                  //   child: Container(
                  //     height: 90,
                  //     width: MediaQuery.of(context).size.width - 25,
                  //     decoration: BoxDecoration(
                  //       color: isDarkMode
                  //           ? Colors.grey[900]
                  //           : const Color.fromARGB(91, 255, 255, 255),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: Row(
                  //         children: [
                  //           const Padding(
                  //               padding: EdgeInsets.fromLTRB(15, 10, 0, 0)),
                  //           SizedBox(
                  //               height: 25,
                  //               width: 25,
                  //               child: Image.asset('assets/images/mode.png')),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           const Text(
                  //             "Door Settings",
                  //             // style: TextStyle(
                  //             //     fontSize: 20,
                  //             //     fontWeight: FontWeight.bold),
                  //           ),
                  //           // const SizedBox(
                  //           //   width: 170,
                  //           // ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
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
                            const Text(
                              "Logout",
                              // style: TextStyle(
                              //     fontSize: 20,
                              //     fontWeight: FontWeight.bold),
                            ),
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
      ),
    );
  }
}
