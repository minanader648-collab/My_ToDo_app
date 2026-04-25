import 'package:hive/hive.dart';

part 'sub_task_model.g.dart';

@HiveType(typeId: 2)
class SubTaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  SubTaskModel({
    required this.title,
    required this.isDone,
  });
}
