import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/landing/presentation/bloc/landing_bloc.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LandingBloc landingBloc;

  setUp(() {
    landingBloc = LandingBloc();
  });

  blocTest<LandingBloc, LandingState>(
    'check connection',
    build: () => landingBloc,
    act: (bloc) => bloc.add(
      CheckConnection(),
    ),
    expect: () => [
      isA<LandingState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<LandingState>()
          .having((state) => state.networkResult, 'network result', false),
    ],
  );
}
