part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class ClearAuthEvent extends AuthEvent {
  const ClearAuthEvent();
}

class VerifyOtpEvent extends AuthEvent {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class SetDeviceIdEvent extends AuthEvent {
  const SetDeviceIdEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordEvent extends AuthEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class LogoutEvent extends AuthEvent {
  final String deviceToken;

  const LogoutEvent({
    required this.deviceToken,
  });

  @override
  List<Object> get props => [deviceToken];
}

class GetUserEvent extends AuthEvent {
  const GetUserEvent();
}

class ResetStateEvent extends AuthEvent {
  const ResetStateEvent();
}

class ResetVerificationEvent extends AuthEvent {
  const ResetVerificationEvent();
}

class ChangeOtpEvent extends AuthEvent {
  final String otp;

  const ChangeOtpEvent({
    required this.otp,
  });

  @override
  List<Object> get props => [otp];
}

class SetIsSaveLocal extends AuthEvent {
  final bool isSaveLocal;

  const SetIsSaveLocal({
    required this.isSaveLocal,
  });

  @override
  List<Object> get props => [isSaveLocal];
}
