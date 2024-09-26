import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeWidget extends StatefulWidget {
  const VerificationCodeWidget({Key? key}) : super(key: key);

  @override
  State<VerificationCodeWidget> createState() => _VerificationCodeWidgetState();
}

class _VerificationCodeWidgetState extends State<VerificationCodeWidget> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isPinCorrect = false;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color? focusedBorderColor = context.theme.colorScheme.outline;
    Color? fillColor = context.theme.colorScheme.onSurfaceVariant;
    Color? borderColor = context.theme.colorScheme.primary.withOpacity(0.3);

    final defaultPinTheme = PinTheme(
      width: 59.26,
      height: 52,
      textStyle: context.textTheme.headlineMedium?.copyWith(
        color: context.theme.colorScheme.primary,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              length: 6,
              separatorBuilder: (index) => SizedBox(width: context.dynamicWidth(0.05)),
              onTapOutside: (event) {
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {},
              onChanged: (value) {
                context.read<AuthBloc>().add(ChangeOtpEvent(otp: value));
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          const VerticalSpace.medium(),
          CustomAppButton(
              text: "Verify",
              enabled: context.watch<AuthBloc>().state.otpCode.length == 6,
              ontap: () {
                print("girdi verify");
                context.read<AuthBloc>().add(const VerifyOtpEvent());
              }),
        ],
      ),
    );
  }
}
