import 'package:ferrisfwt/feature/profile/presantation/widget/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ferrisfwt/feature/profile/presantation/subView/personal_data_get_otp.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';

class ChangePersonalPhoneNumber extends StatefulWidget {
  const ChangePersonalPhoneNumber({Key? key}) : super(key: key);

  @override
  State<ChangePersonalPhoneNumber> createState() =>
      _ChangePersonalPhoneNumberState();
}

class _ChangePersonalPhoneNumberState extends State<ChangePersonalPhoneNumber> {
  final phoneNumberController = TextEditingController();
  final _focusNode = FocusNode();
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.cancel),
        ),
      ),
      body: Padding(
        padding: context.paddingAllDefault,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change your phone number",
                  style: context.textTheme.headlineMedium,
                ),
                const VerticalSpace.small(),
                Text(
                  "You'll receive a certification code on this number.",
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
            const VerticalSpace.small(),
            IntlPhoneField(
              textInputAction: TextInputAction.next,
              showCountryFlag: false,
              showDropdownIcon: false,
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.outline,
                  ),
                ),
              ),
              controller: phoneNumberController,
              languageCode: "en",
              onChanged: (phone) {
                setState(() {});
              },
              onCountryChanged: (country) {},
            ),
            const VerticalSpace.small(),
            CustomAppButton(
              text: "Confirm",
              enabled: phoneNumberController.text.length == 10,
              ontap: () {
                setState(() {});
                showDialog(
                  context: context,
                  builder: (context) => CustomPopupDialog(
                    popupText: "Are you sure you want to change your name?",
                    confirmText: "OK",
                    cancelText: "Cancel",
                    onConfirm: (context) {
                      showModalBottomSheet(
                        scrollControlDisabledMaxHeightRatio: 0.9,
                        context: context,
                        builder: (BuildContext context) {
                          return const VerificationChangeCodePage();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
