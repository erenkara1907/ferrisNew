part of 'home_bloc.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.status,
    this.failure,
    this.jobs = const [],
    this.showJob,
    this.jobsValet = const [],
    this.jobsValetByType,
    this.getTrackingCoordinatesResponse = const [],
    this.selectedTrackingCoordinate,
    this.jobsTomorrow = const [],
    this.jobsHistory = const [],
    this.isStarted = false,
    this.isAsync = false,
    this.totalExpense = '',
    this.stopCount = 0,
    this.sortedJobs = const [],
    this.isFinished = false,
    this.noNetworkFinished = false,
  });

  final ViewStatus? status;
  final List<ValetStandardResponseModelItem> jobsValet;
  final ValetStandardResponseModelItem? jobsValetByType;
  final List<JobsResponseModelItem> jobs;
  final List<JobsResponseModelItem> jobsTomorrow;
  final List<JobsResponseModelItem> jobsHistory;
  final JobsResponseModelItem? showJob;
  final Failure? failure;
  final List<TrackingCoordinatesResponseModelItem>
      getTrackingCoordinatesResponse;
  final TrackingCoordinatesResponseModelItem? selectedTrackingCoordinate;
  final bool isStarted;
  final bool isAsync;
  final String totalExpense;
  final int stopCount;
  final List<JobsResponseModelItem> sortedJobs;
  final bool isFinished;
  final bool noNetworkFinished;

  @override
  List<Object?> get props => [
        status,
        failure,
        jobs,
        showJob,
        jobsValet,
        jobsValetByType,
        getTrackingCoordinatesResponse,
        jobsHistory,
        jobsTomorrow,
        selectedTrackingCoordinate,
        isStarted,
        isAsync,
        totalExpense,
        stopCount,
        sortedJobs,
        isFinished,
        noNetworkFinished,
      ];

  HomeState copyWith({
    ViewStatus? status,
    List<ValetStandardResponseModelItem>? jobsValet,
    ValetStandardResponseModelItem? jobsValetByType,
    List<JobsResponseModelItem>? jobs,
    JobsResponseModelItem? showJob,
    List<JobsResponseModelItem>? jobsTomorrow,
    List<JobsResponseModelItem>? jobsHistory,
    Failure? failure,
    List<TrackingCoordinatesResponseModelItem>? getTrackingCoordinatesResponse,
    TrackingCoordinatesResponseModelItem? selectedTrackingCoordinate,
    bool? isStarted,
    bool? isAsync,
    String? totalExpense,
    int? stopCount,
    List<JobsResponseModelItem>? sortedJobs,
    bool? isFinished,
    bool? noNetworkFinished,
  }) {
    return HomeState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      jobsHistory: jobsHistory ?? this.jobsHistory,
      isStarted: isStarted ?? this.isStarted,
      jobsValet: jobsValet ?? this.jobsValet,
      totalExpense: totalExpense ?? this.totalExpense,
      stopCount: stopCount ?? this.stopCount,
      jobsTomorrow: jobsTomorrow ?? this.jobsTomorrow,
      showJob: showJob ?? this.showJob,
      jobsValetByType: jobsValetByType ?? this.jobsValetByType,
      isAsync: isAsync ?? this.isAsync,
      getTrackingCoordinatesResponse:
          getTrackingCoordinatesResponse ?? this.getTrackingCoordinatesResponse,
      selectedTrackingCoordinate:
          selectedTrackingCoordinate ?? this.selectedTrackingCoordinate,
      sortedJobs: sortedJobs ?? this.sortedJobs,
      isFinished: isFinished ?? this.isFinished,
      noNetworkFinished: noNetworkFinished ?? this.noNetworkFinished,
    );
  }
}
