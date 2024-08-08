import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/feature/auth/presentation/mixin/login_mixin.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/mixin/base_mixin.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:ferrisfwt/product/widget/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseMixin<LoginPage> with LoginMixin {
  late TextEditingController _passwordController;
  late TextEditingController _namecontroller;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _namecontroller = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ViewStatus.loading) {
          KafileLoadingIndicator.of(context).show();
        } else if (state.status != ViewStatus.loading) {
          _passwordController.clear();
          KafileLoadingIndicator.of(context).hide();
        }
        if (state.isCodeSent) {
          context.pushReplacement('/verification_code_page');
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: context.theme.colorScheme.background,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: context.dynamicHeight(0.05),
                  ),
                  const SignInPageHeader(),
                  CustomTextfield(
                    text: 'Email',
                    hintText: "Your email",
                    controller: _namecontroller,
                  ),
                  const VerticalSpace.small(),
                  CustomTextfield(
                    controller: _passwordController,
                    hintText: "Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: context.theme.colorScheme.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    text: 'Password',
                  ),
                  const SignInPageRememberAndPassword(),
                  const VerticalSpace.small(),
                  CustomAppButton(
                      text: "Continue",
                      ontap: () {
                        context.read<AuthBloc>().add(LoginEvent(
                            email: _namecontroller.text,
                            password: _passwordController.text));
                      })
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}

class SignInPageHeader extends StatelessWidget {
  const SignInPageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: context.paddingAllDefault,
          child: Text(
            "Hi, Welcome !",
            style: context.textTheme.headlineLarge,
          ),
        ),
      ],
    );
  }
}

class SignInPageRememberAndPassword extends StatefulWidget {
  const SignInPageRememberAndPassword({
    super.key,
  });

  @override
  State<SignInPageRememberAndPassword> createState() =>
      _SignInPageRememberAndPasswordState();
}

class _SignInPageRememberAndPasswordState
    extends State<SignInPageRememberAndPassword> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
            activeColor: context.theme.colorScheme.primaryContainer,
            value: isChecked,
            checkColor: context.theme.colorScheme.onSecondary,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
              context
                  .read<AuthBloc>()
                  .add(SetIsSaveLocal(isSaveLocal: isChecked));
            }),
        Text(
          "Remember me",
          style: context.textTheme.bodyMedium,
        ),
        SizedBox(width: context.dynamicWidth(0.15)),
      ],
    );
  }
}

class KafileLoadingIndicator {
  factory KafileLoadingIndicator.of(BuildContext context) {
    return KafileLoadingIndicator._create(context);
  }
  KafileLoadingIndicator._create(this.context);

  final BuildContext context;

  void show() {
    showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (context) => const LoadingIndicatorWithLessOpacity(),
    );
  }

  void hide() {
    context.pop();
  }
}

class LoadingIndicatorWithLessOpacity extends StatelessWidget {
  const LoadingIndicatorWithLessOpacity({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
      child: Center(
        child: LoadingProgress(),
      ),
    );
  }
}
