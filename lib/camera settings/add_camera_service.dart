import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraService {
   String get baseUrl =>

      '${allbaseUrl}camera/add-camera/';

  final String token;

  CameraService(this.token);

  Future<void> addCamera(String name, String url) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode({
        'name': name,
        'url': url,
      }),
    );

    if (response.statusCode == 201) {
      print('Camera added successfully');
    } else {
      print('Failed to add camera: ${response.body}');
    }
  }
}

Future<bool> deleteSchedule(int id, String token) async {
  final url = Uri.parse('${allbaseUrl}camera/add-camera/');
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


  Future<bool> deleteCamera(int id, String token) async {
  final url = Uri.parse('${allbaseUrl}camera/add-camera/');
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