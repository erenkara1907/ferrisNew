// ignore_for_file: lines_longer_than_80_chars

import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/utility/constants/color_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utility/size/index.dart';

class ProductTextFieldDecoration extends InputDecoration {
  ProductTextFieldDecoration(BuildContext context, String? hintText)
      : super(
          contentPadding: context.paddingAllLow,
          enabledBorder: focusedBorderStyle(context),
          focusedBorder: focusedBorderStyle(context),
          border: standardBorder(context),
          hintText: hintText,
          hintStyle: context.textTheme.bodySmall
              ?.copyWith(color: ColorConstants.deepBlueColor.withOpacity(0.3)),
        );

  static OutlineInputBorder focusedBorderStyle(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: ColorConstants.deepBlueColor,
      ),
    );
  }

  static OutlineInputBorder standardBorder(BuildContext context) =>
      OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: ColorConstants.deepBlueColor,
          width: context.dynamicWidth(0.1),
        ),
      );

  static BorderRadius get borderRadius => const BorderRadius.all(
        Radius.circular(kIsWeb ? WidgetSizes.spacingS : WidgetSizes.spacingM),
      );
}
