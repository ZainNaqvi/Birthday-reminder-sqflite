import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:example_todo_sqflite/controllers/add_task_controller.dart';
import 'package:example_todo_sqflite/models/task_model.dart';
import 'package:example_todo_sqflite/services/theme_services.dart';
import 'package:example_todo_sqflite/themes.dart';
import 'package:example_todo_sqflite/ui/add_task_page.dart';
import 'package:example_todo_sqflite/ui/constants.dart';
import 'package:example_todo_sqflite/ui/widgets/button_dart.dart';
import 'package:example_todo_sqflite/ui/widgets/task_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  TaskController _taskController = Get.put(TaskController());
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
            // appbartask bar
            _appTaskBar(),
            // Date Picker TimeLines
            _appDateBar(),
            SizedBox(height: 16.h),
            // list of the object user tasks
            _showUserTasks(),
          ],
        ),
      ),
    );
  }

  _showUserTasks() {
    return Expanded(child: Obx(
      () {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            print(
                "list view builder has ${_taskController.taskList.length} items.");
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(
                              context, _taskController.taskList[index]);
                        },
                        child: TaskTile(_taskController.taskList[index]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ));
  }

  _showBottomSheet(BuildContext context, UserTask task) {
    Get.bottomSheet(BottomSheet(
      onClosing: () {},
      builder: (context) {
        return customSheetStyle(
          task: task,
          color: Colors.blue,
          context: context,
          isCompleted: false,
          lable: "Task Completed",
          ontap: () {},
        );
      },
    ));
  }

  Container customSheetStyle({
    required UserTask task,
    required String lable,
    required Color color,
    required Function()? ontap,
    required bool isCompleted,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      height: isCompleted
          ? MediaQuery.of(context).size.height * 0.32
          : MediaQuery.of(context).size.height * 0.24,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? darkgreyClr : Colors.white,
      ),
      child: Column(
        children: [
          // top heading line
          Container(
            margin: EdgeInsets.only(top: 1.0.r),
            width: 120.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          // custom Button
          SizedBox(height: isCompleted ? 48.h : 34.h),
          _customButton(
            clr: bluishClr,
            ontap: () {
              Get.back();
            },
            isCompleted: isCompleted,
            lable: 'Task Completed',
            isClose: false,
          ),
          SizedBox(height: 8.h),
          _customButton(
            clr: pickClr,
            ontap: () {
              _taskController.delete(task: task);
              _taskController.getTask();
              Get.back();
            },
            isCompleted: isCompleted,
            lable: 'Delete Task',
            isClose: false,
          ),
          SizedBox(height: 8.h),
          isCompleted
              ? _customButton(
                  clr: Colors.transparent,
                  ontap: () {
                    Get.back();
                  },
                  isCompleted: isCompleted,
                  lable: 'Close',
                  isClose: true,
                )
              : Container(height: 0.0),
        ],
      ),
    );
  }

  _customButton({
    required Color clr,
    required VoidCallback ontap,
    required bool isCompleted,
    required String lable,
    required bool isClose,
  }) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        width: double.maxFinite,
        height: 40.h,
        decoration: BoxDecoration(
          color: clr,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
        ),
        child: Center(
            child: isClose
                ? Text(
                    lable,
                    style: textHeadingStyle,
                  )
                : Text(
                    lable,
                    style: textHeadingStyle.copyWith(color: Colors.white),
                  )),
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
            ontap: () async {
              await Get.to(AddTaskBar());
              _taskController.getTask();
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
