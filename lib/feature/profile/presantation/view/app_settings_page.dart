import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ferrisfwt/feature/profile/presantation/view/personal_data_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.surfaceVariant,
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
      body: Padding(
        padding: context.paddingAllDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "App Settings",
              style: context.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const VerticalSpace.small(),
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      context.push("/auto_dark_mode_page");
                    },
                    child: Padding(
                      padding: context.paddingAllDefault,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Auto dark mode",
                                style: context.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Dark mode switches automatically",
                                style: context.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: context.theme.colorScheme.surfaceTint,
                          )
                        ],
                      ),
                    ),
                  ),
                  const ProfileCustomDivider(),
                  Padding(
                    padding: context.paddingAllDefault,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Auto dark mode",
                              style: context.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Dark mode switches automatically",
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SwitchButton()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: CupertinoSwitch(
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
          activeColor: context.theme.colorScheme.primaryContainer,
          trackColor: context.theme.colorScheme.outline),
    );
  }
}
