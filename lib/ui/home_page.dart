

import 'package:example_todo_sqflite/services/theme_services.dart';
import 'package:example_todo_sqflite/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotificationServices notifyHelper;
  @override
  void initState() {
    notifyHelper = NotificationServices();
    // notifyHelper.selectNotification('payload');
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(
                          DateTime.now(),
                        ),
                        style: subHeadingStyle,
                      ),
                      Text("Today"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().updateTheme();
          notifyHelper.displayNotification(
            title: "Message",
            body: Get.isDarkMode
                ? "Activated Light Theme."
                : "Activated Dark Theme",
          );

          notifyHelper.scheduledNotification();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ThemeServices().updateTheme();
          },
          icon: CircleAvatar(),
        ),
      ],
    );
  }
}
