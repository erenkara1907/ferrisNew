import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  final Function()? ontap;
  final String text;
  final bool enabled;
  final bool isCustomColor;

  const CustomAppButton({
    Key? key,
    required this.text,
    required this.ontap,
    this.enabled = true,
    this.isCustomColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? ontap : null,
      child: Container(
        decoration: BoxDecoration(
          color: enabled
              ? isCustomColor
                  ? context.theme.colorScheme.error
                  : context.theme.colorScheme.primaryContainer
              : context.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        width: context.dynamicWidth(0.95),
        height: context.dynamicHeight(0.07),
        child: Center(
          child: Text(
            text,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
