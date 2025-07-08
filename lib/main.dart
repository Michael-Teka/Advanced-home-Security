// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:homesecurity/loginAndRegistor/login_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  // OneSignal.initialize("YOUR_APP_ID");
  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  // OneSignal.Notifications.requestPermission(false);
  OneSignal.initialize("53b39a5b-d9e1-4171-9995-9c9123919e93");

  // Ask for notification permissions (iOS especially)
  OneSignal.Notifications.requestPermission(true);

   // Handle notifications when the app is in the foreground
  // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  //   event.preventDefault(); // Prevent the default notification display
  //   OneSignal.Notifications.displayNotification(event.notification as String); // Display the notification manually
  // });
// OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//   // Display the notification
//   event.preventDefault(); // Prevent the default notification display
//   OneSignal.Notifications.displayNotification(event.notification as String);
// });

OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  // Display the notification
  event.notification.display();
});

OneSignal.Notifications.addClickListener((event) {
  print('Notification clicked: ${event}');
});

  // Handle notification clicks
  // OneSignal.Notifications.addClickListener((event) {
  //   var data = event.notification.additionalData;
  //   if (data != null && data.containsKey('route')) {
  //     // Navigate to the specified route
  //     navigatorKey.currentState?.pushNamed(data['route']);
  //   }
  // });

  await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  tz.initializeTimeZones(); // Load all available timezones

  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
