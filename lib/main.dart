import 'package:alarm_notification_app/firebase_options.dart';
import 'package:alarm_notification_app/services/notification_services.dart';
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
  void initState() {
    super.initState();
    setupFCM();
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground: ${message.data}");

      if (message.data['type'] == 'start_alarm') {
        print("display");
        NotificationService.showNotification(
          "Alarm Triggered",
          "Start Alarm Received",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Alarm Notification App", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
