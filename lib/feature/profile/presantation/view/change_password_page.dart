import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/textfield/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureRepeatNewPassword = true;
  bool _obscureRepeatPassword = true;
  bool _buttonEnabled = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswords() {
    setState(() {
      _buttonEnabled =
          _passwordController.text == _repeatPasswordController.text &&
              _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == ViewStatus.success) {
          showTopSnackBarFr(context, message: 'Password changed successfully');
        }
        if (state.status == ViewStatus.failure) {
          BotToast.showText(text: state.failure.toString());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.background,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                size: context.dynamicWidth(0.045),
                Icons.arrow_back_ios,
                color: context.theme.colorScheme.primary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create New Password",
                    style: context.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  CustomTextfield(
                    controller: _oldPasswordController,
                    hintText: "Old Password",
                    obscureText: _obscureRepeatPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureRepeatPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: context.theme.colorScheme.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureRepeatPassword = !_obscureRepeatPassword;
                        });
                      },
                    ),
                    validator: _validatePassword,
                    text: '',
                  ),
                  CustomTextfield(
                    controller: _passwordController,
                    hintText: "New Password",
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
                    validator: _validatePassword,
                    text: '',
                    onChanged: (value) {
                      _checkPasswords();
                    },
                  ),
                  CustomTextfield(
                    controller: _repeatPasswordController,
                    hintText: "Repeat New Password",
                    obscureText: _obscureRepeatNewPassword,
                    validator: _validateRepeatPassword,
                    text: '',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureRepeatNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: context.theme.colorScheme.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureRepeatNewPassword =
                              !_obscureRepeatNewPassword;
                        });
                      },
                    ),
                    onChanged: (value) {
                      _checkPasswords();
                    },
                  ),
                  const VerticalSpace.medium(),
                  Padding(
                    padding: context.paddingAllDefault,
                    child: CustomAppButton(
                      enabled: _buttonEnabled,
                      text: "Confirm",
                      ontap: () {
                        if (_passwordController.text.isEmpty ||
                            _repeatPasswordController.text.isEmpty ||
                            _oldPasswordController.text.isEmpty) {
                          BotToast.showText(text: 'Please fill in all fields.');
                          return;
                        }

                        if (_passwordController.text !=
                            _repeatPasswordController.text) {
                          BotToast.showText(text: 'Passwords do not match.');
                          return;
                        }
                        showDialog(
                            context: context,
                            builder: (context) => QuestionPopup(
                                actionButtonText: 'Confirm',
                                title: 'Change Password',
                                description:
                                    'Are you sure you want to change your password?',
                                actionButtonOnPressed: () {
                                  context.read<AuthBloc>().add(
                                      ChangePasswordEvent(
                                          oldPassword:
                                              _oldPasswordController.text,
                                          newPassword:
                                              _passwordController.text));
                                  Navigator.pop(context); // Dismiss the dialog
                                },
                                iconPath:
                                    'assets/images/fr_change_password.png'));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _validatePassword(dynamic value) {
    String? password = value as String?;
    const int minLength = 6;

    if (password == null || password.isEmpty) {
      return 'Please enter a password.';
    } else if (password.length < minLength) {
      return 'Password must be at least $minLength characters long.';
    }

    return null;
  }

  String? _validateRepeatPassword(dynamic value) {
    String? repeatPassword = value as String?;
    final password = _passwordController.text;

    if (repeatPassword == null || repeatPassword.isEmpty) {
      return 'Please re-enter the password.';
    } else if (repeatPassword != password) {
      return 'Passwords do not match.';
    }

    return null;
  }
}
