abstract class DetailsTaskState {}

class DetailsTaskInitial extends DetailsTaskState {}

class DetailsTaskUpdated extends DetailsTaskState {}

class DetailsTaskLoading extends DetailsTaskState {}

class DetailsTaskSuccess extends DetailsTaskState {
  final String action; // e.g. 'delete', 'complete'
  DetailsTaskSuccess({required this.action});
}

class DetailsTaskFailure extends DetailsTaskState {
  final String errMessage;
  DetailsTaskFailure({required this.errMessage});
}
