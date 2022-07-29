import 'package:example_todo_sqflite/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  // light theme
  static final light = ThemeData(
    backgroundColor: Colors.white,
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
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ));
}
