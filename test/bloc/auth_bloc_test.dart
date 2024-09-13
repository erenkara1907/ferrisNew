import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/hive/database_cache_mock.dart';
import 'mock/auth/auth_service_mock.dart';

void main() {
  late AuthBloc authBloc;
  // late AuthCacheMock authCacheMock;
  setUp(() {
    // authCacheMock = AuthCacheMock();
    authBloc = AuthBloc(
      ucGetAuth: AuthServiceMock(),
      hiveDatabaseManager: DatabaseCacheMock(),
    );

    // authCacheMock.getUserModel();
  });

  blocTest<AuthBloc, AuthState>(
    'login user',
    build: () => authBloc,
    act: (bloc) =>
        bloc.add(const LoginEvent(email: "test@gmail.com", password: "123")),
    expect: () => [
      isA<AuthState>().having(
          (state) => state.status, 'status laoding', ViewStatus.loading),
      isA<AuthState>().having(
          (state) => state.loginResponseModel, 'login model', isNotNull),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'logout user',
    build: () => authBloc,
    act: (bloc) => bloc.add(const LogoutEvent(deviceToken: "testDeviceToken")),
    expect: () => [
      isA<AuthState>().having(
          (state) => state.status, 'status laoding', ViewStatus.loading),
      isA<AuthState>().having(
          (state) => state.status, 'status success', ViewStatus.success),
    ],
  );

  //TODO: Get the data from event.
  blocTest<AuthBloc, AuthState>(
    'verify otp',
    build: () => authBloc,
    act: (bloc) => bloc.add(const VerifyOtpEvent()),
    expect: () => [
      isA<AuthState>().having(
          (state) => state.status, 'status laoding', ViewStatus.loading),
      isA<AuthState>().having(
          (state) => state.status, 'status success', ViewStatus.success),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'get user',
    build: () => authBloc,
    act: (bloc) => bloc.add(const GetUserEvent()),
    expect: () => [
      isA<AuthState>().having(
          (state) => state.status, 'status laoding', ViewStatus.loading),
      isA<AuthState>()
          .having((state) => state.userModel, 'user response model', isNotNull),
    ],
  );
}
