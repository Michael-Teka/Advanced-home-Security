import 'package:flutter/material.dart';
import 'package:homesecurity/reusables/reusable_widgets.dart';
import 'package:homesecurity/settings/display/theme_proveder.dart';
import 'package:homesecurity/settings/language/langu_provider.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBars(
                      isDarkMode: isDarkMode,
                      name:
                          isAmharic ? 'ውሎች እና መመሪያዎች' : 'Terms and Conditions'),
                  const SizedBox(height: 25),
                  Text(
                    isAmharic
                        ? 'አስፈላጊ የደህንነት ስርዓት ውሎች እና መመሪያዎች'
                        : 'Advanced Security System Terms and Conditions',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isAmharic
                        ? 'ቅንብር በተዘመነበት: [${DateTime.now().toLocal()}]'
                        : 'Effective Date: [${DateTime.now().toLocal()}]',
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(isAmharic ? '1፡ መግቢያ' : '1. Introduction'),
                  _SectionContent(isAmharic
                      ? 'እንኳን ወደ አስፈላጊ የደህንነት ስርዓት በሰላም መጡ። ይህ ስርዓት የደህንነት ካሜራና የደህንነት ደወል ይዟል።'
                      : 'Welcome to the Advanced Security System. This system includes a security camera and a security doorbell.'),
                  _SectionTitle(isAmharic
                      ? '2፡ የተጠቃሚ ምዝገባ እና መለያ አስተዳደር'
                      : '2. User Registration and Account Management'),
                  _SectionContent(isAmharic
                      ? 'ሁሉም ተጠቃሚዎች ይመዝገቡ እና የግል መለያ ይፍጠሩ።'
                      : 'All users must register and create a personal account.'),
                  _SectionTitle(isAmharic
                      ? '3፡ የደህንነት ካሜራ ባህሪዎች'
                      : '3. Security Camera Features'),
                  _SectionContent(isAmharic
                      ? 'ተጠቃሚዎች ካሜራዎችን በስም እና በURL ማክለት ይችላሉ።'
                      : 'Users can add cameras with names and URLs for live streaming.'),
                  _SectionTitle(isAmharic
                      ? '4፡ የደህንነት ደወል ባህሪዎች'
                      : '4. Security Doorbell Features'),
                  _SectionContent(isAmharic
                      ? 'እንግዶች ደወልን ሲጠቅሙ ተጠቃሚዎች ማሳወቂያ ያገኛሉ።'
                      : 'When a guest presses the doorbell, the user receives a notification.'),
                  _SectionTitle(isAmharic
                      ? '5፡ የመረጃ ጥበቃ እና ደህንነት'
                      : '5. Data Protection and Security'),
                  _SectionContent(isAmharic
                      ? 'ሁሉም የካሜራ ቪዲዮዎች እና ምስሎች በተጠቃሚው መሳሪያ ላይ ብቻ ይቆያሉ።'
                      : 'All camera videos and images are stored only on the users device.')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String content;
  const _SectionContent(this.content);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(fontSize: 14),
    );
  }
}
