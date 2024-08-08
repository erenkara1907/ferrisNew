import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_timeout/auth_timeout_bloc.dart';
import 'package:ferrisfwt/feature/auth/presentation/view/login_page.dart';
import 'package:ferrisfwt/feature/auth/presentation/widget/verification_code_pinput_widget.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerificationChangeCodePage extends StatefulWidget {
  const VerificationChangeCodePage({super.key});

  @override
  State<VerificationChangeCodePage> createState() =>
      _VerificationChangeCodePageState();
}

class _VerificationChangeCodePageState
    extends State<VerificationChangeCodePage> {
  final TextEditingController pinPutFieldController = TextEditingController();

  Future<void> verificationsComplete(BuildContext context) async {
    context.read<AuthBloc>().add(const GetUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProductStateItems.authTimeoutBloc
          ..add(const StartCountdownTimerEvent()),
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (p, c) =>
                  p.status != c.status && c.isVerificationCompleted == true,
              listener: (context, state) async {
                if (state.status == ViewStatus.loading) {
                  KafileLoadingIndicator.of(context).show();
                }
                if (state.status != ViewStatus.loading) {
                  KafileLoadingIndicator.of(context).hide();
                }
                if (state.isVerificationCompleted) {
                  if (ProductStateItems.hiveDatabaseManager
                              .getUserModel()
                              ?.token !=
                          null &&
                      ProductStateItems.hiveDatabaseManager
                              .getUserModel()
                              ?.token !=
                          '') {
                    context.go("/home_page");
                  }
                }
              },
            ),
            BlocListener<AuthTimeoutBloc, AuthTimeoutState>(
              listenWhen: (p, c) =>
                  p.isVerificationHasTimeOut != c.isVerificationHasTimeOut,
              listener: (context, state) {
                if (state.isVerificationHasTimeOut &&
                    !context.read<AuthBloc>().state.isVerificationCompleted) {
                  BotToast.showText(text: 'Time Out');
                  context
                      .read<AuthTimeoutBloc>()
                      .add(const ResetAuthTimeoutStateEvent());

                  context.read<AuthBloc>().add(const ResetStateEvent());

                  context.push("/login_page");
                }
              },
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: context.theme.colorScheme.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<AuthBloc>().add(const ResetStateEvent());
                  context
                      .read<AuthTimeoutBloc>()
                      .add(const ResetAuthTimeoutStateEvent());
                },
              ),
            ),
            body: BlocBuilder<AuthTimeoutBloc, AuthTimeoutState>(
              builder: (context, state) {
                final remainingTime =
                    "${state.remainingTimeForTimeOut ~/ 60}:${(state.remainingTimeForTimeOut % 60).toString().padLeft(2, '0')}";
                return SingleChildScrollView(
                  child: Padding(
                    padding: context.paddingAllDefault,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VerticalSpace.medium(),
                        const VerificationCodeHeader(),
                        const VerticalSpace.medium(),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpace.xxSmall(),
                          ],
                        ),
                        const Center(
                          child: VerificationCodeWidget(),
                        ),
                        const VerticalSpace.large(),
                        const VerticalSpace.large(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                context
                                    .read<AuthTimeoutBloc>()
                                    .add(const StartCountdownTimerEvent());

                                context
                                    .read<AuthBloc>()
                                    .add(const ResetVerificationEvent());

                                context.read<AuthBloc>().add(LoginEvent(
                                      email: context
                                              .read<AuthBloc>()
                                              .state
                                              .email ??
                                          '',
                                      password: context
                                              .read<AuthBloc>()
                                              .state
                                              .password ??
                                          '',
                                    ));

                                pinPutFieldController.clear();
                              },
                              child: Text(
                                'Send code again',
                                style: context.textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              remainingTime,
                              style: context.textTheme.bodyLarge,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}

class VerificationCodeHeader extends StatelessWidget {
  const VerificationCodeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Code',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const VerticalSpace.small(),
        Text(
          'We have sent a SMS with an activation code to your phone number ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
