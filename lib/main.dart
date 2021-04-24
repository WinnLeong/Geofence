import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence_test/util/constants.dart';
import 'package:geofence_test/util/wifi_info.dart';
import 'package:geofence_test/view/home/home.dart';

import 'util/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Notifications notification = Notifications();

  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
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

    // Geofence.requestPermissions();
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
}
