import 'package:example_todo_sqflite/models/task_model.dart';
import 'package:example_todo_sqflite/ui/notified_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    _configureLocalTimeZone();
    //tz.initializeTimeZones();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final AndroidInitializationSettings androidInitializationSettingsIOS =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: androidInitializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  displayNotification({required String title, required String body}) async {
    print("Diplay Notificatoin...");
    // ignore: prefer_const_constructors
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  // Future<void> scheduledNotification() async {

  //   print("Scheduled Notificatin is trigger");
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'scheduled title',
  //     'scheduled body',
  //     // _currentTime(hours, min),
  //     tz.TZDateTime.now(tz.local).add(Duration(seconds: 3)),
  //     const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //             'your channel id', 'your channel name',
  //             channelDescription: 'your channel description')),
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  //   print("Scheduled Notificatin is trigger ending ");
  // }

  Future<void> scheduledNotification(int hours, int min, UserTask task) async {
    print("Scheduled Notificatin is trigger");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _currentTime(hours, min),
        // tz.TZDateTime.now(tz.local).add(Duration(seconds: min)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|${task.note}");
    print("Scheduled Notificatin is trigger ending ");
  }

  tz.TZDateTime _currentTime(int hour, int min) {
    print("_cutternt time funciotn is ruunning ");
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min);

    if (scheduledDate.isBefore(now)) {
      print("schedule data condition ");
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print("_cutternt time funciotn is ending  ");

    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    print("My current time zone is $currentTimeZone");
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    if (payload == "Message") {
      print("Nothing to navigate ");
    } else {
      Get.to(() => NotifiedPage(lable: payload!));
    }
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    Get.dialog(Text("Welcome to the Flutter."));
  }
}
