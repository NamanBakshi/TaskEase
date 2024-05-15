import 'package:hive/hive.dart';

import '../model/task.dart';

class LocalStorage {

  Future<List<Task>?> getBoxData() async {
    var box = await Hive.openBox('tBox');
    var boxData = box.get('allTasks');
    box.close();
    List<Task>? tList = [];
    int i = 0;
    if (boxData != null) {
      for (Task element in boxData) {
        element.id = i.toString();
        tList.add(element);
        i++;
      }
    } else {
      tList = null;
    }
    return tList;
  }

  saveTask(List<Task> taskData) async {
    var box = await Hive.openBox('tBox');
    box.put('allTasks', taskData);
    box.close();
  }

  deleteBox() async {
    var box = await Hive.openBox('tBox') ;
    box.delete('allTasks');
    box.close();
  }

  deleteTask(int index) async {
    var box = await Hive.openBox('tBox');
    var boxData = box.get('allTasks');

    List<Task>? tList = [];
    int i=0;
    for (Task element in boxData) {
      if(i != index) tList.add(element);
      i++;
    }
    box.put('allTasks', tList);
    box.close();
    return tList;
  }

  Future<List<Task>> editTask(int index, String updatedTitle) async {
    var box = await Hive.openBox('tBox');
    var boxData = box.get('allTasks');
    List<Task>? tList = [];

    int i = 0;
    for (Task element in boxData) {
      if (i == index) element.title = updatedTitle;
      tList.add(element);
      i++;
    }
    box.put('allTasks', tList);

    box.close();
    return tList;
  }

  updateCheckbox(int index) async {
    var box = await Hive.openBox('tBox');
    var boxData = box.get('allTasks');
    List<Task>? tList = [];

    int i = 0;
    for (Task element in boxData) {
      if (i == index) element.isChecked = !element.isChecked;
      tList.add(element);
      i++;
    }
    box.put('allTasks', tList);

    box.close();
    return tList;

  }
}
