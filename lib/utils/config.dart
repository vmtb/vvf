import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(
    {required String title, required String body}) async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const notificationDetails =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, title, body, notificationDetails);
}

Future<void> initializeFirebaseMessaging() async {
  await FirebaseMessaging.instance.requestPermission(
      sound: true, badge: true, alert: true, announcement: true);
}

Future<void> configureFirebaseMessaging() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    // message.data
    if (notification != null) {
      showNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    }
  });
}
