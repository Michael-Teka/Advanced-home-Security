class DetectionSchedule {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final String objectToDetect;

  DetectionSchedule({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.objectToDetect,
  });

  factory DetectionSchedule.fromJson(Map<String, dynamic> json) {
    return DetectionSchedule(
      id: json['id'] ?? 0,
      name: _parseString(json['name']),
      startTime: _parseString(json['start_time']),
      endTime: _parseString(json['end_time']),
      objectToDetect: _parseString(json['object_to_detect']),
    );
  }
}

String _parseString(dynamic value) {
  if (value == null) return '';
  if (value is List) {
    return value.isNotEmpty ? value.join(", ") : '';
  }
  return value.toString();
}
