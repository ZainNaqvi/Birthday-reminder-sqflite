import 'package:example_todo_sqflite/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final String lable;
  final TextEditingController? controller;
  final Widget? widget;
  MyTextField(
      {Key? key,
      required this.hintText,
      required this.lable,
      this.controller,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style: textHeadingStyle,
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            height: 42.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                    autofocus: false,
                    autocorrect: true,
                    controller: controller,
                    style: textInputStyle,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder(context),
                      border: InputBorder(context),
                      hintStyle: hintStyle,
                      hintText: hintText,
                      focusedBorder: InputBorder(context),
                    ),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  UnderlineInputBorder InputBorder(BuildContext context) {
    return UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
