import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/hive/database_cache_mock.dart';
import 'mock/hive/storage_cache_mock.dart';
import 'mock/stop/stop_service_mock.dart';

void main() {
  late StopJobBloc stopJobBloc;

  setUp(() {
    stopJobBloc = StopJobBloc(
      ucGetJobStop: StopServiceMock(),
      hiveDatabaseManager: DatabaseCacheMock(),
      hiveStorageManager: StorageCacheMock(),
    );
  });

  blocTest<StopJobBloc, StopJobState>(
    'clear job stops',
    build: () => stopJobBloc,
    act: (bloc) => bloc.add(const ClearJobStops()),
    expect: () => [
      isA<StopJobState>()
          .having((state) => state.getStopsResponse, 'stop response', isEmpty),
    ],
  );

  blocTest<StopJobBloc, StopJobState>(
    'get job stops',
    build: () => stopJobBloc,
    act: (bloc) => bloc.add(const GetJobStops(1)),
    expect: () => [
      isA<StopJobState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<StopJobState>().having(
          (state) => state.getStopsResponse, 'stop response', isNotNull),
    ],
  );

  blocTest<StopJobBloc, StopJobState>(
    'post job stop control',
    build: () => stopJobBloc,
    act: (bloc) => bloc.add(const PostJobStopsControl()),
    expect: () => [
      isA<StopJobState>().having((state) => state.isError, 'is error', true),
    ],
  );

  blocTest<StopJobBloc, StopJobState>(
    'post job stop',
    build: () => stopJobBloc,
    act: (bloc) => bloc.add(
      PostJobStops(
        isAsync: false,
        jobId: 1,
        data: StopPostModel(
          jobId: 1,
          latitude: 20.0,
          longitude: 20.0,
          evidences: [],
        ),
      ),
    ),
    expect: () => [
      isA<StopJobState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<StopJobState>()
          .having((state) => state.selectedStop, 'selected stop', isNotNull),
    ],
  );

  blocTest<StopJobBloc, StopJobState>(
    'get job stop categories',
    build: () => stopJobBloc,
    act: (bloc) => bloc.add(
      const GetJobStopsCategories(),
    ),
    expect: () => [
      isA<StopJobState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<StopJobState>().having((state) => state.getStopCategoriesResponse,
          'stop categories', isNotNull),
    ],
  );

  blocTest<StopJobBloc, StopJobState>(
    'set job stop categories',
    build: () => stopJobBloc,
    act: (bloc) => bloc.add(
      const SetJobStopCategories(),
    ),
    expect: () => [
      isA<StopJobState>().having((state) => state.getStopCategoriesResponse,
          'added stop categories', isNotNull),
    ],
  );

  blocTest<StopJobBloc, StopJobState>(
    'set job stop',
    build: () => stopJobBloc,
    act: (bloc) => bloc.add(
      const SetJobStop(),
    ),
    expect: () => [
      isA<StopJobState>()
          .having((state) => state.totalStop, 'user total stop', isNotNull),
    ],
  );
}
