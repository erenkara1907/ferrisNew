import 'package:flutter/material.dart';

/// Project custom colors
final class CustomColorScheme {
  CustomColorScheme._();

  /// Light color scheme set
  static const lightColorScheme = ColorScheme(
    error: Color.fromARGB(255, 241, 69, 60),
    brightness: Brightness.light,
    primary: Color(0xFF212121),
    onPrimary: Color(0xFFA5A5A5),
    primaryContainer: Color(0xFF7401FF),
    onPrimaryContainer: Color(0xFFD8DADC),
    secondary: Color(0xFF010035),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD8DADC),
    onSecondaryContainer: Color(0xFF1D192B),
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFF8F8F8),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410E0B),
    outline: Color(0xFFD8DADC),
    background: Color(0xFFF9F9F9),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFF9F9F9), //profil background
    onSurfaceVariant: Color(0xFF49454F),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFFF0F0F0),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF737373), // unselected item
    outlineVariant: Color(0xFFF7F2FD), // item background
    scrim: Color(0xFF7401FF), // selected item
  );

  /// Light dark scheme set
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFA5A5A5),
    primaryContainer: Color(0xFF7401FF),
    onPrimaryContainer: Color(0xFFEADDFF),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),
    error: Color.fromARGB(255, 241, 69, 60),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    outline: Color(0xFF938F99),
    background: Color(0xFF181A20),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF343434),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF181A20),
    onSurfaceVariant: Color(0xFFCAC4D0),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF737373), //button color
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFFFFF), // unselected item
    outlineVariant: Color(0xFFF7F2FD), // item background
    scrim: Color(0xFF7401FF), // selected item
  );
}
