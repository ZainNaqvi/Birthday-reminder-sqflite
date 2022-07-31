import 'package:example_todo_sqflite/db/db_helper.dart';
import 'package:example_todo_sqflite/services/notification_services.dart';
import 'package:example_todo_sqflite/services/theme_services.dart';
import 'package:example_todo_sqflite/themes.dart';
import 'package:example_todo_sqflite/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
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
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Themes.light,
            darkTheme: Themes.dark,
            themeMode: ThemeServices().theme,
            home: const HomePage(),
          );
        });
  }
}
