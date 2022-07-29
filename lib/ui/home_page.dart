import 'package:example_todo_sqflite/services/theme_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Text("Hello"),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().updateTheme();
        },
        icon: Icon(Icons.nightlight_round),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ThemeServices().updateTheme();
          },
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}
