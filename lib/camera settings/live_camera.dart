import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/recorde%20setting/recorde_and_photo.dart';
import 'package:homesecurity/camera%20settings/schedule/schedule_detection.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:provider/provider.dart';

class LiveCamera extends StatefulWidget {
  final String name;
  final String token;

  const LiveCamera({required this.name, required this.token, super.key});

  @override
  State<LiveCamera> createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  TimeOfDay? selectedTime;
  final List<String> _selectedObjects = []; // allow multiple selections

  bool isLoading = false;

  final List<String> cameraNames = ['person', 'dog', 'cat', 'car', 'remote'];

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (startTime ?? TimeOfDay.now())
          : (endTime ?? TimeOfDay.now()),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  Future<void> _submit() async {
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';
    if (startTime != null && endTime != null && _selectedObjects.isNotEmpty) {
      String startTimeString =
          '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00';
      String endTimeString =
          '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00';

      ScheduleDetection scheduleDetection = ScheduleDetection(
        widget.token,
        _selectedObjects,
        '${allbaseUrl}camera/object-detection/',
      );

      try {
        await scheduleDetection.scheduleDetection(
            startTimeString, endTimeString);
        // 🎉 Show success toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                isAmharic ? 'ቀጠሮ በትክክል ቀጥረዋል!' : 'Scheduled successfully!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        print('Failed to send data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAmharic ? 'ቀጠሮ አልተሳካም' : 'Failed to Schedule.'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAmharic
              ? 'መነሻና መጨረሻ ሰአት አልተመረተም'
              : 'Please select both start and end times.'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final isAmharic = Provider.of<LanguageNotifier>(context).language == 'am';

    String name = widget.name;

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? LinearGradient(
                colors: [Colors.black, Colors.grey.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xfff2d4b0),
                  Color(0xfffad7be),
                  Color(0xff9ecbd5),
                  Color(0xff9ecbd5)
                ],
              ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
          child: Column(
            children: [
              AppBars(
                isDarkMode: isDarkMode,
                name: name,
              ),
              // const SizedBox(height: 30),
             

              // const SizedBox(height: 20),
              StreamVideoRecorder(
                  streamUrl: '${allbaseUrl}camera/stream/',
                  token: widget.token),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 200,
                      width: 220,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[900]
                            : const Color.fromARGB(91, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 5)),
                          Row(
                            children: [
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text(isAmharic ? "ቀጠሮ" : "Schedule",
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              const SizedBox(
                                width: 110,
                              ),
                              SizedBox(
                                  height: 25,
                                  width: 25,
                                  child:
                                      Image.asset('assets/images/scedu.png')),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 0, 5)),
                              GestureDetector(
                                onTap: () => _selectTime(context, true),
                                child: Container(
                                  height: 130,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255, 210, 209, 209)
                                          : const Color.fromARGB(
                                              255, 176, 173, 173),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // const Text('From'),
                                      const SizedBox(height: 25),
                                      Center(
                                          child: Text(
                                        startTime != null
                                            ? startTime!.format(context)
                                            : 'Start Time',
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 99, 99, 99)),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              GestureDetector(
                                onTap: () => _selectTime(context, false),
                                child: Container(
                                  height: 130,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255, 210, 209, 209)
                                          : const Color.fromARGB(
                                              255, 176, 173, 173),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // const Text('To'),
                                      const SizedBox(height: 25),
                                      Center(
                                        child: Text(
                                            endTime != null
                                                ? endTime!.format(context)
                                                : 'End Time',
                                            style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : const Color.fromARGB(
                                                        255, 99, 99, 99))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      height: 200,
                      width: 155,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[900]
                            : const Color.fromARGB(91, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cameraNames.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            activeColor: const Color(0xff4b93ab),
                            title: Text(
                              cameraNames[index],
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: _selectedObjects
                                .contains(cameraNames[index]),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedObjects.add(cameraNames[index]);
                                } else {
                                  _selectedObjects
                                      .remove(cameraNames[index]);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  _submit();
                },
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xff9ecbd5), Color(0xff9ecbd5)]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255))),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(isAmharic ? "ቀጥር" : 'Submit',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              const SizedBox(
                height: 5,
              ),
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width - 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color.fromARGB(91, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
