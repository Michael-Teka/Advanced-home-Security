import 'package:flutter/material.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';

class DoorSetting extends StatefulWidget {
  final bool isdark;
  final String name;
  final String token;

  const DoorSetting(
      {required this.name,
      required this.isdark,
      required this.token,
      super.key});

  @override
  State<DoorSetting> createState() => _DoorSettingState();
}

class _DoorSettingState extends State<DoorSetting> {
  // final _formKey = GlobalKey<FormState>();
  // String _cameraUrl = '';

  // TimeOfDay? selectedTimeFr;
  // TimeOfDay? selectedTimeTo;

  // Future<TimeOfDay?> pickTimeFr(
  //     BuildContext context, TimeOfDay? initialTime) async {
  //   return await showTimePicker(
  //     context: context,
  //     initialTime: initialTime ?? TimeOfDay.now(),
  //   );
  // }

  // Future<TimeOfDay?> pickTimeTo(
  //     BuildContext context, TimeOfDay? initialTime) async {
  //   return await showTimePicker(
  //     context: context,
  //     initialTime: initialTime ?? TimeOfDay.now(),
  //   );
  // }

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
                  // boxShadow: [
                  //   // BoxShadow(
                  //   //   color: isDarkMode
                  //   //       ? Colors.black12 // Dark mode shadow
                  //   //       : Colors.black26, // Light mode shadow
                  //   //   offset: const Offset(8, 5), // X and Y offset for shadow
                  //   //   blurRadius: 6, // Blurriness of shadow
                  //   //   spreadRadius: 2, // Spread radius
                  //   // ),
                  // ],
                ),
                // child: const Mjpeg(
                //   stream: 'http://127.0.0.1:8000/camera/stream/',

                //   // 'http://192.168.8.156:8000/camera/stream/',
                //   isLive: true,
                //   timeout: Duration(seconds: 100),
                // ),
              ),
              const SizedBox(height: 20),
              // Container(
              //   child: const Text(
              //     'Set Detection Schedule',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {},
                  child: const Text('Open',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}


// import 'package:flutter/material.dart';
// import 'package:homesecurity/camera%20settings/schedule/detection.dart';
// import 'package:homesecurity/camera%20settings/schedule/detection_service.dart';
// // import 'detection.dart';
// // import 'detection_service.dart';
// import 'package:intl/intl.dart';
// import 'package:timezone/timezone.dart' as tz;
// class DetectionHistoryScreen extends StatefulWidget {
//   final String token; // You can pass this from login

//   DetectionHistoryScreen({required this.token});

//   @override
//   _DetectionHistoryScreenState createState() => _DetectionHistoryScreenState();
// }

// class _DetectionHistoryScreenState extends State<DetectionHistoryScreen> {
//   late Future<List<Detection>> _detections;

//   @override
//   void initState() {
//     super.initState();
//     _detections = fetchDetectionHistory(widget.token);
//   }
//   String _formatEthiopianTime(DateTime utcTime) {
//   final ethiopia = tz.getLocation('Africa/Addis_Ababa');
//   final localTime = tz.TZDateTime.from(utcTime, ethiopia);
//   final formatter = DateFormat('yyyy-MM-dd – HH:mm:ss');
//   return formatter.format(localTime);
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Detection History")),
//       body: FutureBuilder<List<Detection>>(
//         future: _detections,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("❌ Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No detection history found."));
//           }

//           final detectionHistory = snapshot.data!;
//           return ListView.builder(
//             itemCount: detectionHistory.length,
//             itemBuilder: (context, index) {
//               final detection = detectionHistory[index];
//               return Card(
//                 child: ListTile(
//                   leading: Icon(Icons.security),
//                   title: Text('${detection.objectName} detected'),
//                   // subtitle: Text(
//                   //   'Camera: ${detection.cameraName} • ${detection.timestamp}',
//                   // ),
//                   subtitle: Text(
//                     'Camera: ${detection.cameraName} • ${_formatEthiopianTime(detection.timestamp)}',
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

