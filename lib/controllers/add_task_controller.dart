import 'package:example_todo_sqflite/db/db_helper.dart';
import 'package:example_todo_sqflite/models/task_model.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  @override
  void onReady() {

    super.onReady();
  }

// inserting the object to the database
  var taskList = <UserTask>[].obs;
  Future<int> addTask({UserTask? task}) async {
    return await DBHelper.insert(task);
  }

// reading the object from the database
  void getTask() async {
    print("read function is called");
    List<Map<String, dynamic?>>? tasks = await DBHelper.query();
    taskList.assignAll(tasks!.map((e) => UserTask.fromJson(e)).toList());
  }
}
