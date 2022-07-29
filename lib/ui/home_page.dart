import 'package:example_todo_sqflite/services/theme_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Text("Hello"),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().updateTheme();
          notifyHelper.displayNotification(
            title: "title",
            body: Get.isDarkMode
                ? "Activated Dark Theme"
                : "Activated Light Theme.",
          );
        },
        icon: Icon(Icons.nightlight_round),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ThemeServices().updateTheme();
          },
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}
