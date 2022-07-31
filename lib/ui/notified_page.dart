import 'package:example_todo_sqflite/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String lable;
  const NotifiedPage({Key? key, required this.lable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, lable),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 400.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: Get.isDarkMode ? Colors.black : Colors.grey[600],
            ),
            child: Center(
              child: Text(
                lable.split("|")[1],
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "cursive",
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String label) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        onPressed: () async {
          Get.back();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.arrow_back_ios : Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
        ),
      ),
      title: Center(
        child: Text(
          lable.split("|")[0].toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
