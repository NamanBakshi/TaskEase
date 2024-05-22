import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
class Task {

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late bool isChecked;

  @HiveField(3)
  late String taskDueDate;

  @HiveField(4)
  late Timestamp createdAt;

  Task({required this.id, required this.title, required this.isChecked,
    required this.taskDueDate,required this.createdAt});

  //Returns a decoded model of JSON response from db
  factory Task.fromJson(Map<String, dynamic> jsonData) {

    return Task(
      id: jsonData["id"],
      title: jsonData["title"],
      isChecked: jsonData["isChecked"],
      taskDueDate: jsonData["taskDueDate"],
      createdAt: jsonData["createdAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title" : title,
    "isChecked" : isChecked,
    "taskDueDate" : taskDueDate,
    "createdAt" : createdAt,
  };

}

