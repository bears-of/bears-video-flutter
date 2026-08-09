import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const colorScheme = ColorScheme.light(
    primary: AppColors.primaryDark,
    onPrimary: Colors.white,
    secondary: AppColors.primarySoft,
    onSecondary: AppColors.primaryDark,
    error: AppColors.danger,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    outline: AppColors.outline,
  );

  return ThemeData(
    useMaterial3: false,
    fontFamily: 'MiSans',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: AppColors.primarySoft.withValues(alpha: 0.55),
    focusColor: AppColors.primarySoft,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'MiSans',
        fontSize: 16,
        color: AppColors.ink,
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 28, color: AppColors.ink),
      titleLarge: TextStyle(fontSize: 22, color: AppColors.ink),
      titleMedium: TextStyle(fontSize: 16, color: AppColors.ink),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.ink),
      labelMedium: TextStyle(fontSize: 12, color: AppColors.inkMuted),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.focus, width: 1.5),
      ),
      hintStyle: TextStyle(color: AppColors.inkMuted),
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.field,
        side: BorderSide(color: AppColors.outline),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.bubble),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.outline,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.surfaceMuted,
      circularTrackColor: AppColors.surfaceMuted,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : AppColors.surface,
      ),
      side: const BorderSide(color: AppColors.outline),
    ),
  );
}
