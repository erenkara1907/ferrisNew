part of 'stop_job_bloc.dart';

final class StopJobState extends Equatable {
  const StopJobState({
    this.failure,
    this.status,
    this.getStopCategoriesResponse = const [],
    this.getStopsResponse = const [],
    this.selectedStop,
    this.totalStop = 0,
  });

  final ViewStatus? status;
  final Failure? failure;
  final List<StopsResponseModelItem> getStopsResponse;
  final StopsResponseModelItem? selectedStop;
  final List<StopCategoriesResponseModelItem> getStopCategoriesResponse;
  final int totalStop;

  @override
  List<Object?> get props => [
        status,
        failure,
        getStopsResponse,
        selectedStop,
        getStopCategoriesResponse,
        totalStop,
      ];

  StopJobState copyWith({
    ViewStatus? status,
    List<StopsResponseModelItem>? getStopsResponse,
    StopsResponseModelItem? selectedStop,
    List<StopCategoriesResponseModelItem>? getStopCategoriesResponse,
    Failure? failure,
    int? totalStop,
  }) {
    return StopJobState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      getStopsResponse: getStopsResponse ?? this.getStopsResponse,
      selectedStop: selectedStop ?? this.selectedStop,
      totalStop: totalStop ?? this.totalStop,
      getStopCategoriesResponse:
          getStopCategoriesResponse ?? this.getStopCategoriesResponse,
    );
  }
}
