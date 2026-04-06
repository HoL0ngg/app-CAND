import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
// Figma Core Colors
// ──────────────────────────────────────────────
class AppColors {
  AppColors._(); // Prevent instantiation

  /// Primary brand green – dùng cho AppBar, nút chính, v.v.
  static const Color primary       = Color(0xFF0B3D2E);

  /// Light grey – border, divider, nền phụ
  static const Color greyLight     = Color(0xFFE0E0E0);

  /// White 50 % opacity – overlay, hint text
  static const Color whiteOverlay  = Color(0x80FFFFFF);

  /// Medium grey – body text phụ, caption
  static const Color greyMedium    = Color(0xFF616161);

  /// Pure white – nền chính, text trên nền tối
  static const Color white         = Color(0xFFFFFFFF);

  /// Error / destructive red
  static const Color error         = Color(0xFFC62828);

  /// Warning / accent yellow
  static const Color warning       = Color(0xFFFBC02D);
}

// ──────────────────────────────────────────────
// Text Theme
// ──────────────────────────────────────────────
const TextTheme _appTextTheme = TextTheme(
  // ── Title ──
  titleLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.15,
  ),
  titleMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.1,
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  ),

  // ── Body ──
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.greyMedium,
    height: 1.5,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.greyMedium,
    height: 1.45,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.greyMedium,
    height: 1.4,
  ),

  // ── Caption / Label ──
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.greyMedium,
  ),
  labelSmall: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.greyMedium,
    letterSpacing: 0.5,
  ),
);

// ──────────────────────────────────────────────
// App ThemeData
// ──────────────────────────────────────────────
final ThemeData appTheme = ThemeData(
  // ── Colours ──
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.greyMedium,
  ),

  // ── Text ──
  textTheme: _appTextTheme,

  // ── AppBar ──
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
  ),

  // ── ElevatedButton ──
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),

  // ── OutlinedButton ──
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),

  // ── InputDecoration ──
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.greyLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.greyLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    hintStyle: const TextStyle(color: AppColors.greyMedium, fontSize: 14),
  ),

  // ── Divider ──
  dividerColor: AppColors.greyLight,
  dividerTheme: const DividerThemeData(
    color: AppColors.greyLight,
    thickness: 1,
    space: 1,
  ),
);
