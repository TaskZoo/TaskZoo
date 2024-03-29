import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/notifications/active_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleNotifications(
  List<bool> daysToSchedule,
  int taskId,
  String timeOfDayString,
  String taskName,
  IsarService service,
) async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
  initializeNotifications();

  // Convert the Stringified TimeOfDay to TimeOfDay object
  TimeOfDay timeOfDay = TimeOfDay(
    hour: int.parse(timeOfDayString.substring(10, 12)),
    minute: int.parse(timeOfDayString.substring(13, 15)),
  );

  // Convert the TimeOfDay to DateTime
  DateTime notificationTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    timeOfDay.hour,
    timeOfDay.minute,
  );

  // print('notificationTime: $notificationTime');

  List<tz.TZDateTime> next7Days = List.generate(7, (int index) {
    final nextDay = tz.TZDateTime.now(tz.local).add(Duration(days: index));
    return tz.TZDateTime(tz.local, nextDay.year, nextDay.month, nextDay.day,
        timeOfDay.hour, timeOfDay.minute);
  });

  tz.TZDateTime tzNotificationTime =
      tz.TZDateTime.from(notificationTime, tz.local);

  // print('tzNotificationTime: $tzNotificationTime');
  // print('tz.local: ${tz.local}');

  // Create a set to store the scheduled notification details
  Set<String> scheduledNotifications =
      await service.getNotificationIdsForTaskID(taskId);

  // Loop through the boolean list and schedule notifications for selected days
  for (int i = 0; i < daysToSchedule.length; i++) {
    if (daysToSchedule[i]) {
      final scheduledDateTime =
          next7Days[(i - tz.TZDateTime.now(tz.local).weekday + 8) % 7];
      print("Scheduled $taskName notification for: $scheduledDateTime");

      // Generate a unique key for the scheduled notification based on taskId and scheduled date
      final notificationKey = '$taskId-$scheduledDateTime';

      bool isScheduled =
          await isNotificationScheduled(notificationKey.hashCode.abs());
      // Check if there is already a scheduled notification with the same key
      if (!scheduledNotifications.contains(notificationKey) && !isScheduled) {
        // If a notification with the same key doesn't exist, schedule the notification
        await _scheduleNotificationForDay(
            scheduledDateTime, notificationKey.hashCode.abs(), taskName);
        // Add the notification key to the set to mark it as scheduled
        scheduledNotifications.add(notificationKey);
        final activeNotifications = ActiveNotifications(
            taskid: taskId, notificationIds: scheduledNotifications.toList());
        service.saveActiveNotificationForTask(activeNotifications);
        // print("After Scheduling Notification");
        // printAllScheduledNotifications();
      }
    }
  }
}

Future<bool> isNotificationScheduled(int notificationId) async {
  final List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  return pendingNotificationRequests
      .any((notification) => notification.id == notificationId);
}

Future<void> deleteAllNotifications(int taskId, IsarService service) async {
  // print("Before Deleting All Notifications");
  // printAllScheduledNotifications();
  Set<String> scheduledNotifications =
      await service.getNotificationIdsForTaskID(taskId);
  for (String notificationKey in scheduledNotifications) {
    await flutterLocalNotificationsPlugin
        .cancel(notificationKey.hashCode.abs());
  }
  service.deleteActiveNotificationsForTaskEntry(taskId);
  // print("After Deleting All Notifications");
  // printAllScheduledNotifications();
}

Future<void> _scheduleNotificationForDay(
  DateTime scheduledDateTime,
  int taskId,
  String taskName,
) async {
  const channelId = 'channel_id';
  const channelName = 'Channel Name';
  const channelDescription = 'Custom Notification Channel';

  // Android notification details
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    playSound: true,
    enableVibration: true,
    enableLights: true,
    color: Colors.blue,
    ledColor: Colors.white,
    ledOnMs: 1000,
    ledOffMs: 500,
  );

  print("Scheduler called for $scheduledDateTime");

  // iOS and macOS notification details (using DarwinNotificationDetails)
  const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

  // Combined notification details
  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  // Calculate the difference between the scheduled date and the current date
  final difference = scheduledDateTime.difference(DateTime.now());

  // Schedule the notification
  if (!scheduledDateTime.isBefore(DateTime.now())) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      taskId, // Use the taskId as the unique ID for the notification
      'TaskZoo Reminder',
      'Time to complete task: $taskName',
      tz.TZDateTime.now(tz.local).add(difference),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: null,
    );
  }
  // Print statement to show when the notification has been scheduled
  // print('Notification scheduled for taskId: $taskId, at: $scheduledDateTime');
}

Future<void> printAllScheduledNotifications() async {
  final List<PendingNotificationRequest> notifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  if (notifications.isEmpty) {
    print('No scheduled notifications.');
  } else {
    print('Scheduled Notifications:');
    for (final notification in notifications) {
      print('ID: ${notification.id}');
      print('Title: ${notification.title}');
      print('Body: ${notification.body}');
      print('Scheduled Date: ${notification.payload}');
      print('---');
    }
  }
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
