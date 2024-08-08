import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_timeout_event.dart';
part 'auth_timeout_state.dart';

class AuthTimeoutBloc extends Bloc<AuthTimeoutEvent, AuthTimeoutState> {
  AuthTimeoutBloc() : super(const AuthTimeoutState()) {
    on<UpdateRemainingTimeEvent>(
      countdownTimerForVerifyOTP,
    );
    on<StartCountdownTimerEvent>(
      startCountdownTimer,
    );
    on<ResetAuthTimeoutStateEvent>(
      resetAuthTimeoutState,
    );
  }
  StreamSubscription<int>? countdownTimerSubscription;

  @override
  Future<void> close() async {
    await countdownTimerSubscription?.cancel();
    await super.close();
  }

  Future<void> startCountdownTimer(
    StartCountdownTimerEvent event,
    Emitter<AuthTimeoutState> emit,
  ) async {
    if (countdownTimerSubscription != null) {
      await countdownTimerSubscription?.cancel();
    }

    countdownTimerSubscription =
        countdownTimer(durationInSeconds: 120).listen(_listenCountdownTimer);
  }

  void resetAuthTimeoutState(
    ResetAuthTimeoutStateEvent event,
    Emitter<AuthTimeoutState> emit,
  ) {
    emit(
      state.copyWith(
        isVerificationHasTimeOut: false,
        remainingTimeForTimeOut: 180,
      ),
    );
  }

  Stream<int> countdownTimer({
    required int durationInSeconds,
  }) async* {
    for (var i = durationInSeconds; i >= 0; i--) {
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _listenCountdownTimer(int remainingTime) {
    add(UpdateRemainingTimeEvent(remainingTime: remainingTime));
  }

  void countdownTimerForVerifyOTP(
    UpdateRemainingTimeEvent event,
    Emitter<AuthTimeoutState> emit,
  ) {
    final remainingTime = event.remainingTime;

    if (remainingTime == 0) {
      countdownTimerSubscription?.cancel();
      emit(state.copyWith(isVerificationHasTimeOut: true));
    }

    emit(state.copyWith(remainingTimeForTimeOut: remainingTime));
  }
}
