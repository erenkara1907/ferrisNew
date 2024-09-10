import 'package:ferrisfwt/product/theme/custom_color_scheme.dart';
import 'package:ferrisfwt/product/theme/custom_theme.dart';
import 'package:ferrisfwt/product/utility/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class CustomLightTheme implements CustomTheme {
  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.lexend().fontFamily,
        colorScheme: CustomColorScheme.lightColorScheme,
        floatingActionButtonTheme: floatingActionButtonThemeData,
        textTheme: textTheme,
        checkboxTheme: const CheckboxThemeData(
          side: BorderSide(color: Color(0xFFA5A5A5)),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStateProperty.all(
              const Color(0xFF000000),
            ),
          ),
        ),
      );

  @override
  FloatingActionButtonThemeData get floatingActionButtonThemeData =>
      const FloatingActionButtonThemeData();

  @override
  TextTheme get textTheme => TextTheme(
        headlineLarge: GoogleFonts.inter(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.inter(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.inter(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: ColorConstants.textColor,
          wordSpacing: 2,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: GoogleFonts.inter(
          color: ColorConstants.textColor,
          fontSize: 16,
          wordSpacing: 2,
          fontWeight: FontWeight.w400,
        ),
      );
}
