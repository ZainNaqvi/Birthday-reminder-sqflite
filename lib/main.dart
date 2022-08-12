import 'package:example_todo_sqflite/db/db_helper.dart';
import 'package:example_todo_sqflite/services/notification_services.dart';
import 'package:example_todo_sqflite/services/theme_services.dart';
import 'package:example_todo_sqflite/themes.dart';
import 'package:example_todo_sqflite/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init(); 
  await Hive.initFlutter();
  await Hive.openBox('themedata');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ValueListenableBuilder<Box>(
              valueListenable: Hive.box('themedata').listenable(),
              builder: (context, box, widget) {
                var darkMode = box.get('darkmode', defaultValue: false);
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: Themes.light,
                  darkTheme: Themes.dark,
                  themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
                  home: HomePage(
                    box: box,
                    darkMode: darkMode,
                  ),
                );
              }
          );
        });
  }
}
