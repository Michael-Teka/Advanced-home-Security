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
      print('Data sent successfully');
    } else {
      print('Failed to send data: ${response.body}');
      throw Exception('Failed to schedule detection');
    }
  }
}
