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

// deleting the task using the specific id
  Future<void> delete({required UserTask task}) async {
    var id = await DBHelper.delete(task: task);
    print(id);
    getTask();
  }

// updating the task in the database by id
  Future<void> updateTask(int id) async {
    var value = await DBHelper.update(id);
    print(value);
    getTask();
  }
}
