import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detection.dart';

Future<List<Detection>> fetchDetectionHistory(String token) async {
  final url = Uri.parse('http://10.144.36.25:8000/api/accounts/detection-history/');
  // static const String _backendUrl = 'http://10.144.36.25:8000/api/accounts/save_player_id/';
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Detection.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load detection history');
  }
}
