import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/auth_service_mock.dart';

void main() {
  late AuthBloc authBloc;
  setUp(() {
    authBloc = AuthBloc(
      ucGetAuth: AuthServiceMock(),
    );
  });

  blocTest<AuthBloc, AuthState>(
    'login user',
    build: () => authBloc,
    act: (bloc) => bloc.add(const LoginEvent(
        email: "office@yunggroup.com", password: "FerrisOffice327\$")),
    expect: () => [
      isA<AuthState>()
          .having((state) => state.isCodeSent, 'is code sent', true),
    ],
  );
}
