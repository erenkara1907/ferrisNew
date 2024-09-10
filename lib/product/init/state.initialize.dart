import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_damage/job_damage_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/landing/presentation/bloc/landing_bloc.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/theme/theme_notifer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../feature/auth/presentation/bloc/auth_timeout/auth_timeout_bloc.dart';

final class StateInitialize extends StatelessWidget {
  const StateInitialize({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => ProductStateItems.homeBloc),
        BlocProvider<LandingBloc>(
            create: (context) => ProductStateItems.landingBloc),
        BlocProvider<AuthBloc>(create: (context) => ProductStateItems.authBloc),
        BlocProvider<AuthTimeoutBloc>(
            create: (context) => ProductStateItems.authTimeoutBloc),
        BlocProvider<JobDamageBloc>(
            create: (context) => ProductStateItems.jobDamageBloc),
        BlocProvider<StopJobBloc>(
            create: (context) => ProductStateItems.jobStopBloc),
        BlocProvider<JobExpenseBloc>(
            create: (context) => ProductStateItems.jobExpenseBloc),
        BlocProvider<CubitPermissions>(
            create: (context) => ProductStateItems.permissionsCubit),
        BlocProvider<InspectionsBloc>(
            create: (context) => ProductStateItems.inspectionsBloc),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeNotifier(),
        child: child,
      ),
    );
  }
}
