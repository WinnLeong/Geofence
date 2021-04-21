import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence/util/constants.dart';
import 'package:geofence/view/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    // Initialize flutter local notifications
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Initialize flutter_geofence
    Geofence.initialize();

    Geofence.requestPermissions();

    Geofence.startListening(GeolocationEvent.entry, (entry) {
      scheduleNotification("Entry of a georegion", "Welcome to: ${entry.id}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geofence',
      theme: ThemeData(
        primaryColor: ColorConstant.primaryColor,
      ),
      home: Home(),
    );
  }

  void scheduleNotification(String title, String subtitle) {
    print("scheduling one with $title and $subtitle");
    var rng = new Random();
    Future.delayed(Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), title, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }
}
