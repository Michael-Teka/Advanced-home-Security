
import 'dart:convert';
import 'package:homesecurity/camera%20settings/schedule/structure.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:http/http.dart' as http;


Future<List<DetectionSchedule>> fetchSchedules(String token) async {
  final response = await http.get(
    Uri.parse('${allbaseUrl}camera/object-detection/'),
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => DetectionSchedule.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load schedules');
  }
}




Future<bool> deleteSchedule(int id, String token) async {
  final url = Uri.parse('${allbaseUrl}camera/object-detection/');
  final response = await http.delete(
    url,
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
    body: '{"id": $id}',
  );

  return response.statusCode == 204;
}
