// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:http/http.dart' as http;

// class NotificationService {
//   static Future<void> initOneSignal(String token) async {
//     OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//     OneSignal.initialize("53b39a5b-d9e1-4171-9995-9c9123919e93");

//     OneSignal.Notifications.requestPermission(true);

//     // Get the device state and send the player ID to backend
//     var deviceState = await OneSignal.User.pushSubscription;
//     String? playerId = deviceState.id;

//     if (playerId != null) {
//       print("✅ Player ID: $playerId");
//       await sendPlayerIdToBackend(token, playerId);
//     } else {
//       print("❌ Failed to get Player ID");
//     }
//   }

//   static Future<void> sendPlayerIdToBackend(String token, String playerId) async {
//     final response = await http.post(
//       Uri.parse('http://10.144.36.21:8000/api/accounts/save_fcm_token/'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'user_token': token,
//         'onesignal_player_id': playerId,
//       }),
//     );

//     if (response.statusCode == 200) {
//       print("🎯 Player ID sent to backend");
//     } else {
//       print("❌ Failed to send Player ID: ${response.body}");
//     }
//   }
  
// }

// lib/services/push_notification_service.dart
import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static const String _appId = '53b39a5b-d9e1-4171-9995-9c9123919e93';
  // static const String _restApiKey = 'os_v2_app_kozzuw6z4faxdgmvtsishem6spvfdxzyqeieog4n6l6p5fz3izu6tgcg3isdd3c6n4xnewcwwt3ftq3rl3m4lrgdlc33ezepdojb4xa';
  static const String _backendUrl = 'http://10.144.36.25:8000/api/accounts/save_player_id/';

  static String? playerId;

  /// Initialize OneSignal and send player ID to backend
  static Future<void> initOneSignal(String token) async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(_appId);
    OneSignal.Notifications.requestPermission(true);

   // Wait for the subscription to be established
  await Future.delayed(Duration(seconds: 2));

  String? playerId = OneSignal.User.pushSubscription.id;
  // await OneSignal.shared.setAppId("YOUR_ONESIGNAL_APP_ID");

    // var deviceState = OneSignal.User.pushSubscription;
    // playerId = deviceState.id;
      // Retrieve the player ID
  // String? playerId = OneSignal.User.pushSubscription.id;

    if (playerId != null) {
      print("✅ Player ID: $playerId");
      await _sendPlayerIdToBackend(token, playerId);
    } else {
      print("❌ Failed to get Player ID");
    }
  }

  static Future<void> _sendPlayerIdToBackend(String token, String playerId) async {
    final response = await http.post(
      Uri.parse(_backendUrl),
      headers: {
      "Content-Type": "application/json",
      // 'Authorization': 'Token $token',
      },
      body: jsonEncode({
        'user_token': token,
        'player_id': playerId,
      }),
    );

    if (response.statusCode == 200) {
      print("🎯 Player ID sent to backend");
    } else {
      print("❌ Failed to send Player ID: ${response.body}");
    }
  }

//   /// Send push notification
//   static Future<void> sendPushNotification(String playerId, String title, String message) async {
//     const pushNotificationUrl = 'https://onesignal.com/api/v1/notifications';
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $_restApiKey',
//     };
//     final payload = {
//       'app_id': _appId,
//       'include_player_ids': [playerId],
//       'headings': {'en': title},
//       'contents': {'en': message},
//     };

//     final response = await http.post(
//       Uri.parse(pushNotificationUrl),
//       headers: headers,
//       body: json.encode(payload),
//     );

//     if (response.statusCode == 200) {
//       print('📤 Push notification sent successfully.');
//     } else {
//       print('❌ Failed to send push notification: ${response.statusCode}, ${response.body}');
//     }
//   }
}
