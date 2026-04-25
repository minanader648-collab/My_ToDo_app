abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}

class AddTaskUpdated extends AddTaskState {}

class AddTaskLoading extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {}

class AddTaskFailure extends AddTaskState {
  final String errMessage;
  AddTaskFailure({required this.errMessage});
}
