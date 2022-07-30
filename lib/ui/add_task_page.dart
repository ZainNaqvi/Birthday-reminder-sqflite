import 'package:example_todo_sqflite/themes.dart';
import 'package:example_todo_sqflite/ui/constants.dart';
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
  DateTime? _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = "9:29 AM";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 10.h),
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
              ),
              MyTextField(
                lable: "Note",
                hintText: "Enter the note",
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
            ],
          ),
        ),
      ),
    );
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
      backgroundColor: Get.isDarkMode ? darkgreyClr : Colors.white,
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
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}
