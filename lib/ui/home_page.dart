import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:example_todo_sqflite/services/theme_services.dart';
import 'package:example_todo_sqflite/themes.dart';
import 'package:example_todo_sqflite/ui/add_task_page.dart';
import 'package:example_todo_sqflite/ui/constants.dart';
import 'package:example_todo_sqflite/ui/widgets/button_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedDate = DateTime.now();
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
            _appTaskBar(),
            // Date Picker TimeLines
            _appDateBar(),
          ],
        ),
      ),
    );
  }

  Container _appDateBar() {
    return Container(
      margin: EdgeInsets.only(left: 20.w, top: 20.h),
      child: DatePicker(
        DateTime.now(),
        height: 100.h,
        width: 80.w,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: bluishClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) => selectedDate = date,
      ),
    );
  }

  Container _appTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // appTaskBar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Text(
                DateFormat.yMMMMd().format(
                  DateTime.now(),
                ),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),

// add-task-button
          MyButton(
            lable: "+ Add Task",
            ontap: () {
              Get.to(AddTaskBar());
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
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
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: CircleAvatar(),
        ),
      ],
    );
  }
}
