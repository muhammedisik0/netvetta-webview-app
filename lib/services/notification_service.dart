import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._private();

  static final NotificationService _instance = NotificationService._private();

  factory NotificationService() {
    return _instance;
  }

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    /*final iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );*/

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      //iOS: iOSSettings,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    log(notificationResponse.payload.toString());
  }

  /*void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    print(notificationResponse.actionId);
    print(notificationResponse.id);
    print(notificationResponse.input);
    print(notificationResponse.notificationResponseType);
    print(notificationResponse.payload);
  }*/

  NotificationDetails get notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        //largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        //icon: '@drawable/ic_launcher',
      ),
      //iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) {
    return notificationsPlugin.show(id, title, body, notificationDetails);
  }
}
