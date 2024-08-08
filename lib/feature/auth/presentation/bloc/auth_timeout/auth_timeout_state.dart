part of 'auth_timeout_bloc.dart';

class AuthTimeoutState extends Equatable {
  const AuthTimeoutState({
    this.isVerificationHasTimeOut = false,
    this.remainingTimeForTimeOut = 180,
  });

  @override
  List<Object?> get props => [
        isVerificationHasTimeOut,
        remainingTimeForTimeOut,
      ];

  final bool isVerificationHasTimeOut;
  final int remainingTimeForTimeOut;

  AuthTimeoutState copyWith({
    bool? isVerificationHasTimeOut,
    int? remainingTimeForTimeOut,
  }) {
    return AuthTimeoutState(
      isVerificationHasTimeOut:
          isVerificationHasTimeOut ?? this.isVerificationHasTimeOut,
      remainingTimeForTimeOut:
          remainingTimeForTimeOut ?? this.remainingTimeForTimeOut,
    );
  }
}
