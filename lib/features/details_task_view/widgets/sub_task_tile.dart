import 'package:flutter/material.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/core/models/task_model.dart';
import 'package:project_mobile_application/core/models/sub_task_model.dart';
import 'package:project_mobile_application/features/details_task_view/cubit/details_task_cubit.dart';

class SubTaskTile extends StatelessWidget {
  final DetailsTaskCubit cubit;
  final TaskModel task;
  final SubTaskModel subTask;
  final Color color;

  const SubTaskTile({
    super.key,
    required this.cubit,
    required this.task,
    required this.subTask,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => cubit.toggleSubTask(task, subTask),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: subTask.isDone ? color : Colors.grey.withValues(alpha: 0.5),
                  width: 2,
                ),
                color: subTask.isDone ? color : Colors.transparent,
              ),
              child: subTask.isDone 
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              subTask.title,
              style: TextStyle(
                fontSize: 16,
                color: subTask.isDone ? Colors.grey : textDark,
                decoration: subTask.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
