import 'package:ferrisfwt/feature/profile/presantation/widget/custom_popup.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:ferrisfwt/product/widget/textfield/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.cancel),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your name",
                style: context.textTheme.headlineMedium,
              ),
              VerticalSpace.small(),
              Text(
                "Your name which will indicate you in the system.",
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
          VerticalSpace.small(),
          CustomTextfield(
            controller: _usernameController,
            hintText: "Enter new name",
            onChanged: (value) {
              setState(() {});
            },
            text: '',
          ),
          Padding(
            padding: context.paddingAllDefault,
            child: CustomAppButton(
              text: "Confirm",
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomPopupDialog(
                    popupText: "Are you sure you want to change your name?",
                    confirmText: "OK",
                    cancelText: "Cancel",
                    onConfirm: (context) {
                      context.go('/personal_data_page');
                      showTopSnackBar(context,
                          message: "Your name has been updated",
                          duration: const Duration(seconds: 2));
                    },
                  ),
                );
              },
              enabled: _usernameController.text.length >=
                  2, // Butonun etkinliği kontrol ediliyor
            ),
          )
        ],
      ),
    );
  }
}
