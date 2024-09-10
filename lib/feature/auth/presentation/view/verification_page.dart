import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.onSurfaceVariant,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace.medium(),
              const VerificationHeader(),
              const VerticalSpace.medium(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const VerticalSpace.xxSmall(),
                  PhoneNumberTextfield(focusNode: focusNode),
                ],
              ),
              const VerticalSpace.medium(),
              CustomAppButton(
                text: 'Continue',
                ontap: () {
                  context.go('/verification_code_page');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberTextfield extends StatelessWidget {
  const PhoneNumberTextfield({
    super.key,
    required this.focusNode,
  });

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      focusNode: focusNode,
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
      initialCountryCode: 'TR',
      languageCode: "en",
      onChanged: (phone) {},
      onCountryChanged: (country) {},
    );
  }
}

class VerificationHeader extends StatelessWidget {
  const VerificationHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const VerticalSpace.xxSmall(),
        Text(
          'Please confirm your phone number',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
