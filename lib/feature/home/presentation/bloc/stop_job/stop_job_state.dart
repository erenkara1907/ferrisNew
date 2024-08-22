part of 'stop_job_bloc.dart';

final class StopJobState extends Equatable {
  const StopJobState({
    this.failure,
    this.status,
    this.getStopCategoriesResponse = const [],
    this.getStopsResponse = const [],
    this.selectedStop,
    this.totalStop = 0,
    this.isError = false,
  });

  final ViewStatus? status;
  final Failure? failure;
  final List<StopsResponseModelItem> getStopsResponse;
  final StopsResponseModelItem? selectedStop;
  final List<StopCategoriesResponseModelItem> getStopCategoriesResponse;
  final int totalStop;
  final bool isError;

  @override
  List<Object?> get props => [
        status,
        failure,
        getStopsResponse,
        selectedStop,
        getStopCategoriesResponse,
        totalStop,
        isError,
      ];

  StopJobState copyWith({
    ViewStatus? status,
    List<StopsResponseModelItem>? getStopsResponse,
    StopsResponseModelItem? selectedStop,
    List<StopCategoriesResponseModelItem>? getStopCategoriesResponse,
    Failure? failure,
    int? totalStop,
    bool? isError,
  }) {
    return StopJobState(
      failure: failure ?? this.failure,
      isError: isError ?? this.isError,
      status: status ?? this.status,
      getStopsResponse: getStopsResponse ?? this.getStopsResponse,
      selectedStop: selectedStop ?? this.selectedStop,
      totalStop: totalStop ?? this.totalStop,
      getStopCategoriesResponse:
          getStopCategoriesResponse ?? this.getStopCategoriesResponse,
    );
  }
}
