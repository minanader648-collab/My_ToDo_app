import 'package:project_mobile_application/core/models/task_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSuccess extends HomeState {
  final List<TaskModel> tasks;
  final int total;
  final int active;
  final int done;

  HomeSuccess({
    required this.tasks,
    required this.total,
    required this.active,
    required this.done,
  });
}
