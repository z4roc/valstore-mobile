import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher_icon");

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
    );
  }

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    // Handle notification response
  }

  static Future<void> requestPermission() async {
    if ((await flutterLocalNotificationsPlugin.pendingNotificationRequests())
        .isNotEmpty) {
      return;
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showInstantNotification(
    String title,
    String body,
    Uint8List? imageBytes,
  ) async {
    if (imageBytes == null) {
      return;
    }

    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      ByteArrayAndroidBitmap(imageBytes),
      contentTitle: title,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'instant_notification',
      'Instant Notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      styleInformation: bigPictureStyleInformation,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> showInstantNotificationWithoutPicture(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'instant_notification',
      'Instant Notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
