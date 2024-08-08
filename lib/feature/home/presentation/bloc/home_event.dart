part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetJobs extends HomeEvent {
  const GetJobs();

  @override
  List<Object> get props => [];
}

class SortJobs extends HomeEvent {
  final List<JobsResponseModelItem> unsortedJobs;
  const SortJobs({required this.unsortedJobs});
  @override
  List<Object> get props => [unsortedJobs];
}

class GetJob extends HomeEvent {
  final String jobId;

  const GetJob(this.jobId);

  @override
  List<Object> get props => [jobId];
}

class GetJobTomorrow extends HomeEvent {
  const GetJobTomorrow();

  @override
  List<Object> get props => [];
}

class GetJobHistory extends HomeEvent {
  const GetJobHistory();

  @override
  List<Object> get props => [];
}

class GetJobsValet extends HomeEvent {
  const GetJobsValet();

  @override
  List<Object> get props => [];
}

class GetJobShowValetByType extends HomeEvent {
  final int movementTypeId;

  const GetJobShowValetByType(this.movementTypeId);

  @override
  List<Object> get props => [movementTypeId];
}

class StartJob extends HomeEvent {
  final JobsResponseModelItem jobShowModel;
  final BuildContext context;

  const StartJob(this.jobShowModel, this.context);

  @override
  List<Object> get props => [
        jobShowModel,
      ];
}

class EndJob extends HomeEvent {
  final String id;
  final EndJobPostModel data;
  final BuildContext context;
  final bool isViewFuel;
  final bool isFeedBackView;
  final FeedbackInputAvailability? feedbackInputAvailability;

  const EndJob({
    required this.id,
    required this.data,
    required this.context,
    required this.isViewFuel,
    required this.isFeedBackView,
    this.feedbackInputAvailability,
  });

  @override
  List<Object> get props => [
        id,
        data,
        context,
        isViewFuel,
        isFeedBackView,
        feedbackInputAvailability ?? '',
      ];
}

class UpdateJob extends HomeEvent {
  final String id;
  final UpdateJobStatusPostModel data;
  final bool isAsync;

  const UpdateJob(
    this.id,
    this.data,
    this.isAsync,
  );

  @override
  List<Object> get props => [id, data, isAsync];
}

class GetJobTracingCordinates extends HomeEvent {
  final int jobId;

  const GetJobTracingCordinates(this.jobId);

  @override
  List<Object> get props => [jobId];
}

class GetTrackingCoordinate extends HomeEvent {
  final int id;

  const GetTrackingCoordinate(
    this.id,
  );

  @override
  List<Object> get props => [
        id,
      ];
}

class SetJob extends HomeEvent {
  final JobsResponseModelItem jobModel;

  const SetJob(this.jobModel);

  @override
  List<Object> get props => [jobModel];
}

class ClearJob extends HomeEvent {
  const ClearJob();

  @override
  List<Object> get props => [];
}

class SetValetJob extends HomeEvent {
  const SetValetJob();

  @override
  List<Object> get props => [];
}

class SetTrackingCoordinate extends HomeEvent {
  const SetTrackingCoordinate();

  @override
  List<Object> get props => [];
}

class SetExpenseCount extends HomeEvent {
  final String totalExpense;

  const SetExpenseCount(this.totalExpense);

  @override
  List<Object> get props => [totalExpense];
}

class SetStopCount extends HomeEvent {
  const SetStopCount();

  @override
  List<Object> get props => [];
}

class UpdateTrackingCoordinate extends HomeEvent {
  final int jobId;
  final double latitude;
  final double longitude;

  const UpdateTrackingCoordinate({
    required this.jobId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [
        jobId,
        latitude,
        longitude,
      ];
}

class ConfirmJob extends HomeEvent {
  final int id;
  final bool isDetail;

  const ConfirmJob(this.id, this.isDetail);

  @override
  List<Object> get props => [id];
}

class FinishJobResetHome extends HomeEvent {
  const FinishJobResetHome();

  @override
  List<Object> get props => [];
}
