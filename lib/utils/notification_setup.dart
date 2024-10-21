import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Future<void> initializeNotifications() async {
  await AwesomeNotifications().initialize(
    'resource://drawable/icon',
    [
      NotificationChannel(
        channelKey: 'channelKey',
        channelName: 'Task Notifications',
        channelDescription: 'Notification channel for task reminders',
        importance: NotificationImportance.High,
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
  );

  // Check if the app has permission to send notifications
  bool isAllowedNotification = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedNotification) {
    // Request permission if not allowed
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
