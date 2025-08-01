import 'package:flutter/material.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:provider/provider.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';

enum LanguageOption { english, amharic }

class Language extends StatelessWidget {
  final String token;
  const Language({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    final isAmharic = languageNotifier.language == 'am';
    final selectedLanguage =
        isAmharic ? LanguageOption.amharic : LanguageOption.english;
        
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                    Color(0xff9ecbd5),
                  ],
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBars(
                isDarkMode: isDarkMode,
                name: isAmharic ? 'ቋንቋ' : "Language",
              ),
              const SizedBox(height: 25),
              // Text(
              //   isAmharic ? 'ቋንቋ' : "Language",
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: isDarkMode ? Colors.white : Colors.black,
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color.fromARGB(91, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: LanguageOption.values.map((option) {
                    final isSelected = selectedLanguage == option;
                    return GestureDetector(
                      onTap: () {
                        final newLang =
                            option == LanguageOption.amharic ? 'am' : 'en';
                        languageNotifier.setLanguage(newLang);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAmharic
                                  ? 'Language changed successfully'
                                  : 'ቋንቋ በተሳካ ተቀይሯል!',
                              style: const TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Text(
                                option == LanguageOption.english
                                    ? isAmharic
                                        ? 'ኢንግሊዥ'
                                        : 'English'
                                    : isAmharic
                                        ? 'አማርኛ'
                                        : 'Amharic',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      5), // Optional spacing between text and image
                              if (option == LanguageOption.english)
                                Image.asset(
                                  "assets/images/america.png",
                                  height: 16,
                                  width: 16,
                                )
                                else if (option == LanguageOption.amharic)
                                Image.asset(
                                  "assets/images/ethiopia.png",
                                  height: 16,
                                  width: 16,
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
