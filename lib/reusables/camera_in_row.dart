// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/live_camera.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class CamerasInRow extends StatefulWidget {
  final String token;

  const CamerasInRow({
    super.key,
    required bool isDarkMode,
    required this.token,
  });

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
    const String url = '${allbaseUrl}camera/get-camera/';
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

          cameraPages.clear();
          for (var camera in cameras) {
            String cameraName = camera['name']!;
            cameraPages[cameraName] = LiveCamera(
              name: cameraName,
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
        final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

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
                color: isDarkMode
                    ? Colors.grey[900]
                    : const Color.fromARGB(91, 255, 255, 255),
              ),
              child: Center(
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset(
                          camera['icon']!),
                    ),
                    const SizedBox(width: 5),
                    Text(camera['name']!),
                    const SizedBox(width: 0.5),
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
