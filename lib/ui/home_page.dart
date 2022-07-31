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
  var _selectedDate = DateTime.now();
  late NotificationServices notifyHelper;
  @override
  void initState() {
    notifyHelper = NotificationServices();
    // notifyHelper.selectNotification('payload');
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTask();
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
            SizedBox(height: 22.h),
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
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            print(
                "list view builder has ${_taskController.taskList.length} items.");
            UserTask task = _taskController.taskList[index];
            print(task.toJson());
            if (task.repeat == 'Daily') {
              DateTime date = DateFormat.jm().parse(task.startTime.toString());

              var myTime = DateFormat('HH:mm').format(date);
              print(myTime);
              notifyHelper.scheduledNotification(
                int.parse(myTime.split(":")[0]),
                int.parse(myTime.split(":")[1]),
                task,
              );

              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      },
    ));
  }

  _showBottomSheet(
    BuildContext context,
    UserTask task,
  ) {
    Get.bottomSheet(BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          height: task.isCompleted == 0 ? 210.h : 170.h,
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
              SizedBox(height: task.isCompleted == 0 ? 54.h : 42.h),
              task.isCompleted == 1
                  ? Container()
                  : _customButton(
                      clr: bluishClr,
                      ontap: () {
                        _taskController.updateTask(task.id!);
                        Get.back();
                      },
                      lable: 'Task Completed',
                    ),
              SizedBox(height: 8.h),
              _customButton(
                clr: pickClr,
                ontap: () {
                  _taskController.delete(task: task);
                  _taskController.getTask();
                  Get.back();
                },
                lable: 'Delete Task',
              ),
              SizedBox(height: 8.h),

              _customButton(
                clr: Colors.transparent,
                ontap: () {
                  Get.back();
                },
                lable: 'Close',
                isClose: true,
              ),
            ],
          ),
        );
      },
    ));
  }

  _customButton({
    required Color clr,
    required VoidCallback ontap,
    required String lable,
    bool isClose = false,
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
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
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
        onPressed: () async {
          ThemeServices().updateTheme();
          notifyHelper.displayNotification(
            title: "Message",
            body: Get.isDarkMode
                ? "Activated Light Theme."
                : "Activated Dark Theme",
          );

          // await notifyHelper.scheduledNotification();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.snackbar("Message", "HI! 😎");
          },
          icon: CircleAvatar(
            backgroundImage: AssetImage("images/profile.jpg"),
          ),
        ),
      ],
    );
  }
}
