import 'package:bears_video/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    surface: AppColors.bg,
    primary: AppColors.textPrimary,
    secondary: AppColors.accent,
    onPrimary: Colors.black,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    splashFactory: InkSplash.splashFactory,
  );
}
