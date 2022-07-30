import 'package:example_todo_sqflite/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";
  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "tasks.db";
      _db = await openDatabase(_path, version: _version,
          onCreate: (db, version) async {
        print("creating a new one");
        return await db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT,date STRING, start_time STRING,end_time STRING,remind INTEGER,repeat STRING,color INTEGER,is_completed INTEGER)');
      });
    } catch (e) {
      print(e);
    }
  }

  // insert Method
  static Future<int> insert(UserTask? task) async {
    print("insert function is called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  // read Method
  static Future<List<Map<String, Object?>>?> query() async {
    print("read function is called");
    return await _db?.query(_tableName);
  }

  // delete Method
  static Future<int?> delete({required UserTask task}) async {
    print("delete function is called");
    return await _db?.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  // update Method
  static Future<int> update(int id) async {
    print("update function is running");
    return await _db!.rawUpdate('''
UPDATE $_tableName SET is_completed=?
where id  =?

''', [1, id]);
  }
}
