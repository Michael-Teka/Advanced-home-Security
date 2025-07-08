import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> fetchUserProfile(String token) async {
  const url =
      'http://10.144.36.25:8000/api/accounts/profile/';
      // 'http://192.168.8.198:8000/api/accounts/profile/';
        // 'https://advanced-home-security-backend-production.up.railway.app/api/accounts/profile/';


  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Token $token', // Include the token in the request header
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print('Failed to load profile. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching profile: $e');
    return null;
  }
}
