import 'dart:convert';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static const String _appId = '7ff49dce-a3d3-484f-aa16-32e61f693c23';
  static const String _backendUrl = '${allbaseUrl}api/accounts/save_player_id/';

  static String? playerId;

  /// Initialize OneSignal and send player ID to backend
  static Future<void> initOneSignal(String token) async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(_appId);
    OneSignal.Notifications.requestPermission(true);

    // Wait for the subscription to be established
    await Future.delayed(const Duration(seconds: 2));

    String? playerId = OneSignal.User.pushSubscription.id;

    if (playerId != null) {
      print("✅ Player ID: $playerId");
      await _sendPlayerIdToBackend(token, playerId);
    } else {
      print("❌ Failed to get Player ID");
    }
  }

  static Future<void> _sendPlayerIdToBackend(
      String token, String playerId) async {
    final response = await http.post(
      Uri.parse(_backendUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token $token',
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
}
