import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

AndroidInitializationSettings initAndroid =
    const AndroidInitializationSettings("notify");

final initIOS = DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
  onDidReceiveLocalNotification: (id, title, body, payload) async {},
);

final initSettings = InitializationSettings(android: initAndroid, iOS: initIOS);

Future showNotification(
    {int id = 0, String? title, String? body, String? payLoad}) async {
  return notifications.show(id, title, body, await notificationDetails());
}

notificationDetails() {
  return const NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName",
          importance: Importance.high),
      iOS: DarwinNotificationDetails());
}

void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {}
