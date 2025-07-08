import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/schedule/detection.dart';
import 'package:homesecurity/camera%20settings/schedule/detection_service.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart'; // ✅ Import AppBars
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class DetectionHistoryScreen extends StatefulWidget {
  final String token;
  final bool isdark; // From login
  // final bool isDark;  // 🔥 Add dark mode
  final String name;  // 🔥 Add name for AppBar

  const DetectionHistoryScreen({super.key,
    required this.token,
    // required this.isDark,
    required this.name,
    // required bool isdark,
    required this.isdark,
  });

  @override
  _DetectionHistoryScreenState createState() => _DetectionHistoryScreenState();
}

class _DetectionHistoryScreenState extends State<DetectionHistoryScreen> {
  late Future<List<Detection>> _detections;

  @override
  void initState() {
    super.initState();
    _detections = fetchDetectionHistory(widget.token);
  }

  String _formatEthiopianTime(DateTime utcTime) {
    final ethiopia = tz.getLocation('Africa/Addis_Ababa');
    final localTime = tz.TZDateTime.from(utcTime, ethiopia);
    final formatter = DateFormat('yyyy-MM-dd – HH:mm:ss');
    return formatter.format(localTime);
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
                    Color(0xff9ecbd5),
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
                  name: name,
                ),
                const SizedBox(height: 30),
                FutureBuilder<List<Detection>>(
                  future: _detections,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("❌ Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No detection history found."));
                    }

                    final detectionHistory = snapshot.data!;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(), // Prevent nested scroll
                      shrinkWrap: true,
                      itemCount: detectionHistory.length,
                      itemBuilder: (context, index) {
                        final detection = detectionHistory[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[900]
                                : const Color.fromARGB(91, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.security, color: isDarkMode ? Colors.white : Colors.black),
                            title: Text(
                              '${detection.objectName} detected',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Camera: ${detection.cameraName} • ${_formatEthiopianTime(detection.timestamp)}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
