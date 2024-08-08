part of 'auth_timeout_bloc.dart';

abstract class AuthTimeoutEvent extends Equatable {
  const AuthTimeoutEvent();

  @override
  List<Object> get props => [];
}

class UpdateRemainingTimeEvent extends AuthTimeoutEvent {
  const UpdateRemainingTimeEvent({required this.remainingTime});
  final int remainingTime;

  @override
  List<Object> get props => [remainingTime];
}

class StartCountdownTimerEvent extends AuthTimeoutEvent {
  const StartCountdownTimerEvent();

  @override
  List<Object> get props => [];
}

class ResetAuthTimeoutStateEvent extends AuthTimeoutEvent {
  const ResetAuthTimeoutStateEvent();

  @override
  List<Object> get props => [];
}
