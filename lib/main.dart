import 'package:alarm_notification_app/firebase_options.dart';
import 'package:alarm_notification_app/services/alarm_service.dart';
import 'package:alarm_notification_app/services/notification_services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.data}");
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState()
  {
    super.initState();
    // setupFCM();
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      String? apnsToken = await messaging.getAPNSToken();
      print("APNS TOKEN: $apnsToken");
    }

    String? fcmToken = await messaging.getToken();
    print("FCM TOKEN: $fcmToken");

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("Foreground: ${message.data}");
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("Foreground: ${message.data}");
    //
    //   if (message.data['type'] == 'start_alarm') {
    //     print("display");
    //     NotificationService.showNotification(
    //       "Alarm Triggered",
    //       "Start Alarm Received",
    //     );
    //   }
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final type = message.data['type'];

      if (type == 'start_alarm') {
        NotificationService.showNotification(
          "Alarm Triggered",
          "Alarm is ringing",
        );
        // AlarmService.startAlarm();
      }

      if (type == 'stop_alarm') {
        // AlarmService.stopAlarm();
      }
    });
  }

  bool isOn = false;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/appstore.png"),
        // child: InkWell(
        //     onTap: () async {
        //       print("Started");
        //
        //       final player = AudioPlayer();
        //       await player.play(AssetSource("sounds/set.mp3"));
        //
        //       // AlarmService.startAlarm();
        //
        //       // isOn ? AlarmService.startAlarm() : Alra;
        //     },
        //     child: Text("Alarm Notification App", style: TextStyle(fontSize: 20))),
      ),
    );
  }
}
