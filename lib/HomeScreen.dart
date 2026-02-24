import 'package:alarm_notification_app/services/alarm_service.dart';
import 'package:alarm_notification_app/services/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    setupFCM();
    super.initState();
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      String? apnsToken = await messaging.getAPNSToken();
      print("APNS TOKEN: $apnsToken");
    }

    String? fcmToken = await messaging.getToken();
    print("FCM TOKEN: $fcmToken");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final type = message.data['type'];

      print("message : $type");

      if (type == 'start_alarm') {
        NotificationService.showNotification(
          "Alarm Triggered",
          "Alarm is ringing",
        );
        AlarmService.startAlarm();
      }

      if (type == 'stop_alarm') {
        AlarmService.stopAlarm();
      }
    });
  }

  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              print("Started");

              AlarmService.startAlarm();
            },
            child: Text(
              "Alarm Notification App",
              style: TextStyle(fontSize: 20),
            ),
          ),
          InkWell(
            onTap: () async {
              print("stop");

              AlarmService.stopAlarm();
            },
            child: Text(
              " StopAlarm Notification App",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
