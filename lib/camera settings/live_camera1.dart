// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:homesecurity/camera%20settings/schedule/schedule_detection.dart';
// import 'package:homesecurity/reusables/reusable_widgets.dart';

// class LiveCamera extends StatefulWidget {
//   final bool isdark;
//   final String name;
//   final String token;

//   const LiveCamera({
//     required this.name,
//     required this.isdark,
//     required this.token,
//     super.key,
//   });

//   @override
//   State<LiveCamera> createState() => _LiveCameraState();
// }

// class _LiveCameraState extends State<LiveCamera> {
//   TimeOfDay? selectedTime;
//   final List<String> cameraNames = ['Person', 'Dog', 'Cat', 'Car', 'Fire'];
//   String _selectedObject = 'Person'; // Default selected name
//   late RTCVideoRenderer _videoRenderer; // Video renderer for WebRTC stream

//   TimeOfDay? startTime;
//   TimeOfDay? endTime;

//   @override
//   void initState() {
//     super.initState();
//     _videoRenderer = RTCVideoRenderer();
//     _videoRenderer.initialize().then((_) {
//       setState(() {});
//     });

//     // Connect to WebRTC stream after initialization
//     _connectToStream();
//   }

//   Future<void> _connectToStream() async {
//     // Here we assume you're connecting to a signaling server and fetching stream
//     var pc = await createPeerConnection({
//       'iceServers': [
//         {
//           'urls': 'stun:stun.l.google.com:19302', // Use STUN server for NAT traversal
//         },
//       ]
//     });

//     // Set up WebRTC media stream
//     MediaStream mediaStream = await navigator.mediaDevices.getUserMedia({
//       'video': true, // If you want both video and audio, add 'audio': true
//     });

//     // Attach local video stream to renderer for self-view (if needed)
//     _videoRenderer.srcObject = mediaStream;

//     // Add the media stream to your peer connection (for remote streams)
//     pc.addStream(mediaStream);
//   }

//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: isStartTime ? (startTime ?? TimeOfDay.now()) : (endTime ?? TimeOfDay.now()),
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
//   void dispose() {
//     _videoRenderer.dispose(); // Dispose video renderer when leaving the page
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = widget.isdark;
//     String name = widget.name;

//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           gradient: widget.isdark
//               ? LinearGradient(
//                   colors: [Colors.black, Colors.grey.shade900],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 )
//               : const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xfff2d4b0),
//                     Color(0xfffad7be),
//                     Color(0xff9ecbd5),
//                     Color(0xff9ecbd5)
//                   ],
//                 ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
//             child: Column(
//               children: [
//                 AppBars(
//                   isDarkMode: isDarkMode,
//                   name: name,
//                 ),
//                 const SizedBox(height: 30),
//                 Container(
//                   height: 350,
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? Colors.grey[900]
//                         : const Color.fromARGB(91, 255, 255, 255),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: _videoRenderer.srcObject != null
//                       ? RTCVideoView(_videoRenderer)  // Display WebRTC stream
//                       : const Center(child: CircularProgressIndicator()),  // Loading
//                 ),
//                 const SizedBox(height: 20),
//                 // Your scheduling and other widgets go here...
                
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
//                                                 : Color.fromARGB(
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
//                                                     : Color.fromARGB(
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
//                                   BorderRadius.all(Radius.circular(10)),
//                               value: _selectedObject,
//                               decoration: InputDecoration(
//                                   labelText: 'Select The Object',
//                                   labelStyle: TextStyle(
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : Color.fromARGB(255, 99, 99, 99))),
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
//                                       : Color.fromARGB(255, 99, 99, 99))),
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
        

//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
