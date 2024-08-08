import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:ferrisfwt/product/widget/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.colorScheme.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const VerticalSpace.small(),
              const ForgotPasswordHeader(),
              const VerticalSpace.small(),
              CustomTextfield(text: 'Email', hintText: "Your email"),
              const VerticalSpace.medium(),
              CustomAppButton(
                  text: "Continue",
                  ontap: () {
                    context.go('/home_page');
                  })
            ],
          ),
        ));
  }
}

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingAllDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Forgot password",
            style: context.textTheme.headlineLarge,
          ),
          const VerticalSpace.small(),
          Text(
            "Don't worry! It happens. Please enter the email associated with your account.",
            style: context.textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}
