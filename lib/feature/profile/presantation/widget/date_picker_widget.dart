import 'package:ferrisfwt/feature/profile/presantation/widget/custom_popup.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class DatePickerBottomSheet extends StatefulWidget {
  const DatePickerBottomSheet({Key? key}) : super(key: key);

  @override
  _DatePickerBottomSheetState createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.7),
      color: context.theme.colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: context.paddingAllDefault,
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              minimumDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
          ),
          const VerticalSpace.small(),
          CustomAppButton(
              text: "Confirm",
              ontap: () {
                showDialog(
                    context: context,
                    builder: (context) => CustomPopupDialog(
                          popupText:
                              "Are you sure you want to update your date of birth?",
                          confirmText: "OK",
                          cancelText: "Cancel",
                          onConfirm: (context) {
                            context.go('/personal_data_page');
                            showTopSnackBar(context,
                                message: "Your date of birth has been updated",
                                duration: const Duration(seconds: 3));
                          },
                        ));
              }),
          const VerticalSpace.small(),
          Padding(
            padding: context.paddingAllDefault,
            child: CustomGreyAppButton(
              text: "Cancel",
              ontap: () {
                context.pop();
              },
              textColor: context.theme.colorScheme.onBackground,
              containerColor: context.theme.colorScheme.surface,
            ),
          ),
          const VerticalSpace.small()
        ],
      ),
    );
  }
}
