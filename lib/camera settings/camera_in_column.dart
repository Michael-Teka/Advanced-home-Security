import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/add_camera_service.dart';
import 'package:homesecurity/camera%20settings/live_camera.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class CameraInColumn2 extends StatefulWidget {
  const CameraInColumn2({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<CameraInColumn2> createState() => _CameraInColumn2State();
}

class _CameraInColumn2State extends State<CameraInColumn2> {
  List<Map<String, dynamic>> cameras = [];

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
              .map<Map<String, dynamic>>((camera) => {
                    'id': camera['id'],
                    'name': camera['name'],
                    'icon': cameraIcons[camera['name']] ?? 'assets/images/bed.png',
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
    final isAmharic = Provider.of<LanguageNotifier>(context).language == 'am';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: cameras.map((camera) {
          return Padding(
            padding:
                const EdgeInsets.only(right: 0, top: 5), // Fixed 5px spacing
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
              height: 60,
              width: 350,
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
                      child: Image.asset(camera['icon']),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      camera['name'],
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(isAmharic
                                ? "ካሜራ ደልት"
                                : 'Delete Camera'),
                            content: Text(isAmharic
                                ? "እርግጠኛ ነዎት መደለት ይፈልጋሉ?"
                                : 'Are you sure you want to delete this camera?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                            final success =
                                await deleteCamera(camera['id'], widget.token);
                          if (success) {
                            setState(() {
                              cameras.removeWhere(
                                  (element) => element['id'] == camera['id']);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isAmharic
                                    ? "ካሜራ ተደልቷል"
                                    : 'Camera deleted'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isAmharic
                                    ? "ካሜራን መደለት አልተሳካም"
                                    : 'Failed to delete camera'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ));
        }).toList(),
      ),
    );
  }
}
