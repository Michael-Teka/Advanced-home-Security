import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100), // Set the size of the clock to 100x100
      painter: ClockPainter(time: _currentTime),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;
  ClockPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw the clock circle
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // Draw clock numbers (1-12)
    for (int i = 0; i < 12; i++) {
      double angle = (i * 30) *
          3.14159265358979 /
          180; // Each number is spaced 30 degrees apart

      // Adjust the angle for 12 at the top, 3 on the right, 6 at the bottom, and 9 on the left
      double angleAdjusted = angle - 3.14159265358979 / 2;

      double tickX = size.width / 2 +
          (size.width / 2 - 15) *
              cos(angleAdjusted); // Correct position for each number
      double tickY = size.height / 2 +
          (size.height / 2 - 15) *
              sin(angleAdjusted); // Correct position for each number

      // Draw the number at the correct position
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: (i + 1).toString(),
          style: TextStyle(fontSize: 10, color: Colors.black),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(tickX - textPainter.width / 2, tickY - textPainter.height / 2),
      );
    }

    // Draw hour hand
    paint.strokeWidth = 4;
    paint.color = Colors.black;
    double hourAngle =
        (time.hour % 12 + time.minute / 60) * 30 * 3.14159265358979 / 180;
    double hourX = size.width / 2 +
        (size.width / 4) * cos(hourAngle - 3.14159265358979 / 2);
    double hourY = size.height / 2 +
        (size.height / 4) * sin(hourAngle - 3.14159265358979 / 2);
    canvas.drawLine(
        Offset(size.width / 2, size.height / 2), Offset(hourX, hourY), paint);

    // Draw minute hand
    paint.strokeWidth = 3;
    double minuteAngle =
        (time.minute + time.second / 60) * 6 * 3.14159265358979 / 180;
    double minuteX = size.width / 2 +
        (size.width / 3) * cos(minuteAngle - 3.14159265358979 / 2);
    double minuteY = size.height / 2 +
        (size.height / 3) * sin(minuteAngle - 3.14159265358979 / 2);
    canvas.drawLine(Offset(size.width / 2, size.height / 2),
        Offset(minuteX, minuteY), paint);

    // Draw second hand
    paint.strokeWidth = 1;
    paint.color = Colors.red;
    double secondAngle = time.second * 6 * 3.14159265358979 / 180;
    double secondX = size.width / 2 +
        (size.width / 2 - 5) * cos(secondAngle - 3.14159265358979 / 2);
    double secondY = size.height / 2 +
        (size.height / 2 - 5) * sin(secondAngle - 3.14159265358979 / 2);
    canvas.drawLine(Offset(size.width / 2, size.height / 2),
        Offset(secondX, secondY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
