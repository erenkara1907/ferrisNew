import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:ferrisfwt/product/widget/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';

class PersonalChangeEmail extends StatefulWidget {
  const PersonalChangeEmail({super.key});

  @override
  State<PersonalChangeEmail> createState() => _PersonalChangeEmailState();
}

class _PersonalChangeEmailState extends State<PersonalChangeEmail> {
  bool _isEmailValid = false;

  bool _isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.cancel)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: context.paddingAllDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your email",
                  style: context.textTheme.headlineMedium,
                ),
                VerticalSpace.small(),
                Text(
                  "Your email to receive notification and updates about jobs.",
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          VerticalSpace.small(),
          CustomTextfield(
            text: "Email",
            hintText: "Enter new email",
            onChanged: (value) {
              setState(() {
                _isEmailValid = _isValidEmail(value);
              });
            },
          ),
          Padding(
              padding: context.paddingAllDefault,
              child: CustomAppButton(
                  enabled: _isEmailValid,
                  text: "Confirm",
                  ontap: () {
                    Navigator.pop(context);
                  }))
        ],
      ),
    );
  }
}
