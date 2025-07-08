import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/camera_in_column.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';

class CameraLists extends StatefulWidget {
  final String token;
  final bool isDarkMode;

  const CameraLists({required this.token, required this.isDarkMode, super.key});

  @override
  State<CameraLists> createState() => _CameraListsState();
}

class _CameraListsState extends State<CameraLists> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    String token = widget.token;
    bool isDarkMode = widget.isDarkMode;

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
              children: [
                AppBars(isDarkMode: isDarkMode, name: 'All Cameras'),
                SizedBox(
                  height: 20,
                ),
                CameraInColumn2(
                  isDarkMode: isDarkMode,
                  token: token,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
