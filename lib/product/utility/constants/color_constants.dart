import 'package:ferrisfwt/product/theme/custom_color_scheme.dart';
import 'package:flutter/material.dart';

@immutable
class ColorConstants {
  const ColorConstants._();
  static Color greyBackgroundColor =
      CustomColorScheme.lightColorScheme.background;
  static Color orangeColor = CustomColorScheme.lightColorScheme.primary;
  static Color deepBlueColor = CustomColorScheme.lightColorScheme.secondary;
  static Color textColor = CustomColorScheme.lightColorScheme.primary;
  static Color textColor2 = CustomColorScheme.lightColorScheme.surface;
}
