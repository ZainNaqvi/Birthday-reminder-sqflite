import 'package:example_todo_sqflite/ui/constants.dart';
import 'package:flutter/material.dart';

class Themes {
  // light theme
  static final light = ThemeData(
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  // dark theme
  static final dark = ThemeData(
    primaryColor: darkgreyClr,
    brightness: Brightness.dark,
  );
}
