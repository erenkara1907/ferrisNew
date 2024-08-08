import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_timeout/auth_timeout_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_damage/job_damage_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
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
import 'package:ferrisfwt/product/state/container/product_state_container.dart';

final class ProductStateItems {
  const ProductStateItems._();

  //static ProductCache get productCache => ProductContainer.read<ProductCache>();

  static AppRouter get appRouter => Locator.read<AppRouter>();

  static HomeBloc get homeBloc => Locator.read<HomeBloc>();

  static AuthTimeoutBloc get authTimeoutBloc => Locator.read<AuthTimeoutBloc>();

  static NetworkClient get networkClient => Locator.read<NetworkClient>();

  static Connectivity get connectivity => Locator.read<Connectivity>();

  static LandingBloc get landingBloc => Locator.read<LandingBloc>();

  static CubitPermissions get permissionsCubit =>
      Locator.read<CubitPermissions>();

  static AuthBloc get authBloc => Locator.read<AuthBloc>();

  static StopJobBloc get jobStopBloc => Locator.read<StopJobBloc>();

  static JobExpenseBloc get jobExpenseBloc => Locator.read<JobExpenseBloc>();

  static JobDamageBloc get jobDamageBloc => Locator.read<JobDamageBloc>();

  static InspectionsBloc get inspectionsBloc => Locator.read<InspectionsBloc>();

  static AnalyticsService get analyticsService =>
      Locator.read<AnalyticsService>();

  static BottomNavContext get bottomNavBuilder =>
      Locator.read<BottomNavContext>();

  static NetworkListener get networkFailures => Locator.read<NetworkListener>();

  static HiveDatabaseManager get hiveDatabaseManager =>
      Locator.read<HiveDatabaseManager>();

  static HiveStorageManager get hiveStorageManager =>
      Locator.read<HiveStorageManager>();
}
