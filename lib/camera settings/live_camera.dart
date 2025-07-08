// import 'package:flutter/material.dart';
// import 'package:flutter_mjpeg/flutter_mjpeg.dart';
// import 'package:homesecurity/camera%20settings/schedule/schedule_detection.dart';
// import 'package:homesecurity/reusables/reusable_widgets.dart';

// class LiveCamera extends StatefulWidget {
//   final bool isdark;
//   final String name;
//   final String token;

//   const LiveCamera(
//       {required this.name,
//       required this.isdark,
//       required this.token,
//       super.key});

//   @override
//   State<LiveCamera> createState() => _LiveCameraState();
// }

// class _LiveCameraState extends State<LiveCamera> {
//   TimeOfDay? selectedTime;

//   // final _formKey = GlobalKey<FormState>();
//   String _selectedObject = 'Person'; // Default selected name
//   // String _cameraUrl = '';

//   final List<String> cameraNames = ['Person', 'Dog', 'Cat', 'Car', 'Fire'];

//   // TimeOfDay? selectedTimeFr;
//   // TimeOfDay? selectedTimeTo;

//   // Future<TimeOfDay?> pickTimeFr(
//   //     BuildContext context, TimeOfDay? initialTime) async {
//   //   return await showTimePicker(
//   //     context: context,
//   //     initialTime: initialTime ?? TimeOfDay.now(),
//   //   );
//   // }

//   // Future<TimeOfDay?> pickTimeTo(
//   //     BuildContext context, TimeOfDay? initialTime) async {
//   //   return await showTimePicker(
//   //     context: context,
//   //     initialTime: initialTime ?? TimeOfDay.now(),
//   //   );
//   // }

//   TimeOfDay? startTime;
//   TimeOfDay? endTime;
//   @override
//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: isStartTime
//           ? (startTime ?? TimeOfDay.now())
//           : (endTime ?? TimeOfDay.now()),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         if (isStartTime) {
//           startTime = pickedTime;
//         } else {
//           endTime = pickedTime;
//         }
//       });
//     }
//   }

//   Future<void> _submit() async {
//     if (startTime != null && endTime != null) {
//       // Convert TimeOfDay to string format (HH:mm)
//       String startTimeString =
//           '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
//       String endTimeString =
//           '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
//       String objectToDetect = _selectedObject;
//       ScheduleDetection scheduleDetection = ScheduleDetection(widget.token);
//       try {
//         await scheduleDetection.scheduleDetection(
//             startTimeString, endTimeString, objectToDetect);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Data sent successfully!'),
//             duration: Duration(seconds: 2),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } catch (e) {
//         print('Failed to send data: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to send data.'),
//             duration: Duration(seconds: 2), // Optional duration
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select both start and end times.'),
//           duration: Duration(seconds: 2), // Optional duration
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = widget.isdark;
//     String name = widget.name;

//     return Scaffold(
//         body: Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         gradient: widget.isdark
//             ? LinearGradient(
//                 colors: [Colors.black, Colors.grey.shade900],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               )
//             : const LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xfff2d4b0),
//                   Color(0xfffad7be),
//                   Color(0xff9ecbd5),
//                   Color(0xff9ecbd5)
//                 ],
//               ),
//       ),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
//           child: Column(
//             children: [
//               AppBars(
//                 isDarkMode: isDarkMode,
//                 name: name,
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 height: 350,
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? Colors.grey[900]
//                       : const Color.fromARGB(91, 255, 255, 255),
//                   borderRadius: BorderRadius.circular(12),
//                   // boxShadow: [
//                   //   // BoxShadow(
//                   //   //   color: isDarkMode
//                   //   //       ? Colors.black12 // Dark mode shadow
//                   //   //       : Colors.black26, // Light mode shadow
//                   //   //   offset: const Offset(8, 5), // X and Y offset for shadow
//                   //   //   blurRadius: 6, // Blurriness of shadow
//                   //   //   spreadRadius: 2, // Spread radius
//                   //   // ),
//                   // ],
//                 ),
//                 child:
//                 // const Mjpeg(
//                 //   stream:
//                 //       'http://127.0.0.1:8000/camera/stream/',
//                 //           // 'http://192.168.8.120:8000/camera/stream/',
//                 //       // 'http://192.168.8.156:8000/camera/stream/',
//                 //   isLive: true,
//                 //   timeout: Duration(seconds: 100), // Increase timeout duration
//                 // ),
//                    const Mjpeg(
//                   stream:
//                   // 'http://127.0.0.1:8000/camera/stream/',
//                           'http://10.144.36.21:8000/camera/stream/',
//                           // 'https://advanced-home-security-backend-production.up.railway.app/camera/stream/',
//                   isLive: true,
//                   timeout: Duration(seconds: 200),
//                     // headers: {
//                     //    "Authorization": "Token ${widget.token}",  // ✅ Include token
//                     //       },
//                     )

//               ),
//               const SizedBox(height: 20),
//               // Container(
//               //   child: const Text(
//               //     'Set Detection Schedule',
//               //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               //   ),
//               // ),
//               const SizedBox(height: 10),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 200,
//                       width: 220,
//                       decoration: BoxDecoration(
//                         color: isDarkMode
//                             ? Colors.grey[900]
//                             : const Color.fromARGB(91, 255, 255, 255),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Column(
//                         children: [
//                           const Padding(
//                               padding: EdgeInsets.fromLTRB(10, 10, 0, 5)),
//                           Row(
//                             children: [
//                               const Padding(padding: EdgeInsets.only(left: 10)),
//                               Text("Schedule",
//                                   style: TextStyle(
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : Colors.black)),
//                               const SizedBox(
//                                 width: 110,
//                               ),
//                               SizedBox(
//                                   height: 25,
//                                   width: 25,
//                                   child:
//                                       Image.asset('assets/images/scedu.png')),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               const Padding(
//                                   padding: EdgeInsets.fromLTRB(15, 10, 0, 5)),
//                               GestureDetector(
//                                 onTap: () => _selectTime(context, true),
//                                 child: Container(
//                                   height: 130,
//                                   width: 80,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                       color: isDarkMode
//                                           ? const Color.fromARGB(
//                                               255, 210, 209, 209)
//                                           : const Color.fromARGB(
//                                               255, 176, 173, 173),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       // const Text('From'),
//                                       const SizedBox(height: 25),
//                                       Center(
//                                           child: Text(
//                                         startTime != null
//                                             ? startTime!.format(context)
//                                             : 'Start Time',
//                                         style: TextStyle(
//                                             color: isDarkMode
//                                                 ? Colors.white
//                                                 : const Color.fromARGB(
//                                                     255, 99, 99, 99)),
//                                       ))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 30,
//                               ),
//                               GestureDetector(
//                                 onTap: () => _selectTime(context, false),
//                                 child: Container(
//                                   height: 130,
//                                   width: 80,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                       color: isDarkMode
//                                           ? const Color.fromARGB(
//                                               255, 210, 209, 209)
//                                           : const Color.fromARGB(
//                                               255, 176, 173, 173),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       // const Text('To'),
//                                       const SizedBox(height: 25),
//                                       Center(
//                                         child: Text(
//                                             endTime != null
//                                                 ? endTime!.format(context)
//                                                 : 'End Time',
//                                             style: TextStyle(
//                                                 color: isDarkMode
//                                                     ? Colors.white
//                                                     : const Color.fromARGB(
//                                                         255, 99, 99, 99))),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           height: 96,
//                           width: 155,
//                           decoration: BoxDecoration(
//                             color: isDarkMode
//                                 ? Colors.grey[900]
//                                 : const Color.fromARGB(91, 255, 255, 255),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: SingleChildScrollView(
//                             child: DropdownButtonFormField<String>(
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(10)),
//                               value: _selectedObject,
//                               decoration: InputDecoration(
//                                   labelText: 'Select The Object',
//                                   labelStyle: TextStyle(
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : const Color.fromARGB(255, 99, 99, 99))),
//                               dropdownColor: const Color(0xff9ecbd5),
//                               items: cameraNames.map((name) {
//                                 return DropdownMenuItem(
//                                   value: name,
//                                   child: Text(
//                                     name,
//                                     style: TextStyle(
//                                         color: isDarkMode
//                                             ? Colors.white
//                                             : Colors.black),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedObject = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
//                           height: 96,
//                           width: 150,
//                           decoration: BoxDecoration(
//                             color: isDarkMode
//                                 ? Colors.grey[900]
//                                 : const Color.fromARGB(91, 255, 255, 255),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text('Add Sound',
//                               style: TextStyle(
//                                   color: isDarkMode
//                                       ? Colors.white
//                                       : const Color.fromARGB(255, 99, 99, 99))),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                 ),
//                 onPressed: _submit,
//                 child: Ink(
//                   decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                           colors: [Color(0xff9ecbd5), Color(0xff9ecbd5)]),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                           color: const Color.fromARGB(255, 255, 255, 255))),
//                   child: Container(
//                     height: 50,
//                     alignment: Alignment.center,
//                     child: const Text('Submit',
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 5,
//               ),
//               Container(
//                 height: 130,
//                 width: MediaQuery.of(context).size.width - 25,
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? Colors.grey[900]
//                       : const Color.fromARGB(91, 255, 255, 255),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:homesecurity/camera%20settings/schedule/schedule_detection.dart';
// import 'package:homesecurity/camera%20settings/schedule/noticationService.dart';
// import 'package:homesecurity/camera%20settings/schedule/schedule_detection.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';

class LiveCamera extends StatefulWidget {
  final bool isdark;
  final String name;
  final String token;

  const LiveCamera(
      {required this.name,
      required this.isdark,
      required this.token,
      super.key});

  @override
  State<LiveCamera> createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  // String _selectedObject = 'person'; // Default selected name
  List<String> _selectedObjects = []; // allow multiple selections

  final List<String> cameraNames = ['person', 'dog', 'cat', 'car', 'fire'];

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (startTime ?? TimeOfDay.now())
          : (endTime ?? TimeOfDay.now()),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

// Future<void> _submit() async {
//   if (startTime != null && endTime != null) {
//     // Convert TimeOfDay to string format (HH:mm)
//     String startTimeString =
//         '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
//     String endTimeString =
//         '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
//     String objectToDetect = _selectedObject;

//     // Pass 3 positional arguments to ScheduleDetection constructor
//     ScheduleDetection scheduleDetection = ScheduleDetection(widget.token, objectToDetect, 'http://10.144.36.21:8000/camera/object-detection/');

//     try {
//       await scheduleDetection.scheduleDetection(startTimeString, endTimeString);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Data sent successfully!'),
//           duration: Duration(seconds: 2),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } catch (e) {
//       print('Failed to send data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to send data.'),
//           duration: Duration(seconds: 2),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Please select both start and end times.'),
//         duration: Duration(seconds: 2),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
// }

  Future<void> _submit() async {
    if (startTime != null && endTime != null && _selectedObjects.isNotEmpty) {
      String startTimeString =
          '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00';
      String endTimeString =
          '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00';
      // String objectToDetect = _selectedObject;

      ScheduleDetection scheduleDetection = ScheduleDetection(
        widget.token,
        _selectedObjects,
        'http://10.144.36.25:8000/camera/object-detection/',
      );

      try {
        await scheduleDetection.scheduleDetection(
            startTimeString, endTimeString);
        // 🎉 Show success toast
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data sent successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // // 🔔 Send push notification
        // if (PushNotificationService.playerId != null) {
        //   await PushNotificationService.sendPushNotification(
        //     PushNotificationService.playerId!,
        //     'Detection Scheduled',
        //     'Detection for $objectToDetect from $startTimeString to $endTimeString has been scheduled.',
        //   );
        // }
      } catch (e) {
        print('❌ Failed to send data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send data.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end times.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.isdark;
    String name = widget.name;

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: widget.isdark
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
            children: [
              AppBars(
                isDarkMode: isDarkMode,
                name: name,
              ),
              const SizedBox(height: 30),
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color.fromARGB(91, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Mjpeg(
                    stream: 'http://10.144.36.25:8000/camera/stream/',
                    isLive: true,
                    timeout: const Duration(seconds: 200),
                    headers: {
                      "Authorization":
                          "Token ${widget.token}", // ✅ Include token
                    },
                    // ),
                    error: (context, error, stack) {
                      return Center(child: Text('Stream error: $error'));
                    }),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 200,
                      width: 220,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[900]
                            : const Color.fromARGB(91, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 5)),
                          Row(
                            children: [
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text("Schedule",
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                          ),
                                          ),
                              const SizedBox(
                                width: 110,
                              ),
                              SizedBox(
                                  height: 25,
                                  width: 25,
                                  child:
                                      Image.asset('assets/images/scedu.png')),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 0, 5)),
                              GestureDetector(
                                onTap: () => _selectTime(context, true),
                                child: Container(
                                  height: 130,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255, 210, 209, 209)
                                          : const Color.fromARGB(
                                              255, 176, 173, 173),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 25),
                                      Center(
                                          child: Text(
                                        startTime != null
                                            ? startTime!.format(context)
                                            : 'Start Time',
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 99, 99, 99)),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              GestureDetector(
                                onTap: () => _selectTime(context, false),
                                child: Container(
                                  height: 130,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255, 210, 209, 209)
                                          : const Color.fromARGB(
                                              255, 176, 173, 173),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 25),
                                      Center(
                                        child: Text(
                                            endTime != null
                                                ? endTime!.format(context)
                                                : 'End Time',
                                            style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : const Color.fromARGB(
                                                        255, 99, 99, 99))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.all(20),
                        //   height: 180,
                        //   width: 155,
                        //   decoration: BoxDecoration(
                        //     color: isDarkMode
                        //         ? Colors.grey[900]
                        //         : const Color.fromARGB(91, 255, 255, 255),
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: SingleChildScrollView(
                        //     child: DropdownButtonFormField<String>(
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(10)),
                        //       value: _selectedObject,
                        //       decoration: InputDecoration(
                        //           labelText: 'Select The Object',
                        //           labelStyle: TextStyle(
                        //               color: isDarkMode
                        //                   ? Colors.white
                        //                   : const Color.fromARGB(
                        //                       255, 99, 99, 99))),
                        //       dropdownColor: const Color(0xff9ecbd5),
                        //       items: cameraNames.map((name) {
                        //         return DropdownMenuItem(
                        //           value: name,
                        //           child: Text(
                        //             name,
                        //             style: TextStyle(
                        //                 color: isDarkMode
                        //                     ? Colors.white
                        //                     : Colors.black),
                        //           ),
                        //         );
                        //       }).toList(),
                        //       onChanged: (value) {
                        //         setState(() {
                        //           _selectedObject = value!;
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          height: 200,
                          width: 155,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[900]
                                : const Color.fromARGB(91, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cameraNames.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: const Color(0xff4b93ab),
                                title: Text(
                                  cameraNames[index],
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      ),
                                ),
                                value: _selectedObjects
                                    .contains(cameraNames[index]),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedObjects.add(cameraNames[index]);
                                    } else {
                                      _selectedObjects
                                          .remove(cameraNames[index]);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: _submit,
                child: Container(
                  width: 180,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xff8fbdb0)
                        : const Color(0xff4b93ab),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Schedule",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
