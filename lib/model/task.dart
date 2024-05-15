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

  Task({required this.id, required this.title, required this.isChecked});

  //Returns a decoded model of JSON response from db
  factory Task.fromJson(Map<String, dynamic> jsonData) {

    return Task(
      id: jsonData["id"],
      title: jsonData["title"],
      isChecked: jsonData["isChecked"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title" : title,
    "isChecked" : isChecked,
  };

}

