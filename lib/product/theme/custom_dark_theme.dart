import 'package:ferrisfwt/product/theme/custom_color_scheme.dart';
import 'package:ferrisfwt/product/theme/custom_theme.dart';
import 'package:ferrisfwt/product/utility/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class CustomDarkTheme implements CustomTheme {
  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: CustomColorScheme.darkColorScheme,
        floatingActionButtonTheme: floatingActionButtonThemeData,
        textTheme: textTheme,
      );

  @override
  final FloatingActionButtonThemeData floatingActionButtonThemeData =
      const FloatingActionButtonThemeData();

  @override
  TextTheme get textTheme => TextTheme(
        headlineLarge: GoogleFonts.inter(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.inter(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.inter(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: ColorConstants.textColor2,
          wordSpacing: 2,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: GoogleFonts.inter(
          color: ColorConstants.textColor2,
          fontSize: 16,
          wordSpacing: 2,
          fontWeight: FontWeight.w400,
        ),
      );
}
