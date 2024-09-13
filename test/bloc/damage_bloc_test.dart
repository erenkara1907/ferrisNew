import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_damage/job_damage_bloc.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/damage/damage_service_mock.dart';
import 'mock/hive/storage_cache_mock.dart';

void main() {
  late JobDamageBloc jobDamageBloc;

  setUp(() {
    jobDamageBloc = JobDamageBloc(
      ucGetJobDamage: DamageServiceMock(),
      hiveStorageManager: StorageCacheMock(),
    );
  });

  blocTest<JobDamageBloc, JobDamageState>(
    'get all damage assets',
    build: () => jobDamageBloc,
    act: (bloc) => bloc.add(
      const GetAllDamageAssets(),
    ),
    expect: () => [
      isA<JobDamageState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobDamageState>().having(
          (state) => state.damageAssetsModel, 'damage assets', isNotNull),
    ],
  );

  blocTest<JobDamageBloc, JobDamageState>(
    'get all damage combination',
    build: () => jobDamageBloc,
    act: (bloc) => bloc.add(
      const GetAllDamageCombination(),
    ),
    expect: () => [
      isA<JobDamageState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobDamageState>().having((state) => state.damageCombinationModel,
          'damage combinations', isNotNull),
    ],
  );

  blocTest<JobDamageBloc, JobDamageState>(
    'get all grade',
    build: () => jobDamageBloc,
    act: (bloc) => bloc.add(
      const GetAllGrade(),
    ),
    expect: () => [
      isA<JobDamageState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobDamageState>()
          .having((state) => state.gradeModel, 'grades', isNotNull),
    ],
  );

  blocTest<JobDamageBloc, JobDamageState>(
    'get all grade rule',
    build: () => jobDamageBloc,
    act: (bloc) => bloc.add(
      const GetAllGradeRule(),
    ),
    expect: () => [
      isA<JobDamageState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobDamageState>()
          .having((state) => state.gradeRuleModel, 'grade rules', isNotNull),
    ],
  );

  blocTest<JobDamageBloc, JobDamageState>(
    'get all grade rule uplift',
    build: () => jobDamageBloc,
    act: (bloc) => bloc.add(
      const GetAllGradeRuleUplift(),
    ),
    expect: () => [
      isA<JobDamageState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobDamageState>().having((state) => state.gradeRuleUpliftModel,
          'grade rule uplifts', isNotNull),
    ],
  );

  blocTest<JobDamageBloc, JobDamageState>(
    'set damage categories',
    build: () => jobDamageBloc,
    act: (bloc) => bloc.add(
      const SetDamageCategories(),
    ),
    expect: () => [
      isA<JobDamageState>().having((state) => state.getDamageCategoriesResponse,
          'damage categories', isNotNull),
    ],
  );
}
