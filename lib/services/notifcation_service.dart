import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

AndroidInitializationSettings initAndroid =
    const AndroidInitializationSettings("launcher_notifcation");

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
    android: AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
    ),
    iOS: DarwinNotificationDetails(),
  );
}

void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Importance notifications",
  importance: Importance.max,
);

Future<void> showNotificationWithImage(
    {required String title,
    required String description,
    required String imageUrl}) async {
  final imageBytes = (await get(Uri.parse(imageUrl))).bodyBytes;

  BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(
    ByteArrayAndroidBitmap(imageBytes),
    contentTitle: title,
  );

  await notifications.show(
    Random().nextInt(2000),
    title,
    description,
    NotificationDetails(
      android: AndroidNotificationDetails(
        "high_importance_channel",
        "High Importance notifications",
        importance: Importance.max,
        styleInformation: bigPictureStyleInformation,
      ),
    ),
  );
}
