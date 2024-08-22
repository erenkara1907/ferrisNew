part of 'stop_job_bloc.dart';

sealed class StopJobEvent extends Equatable {
  const StopJobEvent();

  @override
  List<Object> get props => [];
}

class PostJobStops extends StopJobEvent {
  final int jobId;
  final StopPostModel data;
  final bool isAsync;

  const PostJobStops({
    required this.jobId,
    required this.data,
    required this.isAsync,
  });

  @override
  List<Object> get props => [jobId, data, isAsync];
}

class PostJobStopsControl extends StopJobEvent {
  const PostJobStopsControl();

  @override
  List<Object> get props => [];
}

class GetJobStopsCategories extends StopJobEvent {
  const GetJobStopsCategories();

  @override
  List<Object> get props => [];
}

class GetJobStops extends StopJobEvent {
  final int jobId;

  const GetJobStops(this.jobId);

  @override
  List<Object> get props => [jobId];
}

class SetJobStopCategories extends StopJobEvent {
  const SetJobStopCategories();

  @override
  List<Object> get props => [];
}

class SetJobStop extends StopJobEvent {
  const SetJobStop();

  @override
  List<Object> get props => [];
}

class ClearJobStops extends StopJobEvent {
  const ClearJobStops();

  @override
  List<Object> get props => [];
}
