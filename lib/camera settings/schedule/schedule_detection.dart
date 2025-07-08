// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ScheduleDetection {
//   final String baseUrl =
//                         // 'http://127.0.0.1:8000/camera/object-detection/';
//                           'http://10.144.36.21:8000/camera/object-detection/';
//                         // 'https://advanced-home-security-backend-production.up.railway.app/camera/object-detection/';

//   final String token;

//   ScheduleDetection(this.token);

//   Future<void> scheduleDetection(
//       String startTime, String endTime, String object) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token $token',
//       },
//       body: json.encode({
//         'start_time': startTime,
//         'end_time': endTime,
//         'object_to_detect': object,
//       }),
//     );

//     if (response.statusCode == 201) {
//       print('data send successfully');
//     } else {
//       print('Failed to Send data: ${response.body}');
//     }
//   }
// }


// import 'package:http/http.dart' as http;
// import 'dart:convert';
// class ScheduleDetection {
//   final String token;
//   final String objectToDetect;
//   String baseUrl = 'http://10.144.36.21:8000/camera/object-detection/';

//   // Constructor that expects 3 positional arguments
//   ScheduleDetection(this.token, this.objectToDetect, this.baseUrl);

//   Future<void> scheduleDetection(String startTime, String endTime) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token $token',
//       },
//       body: json.encode({
//         'start_time': startTime,
//         'end_time': endTime,
//         'object_to_detect': objectToDetect,
//       }),
//     );

//     if (response.statusCode == 201) {
//       print('data send successfully');
//     } else {
//       print('Failed to Seend data: ${response.body}');
//     }
//   }
// }

//   // Function to send push notification
//   Future<void> sendPushNotification(String userToken, String title, String message) async {
//     const pushNotificationUrl = 'https://onesignal.com/api/v1/notifications';  // OneSignal notification URL
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'os_v2_app_kozzuw6z4faxdgmvtsishem6spvfdxzyqeieog4n6l6p5fz3izu6tgcg3isdd3c6n4xnewcwwt3ftq3rl3m4lrgdlc33ezepdojb4xa',  // Replace with your OneSignal REST API Key
//     };
//     final payload = {
//       'app_id': '53b39a5b-d9e1-4171-9995-9c9123919e93',  // Replace with your OneSignal App ID
//       'include_player_ids': [userToken],
//       'headings': {'en': title},
//       'contents': {'en': message},
//     };

//     final response = await http.post(
//       Uri.parse(pushNotificationUrl),
//       headers: headers,
//       body: json.encode(payload),
//     );

//     if (response.statusCode == 200) {
//       print('Push notification sent successfully.');
//     } else {
//       print('Failed to send push notification: ${response.statusCode}, ${response.body}');
//     }
//   }

import 'package:flutter/material.dart';
// import 'package:your_app/services/push_notification_service.dart'; // 👈 import the service
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleDetection {
  final String token;
  final List<String> objectToDetect;
  final String baseUrl;

  ScheduleDetection(this.token, this.objectToDetect, this.baseUrl);

  Future<void> scheduleDetection(String startTime, String endTime) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode({
        'start_time': startTime,
        'end_time': endTime,
        'object_to_detect': objectToDetect,
      }),
    );

    if (response.statusCode == 201) {
      print('📦 Data sent successfully');
    } else {
      print('❌ Failed to send data: ${response.body}');
      throw Exception('Failed to schedule detection');
    }
  }
}
