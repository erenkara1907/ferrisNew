part of 'landing_bloc.dart';

final class LandingState extends Equatable {
  const LandingState({
    this.status = ViewStatus.loading,
    this.failure,
    this.networkResult = false,

  });

  final ViewStatus status;
  final Failure? failure;
  final bool networkResult;

  @override
  List<Object?> get props => [status, failure, networkResult];

  LandingState copyWith({
    ViewStatus? status,
    Failure? failure,
    bool? networkResult,
  }) {
    return LandingState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      networkResult: networkResult ?? this.networkResult,
    );
  }
}