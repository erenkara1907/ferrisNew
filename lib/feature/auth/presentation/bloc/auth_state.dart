part of 'auth_bloc.dart';

final class AuthState extends Equatable {
  const AuthState(
      {this.failure,
      this.status,
      this.user,
      this.loginResponseModel,
      this.userModel,
      this.isCodeSent = false,
      this.isVerificationCompleted = false,
      this.isSaveLocal = false,
      this.sendOTPError = '',
      this.verifyOTPError = '',
      this.email = '',
      this.password = '',
      this.authStatus,
      this.deviceId = '',
      this.otpCode = ''});

  final ViewStatus? status;
  final ViewStatus? authStatus;
  final Failure? failure;
  final LoginResponseModel? loginResponseModel;
  final UserResponseModel? userModel;
  final UserModel? user;
  final bool isCodeSent;
  final bool isVerificationCompleted;
  final String sendOTPError;
  final String verifyOTPError;
  final String otpCode;
  final String deviceId;
  final String? email;
  final String? password;
  final bool isSaveLocal;

  @override
  List<Object?> get props => [
        status,
        failure,
        user,
        isCodeSent,
        isVerificationCompleted,
        sendOTPError,
        verifyOTPError,
        otpCode,
        deviceId,
        userModel,
        email,
        password,
        loginResponseModel,
        authStatus,
        isSaveLocal
      ];

  AuthState copyWith({
    ViewStatus? status,
    Failure? failure,
    UserModel? user,
    bool? isCodeSent,
    bool? isVerificationCompleted,
    String? sendOTPError,
    String? verifyOTPError,
    String? otpCode,
    LoginResponseModel? loginResponseModel,
    UserResponseModel? userModel,
    String? email,
    String? password,
    bool? isSaveLocal,
    ViewStatus? authStatus,
    String? deviceId,
  }) {
    return AuthState(
        failure: failure ?? this.failure,
        authStatus: authStatus ?? this.authStatus,
        status: status ?? this.status,
        user: user ?? this.user,
        isSaveLocal: isSaveLocal ?? this.isSaveLocal,
        isCodeSent: isCodeSent ?? this.isCodeSent,
        isVerificationCompleted:
            isVerificationCompleted ?? this.isVerificationCompleted,
        sendOTPError: sendOTPError ?? this.sendOTPError,
        verifyOTPError: verifyOTPError ?? this.verifyOTPError,
        deviceId: deviceId ?? this.deviceId,
        loginResponseModel: loginResponseModel ?? this.loginResponseModel,
        userModel: userModel ?? this.userModel,
        email: email ?? this.email,
        password: password ?? this.password,
        otpCode: otpCode ?? this.otpCode);
  }
}
