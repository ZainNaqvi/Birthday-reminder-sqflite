import 'package:example_todo_sqflite/controllers/add_task_controller.dart';
import 'package:example_todo_sqflite/models/task_model.dart';
import 'package:example_todo_sqflite/themes.dart';
import 'package:example_todo_sqflite/ui/constants.dart';
import 'package:example_todo_sqflite/ui/widgets/button_dart.dart';
import 'package:example_todo_sqflite/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskBar extends StatefulWidget {
  const AddTaskBar({Key? key}) : super(key: key);

  @override
  State<AddTaskBar> createState() => _AddTaskBarState();
}

class _AddTaskBarState extends State<AddTaskBar> {
  TaskController _taskController = Get.put(TaskController());
  TextEditingController _userTitle = TextEditingController();
  TextEditingController _userNote = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = "9:29 AM";
  int _selectRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 10.h),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyTextField(
                lable: "Title",
                hintText: "Enter the title",
                controller: _userTitle,
              ),
              MyTextField(
                lable: "Note",
                hintText: "Enter the note",
                controller: _userNote,
              ),
              MyTextField(
                lable: "Note",
                hintText: DateFormat.yMd().format(_selectedDate!),
                widget: IconButton(
                  onPressed: () async {
                    _getUserDate(context);
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                  ),
                ),
              ),
              // start time and the end time
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      hintText: _startTime,
                      lable: "Start Time",
                      widget: IconButton(
                        icon: Icon(Icons.access_time_rounded),
                        onPressed: () {
                          _getUserTIme(isStarttime: true);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: MyTextField(
                      hintText: _endTime,
                      lable: "End Time",
                      widget: IconButton(
                        icon: Icon(Icons.access_time_rounded),
                        onPressed: () {
                          _getUserTIme(isStarttime: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // remind the user
              MyTextField(
                hintText: "$_selectRemind minutes early",
                lable: "Remind",
                widget: DropdownButton(
                    style: textHeadingStyle,
                    iconSize: 32.sp,
                    elevation: 4,
                    underline: Container(height: 0.0),
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    onChanged: (String? value) => setState(() {
                          _selectRemind = int.parse(value!);
                        })),
              ),
              // remind repeat
              MyTextField(
                hintText: _selectRepeat,
                lable: "Repeat",
                widget: DropdownButton(
                    style: textHeadingStyle,
                    iconSize: 32.sp,
                    elevation: 4,
                    underline: Container(height: 0.0),
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    onChanged: (String? value) => setState(() {
                          _selectRepeat = value!;
                        })),
              ),

              // select bottom color
              SizedBox(height: 18.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(
                      lable: "Create Task",
                      ontap: () {
                        _validator();
                      }),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: textHeadingStyle,
        ),
        SizedBox(height: 8.h),
        Wrap(
          children: List<Widget>.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: CircleAvatar(
                        child: _selectedIndex == index
                            ? Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 14.sp,
                              )
                            : Container(),
                        backgroundColor: index == 0
                            ? bluishClr
                            : index == 1
                                ? yellowClr
                                : pickClr,
                        radius: 14.r,
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  _validator() {
    if (_userTitle.text.isEmpty && _userNote.text.isEmpty) {
      Get.snackbar(
        "Message",
        "All the fields are required.",
        icon: Icon(
          Icons.warning_amber_outlined,
          color: Colors.amber,
        ),
      );
    } else if (_userTitle.text.isEmpty || _userNote.text.isEmpty) {
      Get.snackbar(
        "Message",
        "All the fields are requird.",
        icon: Icon(Icons.warning_amber_outlined),
      );
    } else {
      _addToDatabase();
      Get.back();
    }
  }

  _addToDatabase() async {
    var valueId = await _taskController.addTask(
      task: UserTask(
        title: _userTitle.text,
        note: _userNote.text,
        date: DateFormat.yMd().format(_selectedDate!),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectRemind,
        repeat: _selectRepeat,
        color: _selectedIndex,
        isCompleted: 0,
      ),
    );

    print("My id is $valueId");
  }

  _getUserDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2302),
    );
    if (_datePicker != null) {
      setState(() {
        _selectedDate = _datePicker;
      });
    } else {
      print("Value is null date is not pick by the user successfully.");
    }
  }

  _getUserTIme({required bool isStarttime}) async {
    var userPickTime = await _showTimePicker();
    String _formatedTime = userPickTime.format(context);
    if (userPickTime == null) {
      print("Time is not valid time cancelled");
    } else if (isStarttime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStarttime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.person,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}
