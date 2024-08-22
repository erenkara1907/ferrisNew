import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ferrisfwt/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:ferrisfwt/feature/auth/domain/repositories/auth_repository.dart';
import 'package:ferrisfwt/feature/auth/domain/usecases/uc_get_auth.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_timeout/auth_timeout_bloc.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_damage_datasource.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_expense_datasource.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_remote_datasource.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_stop_datasource.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_tracking_coordinates_datasource.dart';
import 'package:ferrisfwt/feature/home/data/repositories/job_damage_repository_impl.dart';
import 'package:ferrisfwt/feature/home/data/repositories/job_expense_repository_impl.dart';
import 'package:ferrisfwt/feature/home/data/repositories/job_repository_impl.dart';
import 'package:ferrisfwt/feature/home/data/repositories/job_stop_repository_impl.dart';
import 'package:ferrisfwt/feature/home/data/repositories/job_tracking_coordinates_repository_impl.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_damage_repository.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_expense_repository.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_repository.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_stop_repository.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_tracking_coordinates_repository.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_damage.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_expense.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_stop.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_tracking_coordinates.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_damage/job_damage_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_checklist_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_condition_images_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_damages_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_sign_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/job_inspections_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/repositories/inspection_checklist_repository_impl.dart';
import 'package:ferrisfwt/feature/inspections/data/repositories/inspection_condition_images_repository_impl.dart';
import 'package:ferrisfwt/feature/inspections/data/repositories/inspection_damages_repository_impl.dart';
import 'package:ferrisfwt/feature/inspections/data/repositories/inspection_sign_repository_impl.dart';
import 'package:ferrisfwt/feature/inspections/data/repositories/job_inspections_repository_impl.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_checklist_repository.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_condition_images_repository.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_damages_repository.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_sign_repository.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/job_inspections_repository.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_checklist.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_condition_images.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_damages.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_sign.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_job_inspections.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/landing/presentation/bloc/landing_bloc.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/connectivity/manager/network_manager.dart';
import 'package:ferrisfwt/product/context/bottom_nav_context.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/firebase/service/analytics_service.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/router/app_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';

/// Product container for dependency injection

abstract final class Locator {
  /// [GetIt] instance
  static final _instance = GetIt.instance;

  /// Responsible for registering all the dependencies
  static Future<void> locateServices({required String baseUrl}) async {
    _instance.registerLazySingleton<FirebaseAnalytics>(
        () => FirebaseAnalytics.instance);

    _instance
      ..registerFactory(() => HomeBloc(
          ucGetJob: _instance(), ucGetJobTrackingCoordinates: _instance()))
      ..registerFactory(() => LandingBloc())
      ..registerFactory(() => AuthTimeoutBloc())
      ..registerFactory(() => AuthBloc(ucGetAuth: _instance()))
      ..registerFactory(() => StopJobBloc(ucGetJobStop: _instance()))
      ..registerFactory(() => JobExpenseBloc(ucGetJobExpense: _instance()))
      ..registerFactory(() => JobDamageBloc(ucGetJobDamage: _instance()))
      // ucGetJobDamage: _instance(), ucGetInspectionsDamage: _instance()))
      ..registerFactory(() => CubitPermissions())
      ..registerFactory(() => InspectionsBloc(
          ucGetJobInspections: _instance(),
          ucGetJobInspectionsSign: _instance(),
          ucGetJobInspectionsDamages: _instance(),
          ucGetJobInspectionsCheckList: _instance(),
          ucGetJobInspectionsConditionImages: _instance()))

      // Managers
      ..registerFactory(NetworkListener.new)
      ..registerFactory(() => UCGetAuth(repository: _instance()))
      ..registerFactory(() => UCGetJob(repository: _instance()))
      ..registerFactory(() => UCGetJobDamage(repository: _instance()))
      ..registerFactory(() => UCGetJobExpense(repository: _instance()))
      ..registerFactory(() => UCGetJobStop(repository: _instance()))
      ..registerFactory(
          () => UCGetJobTrackingCoordinates(repository: _instance()))
      ..registerFactory(() => UCGetJobInspections(repository: _instance()))
      ..registerFactory(() => UCGetJobInspectionsSign(repository: _instance()))
      ..registerFactory(
          () => UCGetJobInspectionsDamages(repository: _instance()))
      ..registerFactory(
          () => UCGetJobInspectionsCheckList(repository: _instance()))
      ..registerFactory(
          () => UCGetJobInspectionsConditionImages(repository: _instance()))

      // Repositories
      ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobRepository>(
        () => JobRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobExpenseRepository>(
        () => JobExpenseRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobDamageRepository>(
        () => JobDamageRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobStopRepository>(
        () => JobStopRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobTrackingCoordinatesRepository>(
        () => JobTrackingCoordinatesRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobInspectionsRepository>(
        () => JobInspectionsRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobInspectionsSignRepository>(
        () => JobInspectionsSignRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobInspectionsDamagesRepository>(
        () => JobInspectionsDamagesRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobInspectionsCheckListRepository>(
        () => JobInspectionsCheckListRepositoryImpl(dataSource: _instance()),
      )
      ..registerFactory<JobInspectionsConditionImagesRepository>(
        () => JobInspectionsConditionImagesRepositoryImpl(
            dataSource: _instance()),
      )

      // RemoteDataSources
      ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(networkClient: _instance()),
      )
      ..registerFactory<JobRemoteDataSource>(
        () => JobRemoteDataSourceImpl(networkClient: _instance()),
      )
      ..registerFactory<JobExpenseRemoteDataSource>(
        () => JobExpenseRemoteDataSourceImpl(networkClient: _instance()),
      )
      ..registerFactory<JobDamageRemoteDataSource>(
        () => JobDamageRemoteDataSourceImpl(networkClient: _instance()),
      )
      ..registerFactory<JobStopRemoteDataSource>(
        () => JobStopRemoteDataSourceImpl(networkClient: _instance()),
      )
      ..registerFactory<JobTrackingCoordinatesRemoteDataSource>(
        () => JobTrackingCoordinatesRemoteDataSourceImpl(
            networkClient: _instance()),
      )
      ..registerFactory<JobInspectionsRemoteDataSource>(
        () => JobInspectionsRemoteDataSourceImpl(networkClient: _instance()),
      )
      ..registerFactory<JobInspectionsSignRemoteDataSource>(
        () =>
            JobInspectionsSignRemoteDataSourceImpl(networkClient: _instance()),
      )
      ..registerFactory<JobInspectionsDamagesRemoteDataSource>(
        () => JobInspectionsDamagesRemoteDataSourceImpl(
            networkClient: _instance()),
      )
      ..registerFactory<JobInspectionsCheckListRemoteDataSource>(
        () => JobInspectionsCheckListRemoteDataSourceImpl(
            networkClient: _instance()),
      )
      ..registerFactory<JobInspectionsConditionImagesRemoteDataSource>(
        () => JobInspectionsConditionImagesRemoteDataSourceImpl(
            networkClient: _instance()),
      )

      // Clients

      ..registerFactory(() => AnalyticsService(_instance<FirebaseAnalytics>()))
      ..registerLazySingleton(() => AppRouter())
      ..registerLazySingleton(() => HiveDatabaseManager())
      ..registerLazySingleton(() => HiveStorageManager())
      ..registerLazySingleton(
          () => NetworkClient(dio: _instance(), baseUrl: baseUrl))

      // Client Dependencies
      ..registerFactory(Dio.new)
      ..registerFactory(Connectivity.new)
      ..registerFactory(BottomNavContext.new);

    // Initialize Clients
  }

  static T read<T extends Object>() => _instance<T>();
}
