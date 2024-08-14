// ignore_for_file: use_key_in_widget_constructors

import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CustomGreyAppButton extends StatelessWidget {
  final Function()? ontap;

  final String text;

  final Color? containerColor;

  final Color? textColor;

  final double? width;

  const CustomGreyAppButton({
    Key? key,
    this.width,
    required this.textColor,
    required this.text,
    required this.containerColor,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.theme.colorScheme.outline,
            width: 1,
          ),
          color: containerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        width: width,
        height: context.dynamicHeight(0.07),
        child: Center(
          child: Text(text,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }
}
