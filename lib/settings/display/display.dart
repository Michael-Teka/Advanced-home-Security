import 'package:flutter/material.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:provider/provider.dart';

enum ThemeModeOption { light, dark }

class DisplayPage extends StatefulWidget {
  final String token;
  const DisplayPage({super.key, required this.token});

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  ThemeModeOption _selectedTheme = ThemeModeOption.light;

  bool get isDarkMode => _selectedTheme == ThemeModeOption.dark;

  @override
  void initState() {
    super.initState();
    _getUserTheme();
  }

  Future<void> _getUserTheme() async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    setState(() {
      _selectedTheme = themeNotifier.isDarkMode
          ? ThemeModeOption.dark
          : ThemeModeOption.light;
    });
  }

  Future<void> _setTheme(ThemeModeOption mode) async {
    setState(() {
      _selectedTheme = mode;
    });
    final isAmharic =
        Provider.of<LanguageNotifier>(context, listen: false).language == 'am';
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.setTheme(
      mode == ThemeModeOption.light ? ThemeMode.light : ThemeMode.dark,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAmharic ? 'ገጽታ በተሳካ ተቀይሯል!' : 'Theme changed successfully',
          style: const TextStyle(color:Colors.black),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  isDarkMode: isDarkMode, name: isAmharic ? 'ገጽታ' : 'Display'),
              const SizedBox(height: 25),
              Text(
                isAmharic ? 'መልክ' : "Appearance",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
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
                  children: ThemeModeOption.values.map((mode) {
                    return GestureDetector(
                      onTap: () => _setTheme(mode),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 160,
                            decoration: BoxDecoration(
                              color: mode == ThemeModeOption.light
                                  ? Colors.white
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.catching_pokemon_outlined,
                                    size: 28, color: Colors.grey),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 2,
                                  runSpacing: 2,
                                  children: [
                                    _colorBox(Colors.grey),
                                    _colorBox(Colors.yellow),
                                    _colorBox(Colors.orange),
                                    _colorBox(Colors.green),
                                    _colorBox(Colors.blue),
                                    _colorBox(Colors.purple),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            mode == ThemeModeOption.light
                                ? isAmharic
                                    ? 'ብርሀን'
                                    : "Light"
                                : isAmharic
                                    ? 'ጨለማ'
                                    : "Dark",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Icon(
                            _selectedTheme == mode
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: _selectedTheme == mode
                                ? Colors.red
                                : Colors.grey,
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

  Widget _colorBox(Color color) {
    return Container(width: 20, height: 20, color: color);
  }
}
