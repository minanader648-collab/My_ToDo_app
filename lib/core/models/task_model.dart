import 'package:hive/hive.dart';
import 'package:project_mobile_application/core/models/sub_task_model.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String subtitle; 

  @HiveField(3)
  String priority;

  @HiveField(4)
  bool isDone;

  @HiveField(5)
  String colorHex;

  @HiveField(6)
  String description;

  @HiveField(7)
  String date;

  @HiveField(8)
  String time;

  @HiveField(9)
  String category;

  @HiveField(10)
  List<SubTaskModel>? subTasks;

  TaskModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priority,
    required this.isDone,
    required this.colorHex,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    this.subTasks,
  });
}
