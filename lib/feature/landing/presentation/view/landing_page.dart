import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/landing/presentation/bloc/landing_bloc.dart';
import 'package:ferrisfwt/feature/landing/presentation/mixin/landing_mixin.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/firebase/notification/firebaseMessaging/firebase_messaging_service.dart';
import 'package:ferrisfwt/product/state/base/mixin/base_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/constants/string_constants.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends BaseMixin<LandingPage> with WidgetsBindingObserver, LandingMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FCMManager().setupInteractedMessage(context: context);
    context.read<LandingBloc>().add(CheckConnection());
    userHiveOperation = ProductStateItems.hiveDatabaseManager;
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _updateLastActiveTime();
    }
  }

  void _updateLastActiveTime() async {
    if (ProductStateItems.hiveDatabaseManager.getUserModel() != null) {
      await ProductStateItems.hiveDatabaseManager.updateLastUse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LandingBloc, LandingState>(
          listenWhen: (previous, current) => current.status == ViewStatus.success,
          listener: (contextA, state) async {
            if (state.status == ViewStatus.success && state.networkResult == true) {
              await checkUserLogin(context);
            } else if (state.status != ViewStatus.loading && state.networkResult == false) {
              checkJobModule();
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => previous.status == current.status && current.status == ViewStatus.success,
          listener: (context, state) {
            context.go("/home_page");
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.primaryContainer,
        body: const _LandingLoadingBar(),
      ),
    );
  }
}

class _LandingLoadingBar extends StatelessWidget {
  const _LandingLoadingBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            StringConstants.logoImage,
            width: context.dynamicWidth(0.5),
            height: context.dynamicHeight(0.5),
          ),
        ),
      ],
    );
  }
}
