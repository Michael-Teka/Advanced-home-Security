// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:homesecurity/camera%20settings/live_camera.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CamerasInRow extends StatefulWidget {
//   const CamerasInRow({
//     super.key,
//     required this.isDarkMode,
//     required this.token,
//   });

//   final bool isDarkMode;
//   final String token;

//   @override
//   State<CamerasInRow> createState() => _CamerasInRowState();
// }

// class _CamerasInRowState extends State<CamerasInRow> {
//   List<Map<String, String>> cameras = [];

//   final Map<String, String> cameraIcons = {
//     "Living Room": "assets/images/living.png",
//     "Kitchen": "assets/images/kitchen.png",
//     "Bed Room": "assets/images/bed.png",
//     "Garden": "assets/images/garden.png",
//     "Park": "assets/images/park.png",
//   };

//   // Define the pages for each camera, passing isDarkMode from the parent widget
//   final Map<String, Widget> cameraPages = {};

//   @override

//   // Initialize the cameraPages map dynamically

//   Future<void> fetchCameras() async {
//     const String url = 'http://127.0.0.1:8000/camera/get-camera/';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Token ${widget.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);

//         setState(() {
//           cameras = data
//               .map<Map<String, String>>((camera) => {
//                     'name': camera['name'],
//                     'icon':
//                         cameraIcons[camera['name']] ?? 'assets/images/bed.png',
//                   })
//               .toList();
//           // Dynamically generate camera pages for any camera name
//           cameraPages.clear(); // Clear previous pages (if any)
//           for (var camera in cameras) {
//             String cameraName = camera['name']!;
//             cameraPages[cameraName] = LiveCamera(
//               name: cameraName,
//               isdark: widget.isDarkMode,
//               token: widget.token,
//             );
//           }
//         });
//       } else {
//         print('Failed to load cameras: ${response.body}');
//       }
//     } catch (e) {
//       print('Error fetching cameras: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchCameras();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: cameras.map((camera) {
//         return Padding(
//           padding: const EdgeInsets.only(right: 8),
//           child: GestureDetector(
//             onTap: () {
//               String cameraName = camera['name']!;
//               if (cameraPages.containsKey(cameraName)) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => cameraPages[cameraName]!,
//                   ),
//                 );
//               }
//             },
//             child: Container(
//               height: 50,
//               width: 150,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: widget.isDarkMode
//                     ? Colors.grey[900]
//                     : const Color.fromARGB(91, 255, 255, 255),
//               ),
//               child: Center(
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 10)),
//                     Container(
//                       height: 25,
//                       width: 25,
//                       child: Image.asset(
//                           camera['icon']!), // Display the correct icon
//                     ),
//                     const SizedBox(width: 5),
//                     Text(camera['name']!), // Display the camera name
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/live.dart';
// import 'package:homesecurity/camera%20settings/live_camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CamerasInRow extends StatefulWidget {
  const CamerasInRow({
    super.key,
    required bool isDarkMode,
    required this.token,
  }) : _isDarkMode = isDarkMode;

  final bool _isDarkMode;
  final String token;

  @override
  State<CamerasInRow> createState() => _CamerasInRowState();
}

class _CamerasInRowState extends State<CamerasInRow> {
  List<Map<String, String>> cameras = [];

  final Map<String, String> cameraIcons = {
    "Living Room": "assets/images/living.png",
    "Kitchen": "assets/images/kitchen.png",
    "Bed Room": "assets/images/bed.png",
    "Garden": "assets/images/garden.png",
    "Park": "assets/images/park.png",
  };

  final Map<String, Widget> cameraPages = {};

  Future<void> fetchCameras() async {
    // const String url = 'http://127.0.0.1:8000/camera/get-camera/';
    const String url = 'http://10.144.36.25:8000/camera/get-camera/';
        // const String url = 'https://advanced-home-security-backend-production.up.railway.app/camera/get-camera/';


    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          cameras = data
              .map<Map<String, String>>((camera) => {
                    'name': camera['name'],
                    'icon':
                        cameraIcons[camera['name']] ?? 'assets/images/bed.png',
                  })
              .toList();

          // Dynamically generate camera pages for any camera name
          cameraPages.clear();
          for (var camera in cameras) {
            String cameraName = camera['name']!;
            cameraPages[cameraName] = Live(
              name: cameraName,
              isdark: widget._isDarkMode,
              token: widget.token,
            );
          }
        });
      } else {
        print('Failed to load cameras: ${response.body}');
      }
    } catch (e) {
      print('Error fetching cameras: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: cameras.map((camera) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              String cameraName = camera['name']!;
              if (cameraPages.containsKey(cameraName)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => cameraPages[cameraName]!,
                  ),
                );
              }
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget._isDarkMode
                    ? Colors.grey[900]
                    : const Color.fromARGB(91, 255, 255, 255),
              ),
              child: Center(
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Container(
                      height: 25,
                      width: 25,
                      child: Image.asset(
                          camera['icon']!), // Display the correct icon
                    ),
                    const SizedBox(width: 5),
                    Text(camera['name']!), // Display the camera name
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
