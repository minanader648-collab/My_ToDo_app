import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile_application/core/models/task_model.dart';
import 'package:project_mobile_application/core/models/sub_task_model.dart';
import 'details_task_state.dart';

class DetailsTaskCubit extends Cubit<DetailsTaskState> {
  DetailsTaskCubit() : super(DetailsTaskInitial());

  void toggleSubTask(TaskModel task, SubTaskModel subTask) {
    subTask.isDone = !subTask.isDone;
    task.save(); // Save to Hive
    emit(DetailsTaskUpdated());
  }

  void markAsComplete(TaskModel task) {
    emit(DetailsTaskLoading());
    try {
      task.isDone = true;
      task.save();
      emit(DetailsTaskSuccess(action: 'complete'));
    } catch (e) {
      emit(DetailsTaskFailure(errMessage: e.toString()));
    }
  }

  void deleteTask(TaskModel task) {
    emit(DetailsTaskLoading());
    try {
      task.delete(); // Delete from Hive
      emit(DetailsTaskSuccess(action: 'delete'));
    } catch (e) {
      emit(DetailsTaskFailure(errMessage: e.toString()));
    }
  }
}
