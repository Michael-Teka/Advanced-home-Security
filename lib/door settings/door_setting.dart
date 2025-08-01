import 'package:flutter/material.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:provider/provider.dart';

class DoorSetting extends StatefulWidget {
  final String token;

  const DoorSetting({required this.token, super.key});

  @override
  State<DoorSetting> createState() => _DoorSettingState();
}

class _DoorSettingState extends State<DoorSetting> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final isAmharic = Provider.of<LanguageNotifier>(context).language == 'am';
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
                  name: isAmharic ? 'የበር ካሜራ' : 'Door Camera'),
              const SizedBox(height: 30),
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color.fromARGB(91, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      onPressed: () {},
                      child: Text(isAmharic ? 'ፎቶ አንሳ' : 'Take Picture',
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {},
                      child: Text(isAmharic ? 'ክፈት' : 'Open',
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
