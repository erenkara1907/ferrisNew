import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/feedback_input_availability.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/hive/database_cache_mock.dart';
import 'mock/hive/storage_cache_mock.dart';
import 'mock/job/job_service_mock.dart';
import 'mock/tracking_coordinates/tracking_coordinates_service_mock.dart';

void main() {
  late HomeBloc homeBloc;

  setUp(() {
    homeBloc = HomeBloc(
      ucGetJob: JobServiceMock(),
      ucGetJobTrackingCoordinates: TrackingCoordinatesServiceMock(),
      hiveDatabaseManager: DatabaseCacheMock(),
      hiveStorageManager: StorageCacheMock(),
    );
  });

  blocTest<HomeBloc, HomeState>(
    'login user',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const FinishJobResetHome()),
    expect: () => [
      isA<HomeState>().having((state) => state.status, 'status', null),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'get jobs',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const GetJobs()),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having((state) => state.jobs, 'jobs', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'get job',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const GetJob("testId")),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having((state) => state.showJob, 'job', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'start job',
    build: () => homeBloc,
    act: (bloc) => bloc.add(StartJob(JobsResponseModelItem(id: 1))),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having((state) => state.isStarted, 'is started', true),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'price job',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const PriceJob(1)),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having(
          (state) => state.status, 'status success', ViewStatus.success),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'end job',
    build: () => homeBloc,
    act: (bloc) => bloc.add(EndJob(
      id: "1",
      data: EndJobPostModel(endDate: 1),
      isFeedBackView: true,
      isViewFuel: true,
      feedbackInputAvailability: FeedbackInputAvailability(
        vehicle: FeedbackInputAvailabilityEnum.optional,
        customer: FeedbackInputAvailabilityEnum.required,
      ),
    )),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having((state) => state.isFinished, 'is finish', true),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'update job',
    build: () => homeBloc,
    act: (bloc) async => bloc
        .add(UpdateJob("1", UpdateJobStatusPostModel(timestamp: "1"), true)),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having((state) => state.isFinished, 'is finish', false),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'get jobs valet',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const GetJobsValet()),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>()
          .having((state) => state.jobsValet, 'jobs valet', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'get job show valet type',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const GetJobShowValetByType(1)),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having(
          (state) => state.jobsValetByType, 'jobs Valet By Type', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'on Get Job Tracing Coordinates',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const GetJobTracingCordinates(1)),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>().having((state) => state.getTrackingCoordinatesResponse,
          'get Tracking Coordinates Response', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'get Job Tomorrow',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const GetJobTomorrow()),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>()
          .having((state) => state.jobsTomorrow, 'jobs tomorrow', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'get Job History',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const GetJobHistory()),
    expect: () => [
      isA<HomeState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<HomeState>()
          .having((state) => state.jobsHistory, 'jobs history', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'clear job',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const ClearJob()),
    expect: () => [
      isA<HomeState>().having((state) => state.showJob, 'show job', null),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'set Valet Job',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const SetValetJob()),
    expect: () => [
      isA<HomeState>()
          .having((state) => state.jobsValet, 'jobs valet', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'set tracking coordinate',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const SetTrackingCoordinate()),
    expect: () => [
      isA<HomeState>().having((state) => state.selectedTrackingCoordinate,
          'selected tracking coordinate', isNotNull),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'Set Expense Count',
    build: () => homeBloc,
    act: (bloc) async => bloc.add(const SetExpenseCount("10")),
    expect: () => [
      isA<HomeState>()
          .having((state) => state.totalExpense, 'total expense', isNotNull),
    ],
  );
}
