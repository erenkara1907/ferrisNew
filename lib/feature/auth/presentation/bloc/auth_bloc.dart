import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/auth/data/models/login_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/feature/auth/domain/usecases/uc_get_auth.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required HiveDatabaseManager hiveDatabaseManager,
    required UCGetAuth ucGetAuth,
  })  : _ucGetAuth = ucGetAuth,
        _hiveDatabaseManager = hiveDatabaseManager,
        super(const AuthState()) {
    // _hiveDatabaseManager = ProductStateItems.hiveDatabaseManager;
    on<LoginEvent>(onLogin);
    on<LogoutEvent>(onLogout);
    on<SetDeviceIdEvent>(_onSetDeviceId);
    on<ChangePasswordEvent>(_onChangePassword);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<GetUserEvent>(onGetUser);
    on<ResetStateEvent>(_onResetState);
    on<ResetVerificationEvent>(_resetVerificationEvent);
    on<ChangeOtpEvent>(_changeOtp);
    on<SetIsSaveLocal>(_setIsSaveLocal);
    on<ClearAuthEvent>(_clearAuthEvent);
  }

  late final HiveDatabaseManager _hiveDatabaseManager;
  final UCGetAuth _ucGetAuth;

  Future<void> onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, isCodeSent: false));

    final result = await _ucGetAuth.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ViewStatus.failure,
          failure: failure,
        ));
      },
      (data) {
        emit(state.copyWith(
            status: ViewStatus.success,
            loginResponseModel: data,
            email: event.email,
            password: event.password,
            isCodeSent: true));
      },
    );
  }

  void _clearAuthEvent(ClearAuthEvent event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }

  Future<void> onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _ucGetAuth.logout(
      deviceToken: event.deviceToken,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ViewStatus.failure,
          failure: failure,
        ));
      },
      (data) async {
        if (_hiveDatabaseManager.getUserModel() != null) {
          if (_hiveDatabaseManager.getUserModel()!.currentJobId != null &&
              _hiveDatabaseManager.getUserModel()!.currentJobId != "") {
            ProductStateItems.appRouter.router.routerDelegate.navigatorKey.currentContext?.pop();
            BotToast.showText(text: 'Please complete the job before logging out');
            return;
          }
        }
        _hiveDatabaseManager.deleteUserModel();

        emit(state.copyWith(
          status: ViewStatus.success,
        ));
      },
    );
  }

  Future<void> _onSetDeviceId(SetDeviceIdEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final message = await FirebaseMessaging.instance.getToken();

    _ucGetAuth.setDeviceId(deviceId: message ?? '');
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _ucGetAuth.changePassword(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ViewStatus.failure,
          failure: failure,
        ));
      },
      (data) {
        emit(state.copyWith(
          status: ViewStatus.success,
        ));
      },
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    print("girdi bloc verify");
    emit(state.copyWith(authStatus: ViewStatus.loading, isVerificationCompleted: false));

    final result = await _ucGetAuth.verifyOtp(
      userId: state.loginResponseModel!.userId ?? 0,
      token: state.loginResponseModel!.token,
      code: state.otpCode,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          authStatus: ViewStatus.failure,
          failure: failure,
        ));
      },
      (data) async {
        if (_hiveDatabaseManager.getUserModel() == null) {
          _hiveDatabaseManager.saveUserModel(UserModel(
            mail: state.email,
            token: data.accessToken,
          ));
        } else {
          _hiveDatabaseManager.updateToken(mail: state.email ?? "", token: data.accessToken);
        }
        emit(state.copyWith(
          authStatus: ViewStatus.success,
          isVerificationCompleted: true,
        ));
      },
    );
  }

  Future<void> onGetUser(GetUserEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _ucGetAuth.getUserInfo();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ViewStatus.failure,
          failure: failure,
        ));
      },
      (data) {
        emit(state.copyWith(status: ViewStatus.success, userModel: data));
      },
    );
  }

  void _onResetState(ResetStateEvent event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }

  void _resetVerificationEvent(ResetVerificationEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(
        isVerificationCompleted: false,
        isCodeSent: false,
        otpCode: '',
        verifyOTPError: '',
        sendOTPError: '',
        isSaveLocal: false,
        status: null,
        loginResponseModel: null,
        email: '',
        password: ''));
  }

  void _changeOtp(ChangeOtpEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(otpCode: event.otp));
  }

  void _setIsSaveLocal(SetIsSaveLocal event, Emitter<AuthState> emit) {
    emit(state.copyWith(isSaveLocal: event.isSaveLocal));
  }
}
