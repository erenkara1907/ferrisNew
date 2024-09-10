import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/theme/theme_notifer.dart';
import 'package:ferrisfwt/product/utility/enums/app_theme_enum.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ApperancePage extends StatefulWidget {
  const ApperancePage({super.key});

  @override
  State<ApperancePage> createState() => _ApperancePageState();
}

class _ApperancePageState extends State<ApperancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
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
              "Appearance",
              style: context.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const VerticalSpace.small(),
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: context.paddingAllDefault,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Light/dark mode",
                              style: context.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Switch between light and dark mode",
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
  late bool _switchValue;

  @override
  void initState() {
    super.initState();
    _switchValue =
        context.read<ThemeNotifier>().currentThemeEnum == AppThemes.LIGHT
            ? false
            : true;
  }

  void changeAppTheme() {
    context
        .read<ThemeNotifier>()
        .changeValue(_switchValue ? AppThemes.LIGHT : AppThemes.DARK);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _switchValue,
      onChanged: (value) {
        changeAppTheme();
        setState(() {
          _switchValue = value;
        });
      },
      activeColor: context.theme.colorScheme.primaryContainer,
      trackColor: context.theme.colorScheme.outline,
    );
  }
}
