import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/live_camera.dart';
// import 'package:homesecurity/camera%20settings/live_camera1.dart';

class Live extends StatefulWidget {
  final String token;
  final String name;
  final bool isdark;

  const Live(
      {required this.token,
      required this.isdark,
      required this.name,
      super.key});

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    String token = widget.token;
    bool isDarkMode = widget.isdark;

    return LiveCamera(
      isdark: isDarkMode,
      name: widget.name,
      token: token,
    );
  }
}
