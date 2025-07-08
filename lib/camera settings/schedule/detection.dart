class Detection {
  final String objectName;
  final String cameraName;
  final DateTime timestamp;

  Detection({
    required this.objectName,
    required this.cameraName,
    required this.timestamp,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      objectName: json['object_detected'],
      cameraName: json['camera_name'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
