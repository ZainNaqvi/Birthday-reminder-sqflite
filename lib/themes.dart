import 'package:example_todo_sqflite/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  // light theme
  static final light = ThemeData(
    backgroundColor: white,
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  // dark theme
  static final dark = ThemeData(
    backgroundColor: darkgreyClr,
    primaryColor: darkgreyClr,
    brightness: Brightness.dark,
  );
}


TextStyle get subHeadingStyle {
  return (GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24.sp,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      fontWeight: FontWeight.w500,
    ),
  ));
}

TextStyle get headingStyle {
  return (GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 30.sp,
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontWeight: FontWeight.w500,
    ),
  ));
}
