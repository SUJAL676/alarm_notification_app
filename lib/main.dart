import 'package:alarm_notification_app/HomeScreen.dart';
import 'package:alarm_notification_app/firebase_options.dart';
import 'package:alarm_notification_app/services/alarm_service.dart';
import 'package:alarm_notification_app/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final type = message.data['type'];

  print("📩 Background message: $type");

  if (type == 'start_alarm') {
    await NotificationService.initialize();
    await AlarmService.startAlarm();
    await NotificationService.showNotification(
      "Alarm Triggered",
      "Alarm is ringing",
    );
  }

  if (type == 'stop_alarm') {
    await AlarmService.stopAlarm();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
