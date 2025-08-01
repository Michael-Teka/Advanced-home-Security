import 'package:flutter/material.dart';
import 'package:homesecurity/camera%20settings/schedule/fetch_datas_service.dart';
import 'package:homesecurity/camera%20settings/schedule/structure.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:provider/provider.dart';

class DetectionSchedulePage extends StatefulWidget {
  final String token;
  const DetectionSchedulePage({super.key, required this.token});

  @override
  _DetectionSchedulePageState createState() => _DetectionSchedulePageState();
}

class _DetectionSchedulePageState extends State<DetectionSchedulePage> {
  late Future<List<DetectionSchedule>> futureSchedules;

  @override
  void initState() {
    super.initState();
    futureSchedules = fetchSchedules(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final isAmharic = Provider.of<LanguageNotifier>(context).language == 'am';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[900]
            : const Color.fromARGB(91, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FutureBuilder<List<DetectionSchedule>>(
        future: futureSchedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final schedules = snapshot.data!;
          if (schedules.isEmpty) {
            return  Center(child: Text(isAmharic?"የተቀጠረ ቀጠሮ የለም":'No detection schedules found.'));
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor:
                            isDarkMode ? Colors.blueGrey : Colors.blueAccent,
                        child: const Icon(Icons.videocam, color: Colors.white),
                      ),
                      title: Text(
                        schedule.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                  '${schedule.startTime} - ${schedule.endTime}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.remove_red_eye, size: 16),
                              const SizedBox(width: 6),
                              Text(schedule.objectToDetect),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title:  Text(isAmharic?"ቀጠሮ ደልት":'Delete Schedule'),
                              content:  Text(
                                 isAmharic?"እርግጠኛ ነዎት መደለት ይፈልጋሉ?": 'Are you sure you want to delete this schedule?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final success =
                                await deleteSchedule(schedule.id, widget.token);
                            if (success) {
                              setState(() {
                                futureSchedules = fetchSchedules(widget.token);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                    content: Text(isAmharic?"ቀጠሮ ተደልቷል":'Schedule deleted',
                                      style: const TextStyle(color: Colors.black),
                                    ),
                              backgroundColor:
                                  Colors.green,
                              behavior: SnackBarBehavior.floating,),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                    content: Text(isAmharic?"ቀጠሮን መደለት አልተሳካም":'Failed to delete schedule')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
