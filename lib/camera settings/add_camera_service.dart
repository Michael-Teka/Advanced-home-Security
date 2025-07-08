import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraService {
  final String baseUrl =
      'http://10.144.36.25:8000/camera/add-camera/';
        // 'https://advanced-home-security-backend-production.up.railway.app/camera/add-camera/';

      // 'http://127.0.0.1:8000/camera/add-camera/';

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

