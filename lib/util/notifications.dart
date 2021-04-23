import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleNotification(
      {required String title, required String subtitle}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notification', 'notification',
            'You are now within setel payment zone.',
            // sound: RawResourceAndroidNotificationSound('pristine'),
            playSound: true,
            icon: 'app_icon',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(threadIdentifier: 'thread_id');

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0, title, subtitle,
        DateTime.now().add(Duration(seconds: 2)), platformChannelSpecifics,
        payload: 'item x');
  }
}
