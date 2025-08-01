// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class StreamVideoRecorder extends StatefulWidget {
  final String streamUrl;
  final String token;

  const StreamVideoRecorder({
    super.key,
    required this.streamUrl,
    required this.token,
  });

  @override
  // ignore: library_private_types_in_public_api
  _StreamVideoRecorderState createState() => _StreamVideoRecorderState();
}

class _StreamVideoRecorderState extends State<StreamVideoRecorder> {
  File? _videoFile;
  bool _isRecording = false;
  int _bytesReceived = 0;
  late StreamSubscription<List<int>> _streamSubscription;
  late IOSink _fileSink;
  Timer? _timer;
  int _secondsElapsed = 0;

  // Key for capturing screenshot of the stream widget
  final GlobalKey _repaintKey = GlobalKey();

  Future<String> _getVideoStoragePath() async {
    final directory = await getExternalStorageDirectory();
    final videoDir = Directory('${directory!.path}/RecordedVideos');
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }
    return '${videoDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
  }

  Future<void> _startRecording() async {
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';
    if (!await Permission.storage.request().isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isAmharic ? " የስቶሬጅ ፈቃድ ያስፈልጋል" : 'Storage permission required'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final filePath = await _getVideoStoragePath();
    _videoFile = File(filePath);
    _fileSink = _videoFile!.openWrite();

    try {
      final headers = {
        'Authorization': 'Token ${widget.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final request = http.Request('GET', Uri.parse(widget.streamUrl));
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 401) {
        throw Exception('Unauthorized Access (401): Check your token.');
      } else if (response.statusCode != 200) {
        throw Exception('Failed to connect: ${response.statusCode}');
      }

      setState(() {
        _isRecording = true;
        _secondsElapsed = 0; // reset timer count
        _bytesReceived = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _secondsElapsed++;
        });
      });

      _streamSubscription = response.stream.listen((data) {
        _bytesReceived += data.length;
        _fileSink.add(data);
      }, onError: (e) {
        print('Stream error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stream error: $e')),
        );
        _stopRecording();
      }, onDone: () async {
        await _fileSink.flush();
        await _fileSink.close();
        print('Recording saved to: ${_videoFile!.path}');
      }, cancelOnError: true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAmharic ? "መቅዳት ጀምሯል..." : 'Recording started...'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('Recording error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording error: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';
    if (_isRecording) {
      setState(() {
        _isRecording = false;
      });

      _timer?.cancel();
      _timer = null;

      // Instead of canceling the subscription, pause it:
      _streamSubscription.pause();

      await _fileSink.flush();
      await _fileSink.close();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAmharic
              ? "ቀረጻ በተሳካ ሁኔታ: ${_videoFile!.path} ተቀምጧል"
              : 'Recording saved successfully: ${_videoFile!.path}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _takeScreenshot() async {
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';
    if (!await Permission.storage.request().isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isAmharic ? "የስቶሬጅ ፈቃድ ያስፈልጋል" : 'Storage permission required'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final boundary = _repaintKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();
        final directory = await getExternalStorageDirectory();
        final imageDir = Directory('${directory!.path}/RecordedImages');

        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        final filePath =
            '${imageDir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

        final imageFile = File(filePath);
        await imageFile.writeAsBytes(buffer);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAmharic
                ? "ፎቶ በተሳካ ሁኔታ $filePath ተቀምጧል"
                : 'Screenshot saved successfully: $filePath'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Screenshot error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isAmharic ? "ፎቶ ማንሳት አልተሳካም" : 'Failed to capture screenshot'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_isRecording) {
      _stopRecording();
    }
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final orientation = MediaQuery.of(context).orientation;
    final isAmharic = Provider.of<LanguageNotifier>(context).language == 'am';

    return Column(
      children: [
        RepaintBoundary(
          key: _repaintKey,
          child: Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey[900]
                  : const Color.fromARGB(91, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
            ),
            child: RotatedBox(
              quarterTurns: orientation == Orientation.landscape ? 1 : 0,
              child: Mjpeg(
                stream: widget.streamUrl,
                isLive: true,
                timeout: const Duration(seconds: 100),
                headers: {
                  "Authorization": "Token ${widget.token}",
                },
                error: (context, error, stack) {
                  return Center(child: Text('Stream error: $error'));
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording
                      ? isDarkMode
                          ? const ui.Color.fromARGB(91, 216, 111, 111)
                          : Colors.red
                      : isDarkMode
                          ? const Color.fromARGB(91, 255, 255, 255)
                          : Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(
                      color: isDarkMode ? Colors.white : Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  _isRecording
                      ? isAmharic
                          ? "መቅዳት አቁም"
                          : 'STOP RECORDING'
                      : isAmharic
                          ? "መቅዳት ጀምር"
                          : 'START RECORDING',
                  style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _takeScreenshot,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color.fromARGB(91, 255, 255, 255)
                      : Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(
                      color: isDarkMode ? Colors.white : Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  isAmharic ? "ፎቶ አንሳ" : 'TAKE SCREENSHOT',
                  style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
        if (_isRecording) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              isAmharic
                  ? "መጠን: ${(_bytesReceived / 1024).toStringAsFixed(2)} KB"
                  : 'File size: ${(_bytesReceived / 1024).toStringAsFixed(2)} KB',
              style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              isAmharic
                  ? "የቀረጻ ጊዜ: $_formattedTime"
                  : 'Recording Time: $_formattedTime',
              style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ],
    );
  }
}
