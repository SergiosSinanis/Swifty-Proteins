import 'package:flutter/material.dart';
import 'app_colors.dart';

// The app's only theme : the dark navy look of the app icon (the color values themselves live in app_colors.dart)
// MaterialApp (app.dart) hands this ThemeData down to every widget : a TextField, a button, a dialog or a SnackBar reads its colors and shapes from here, so the screens never repeat them
// Must not hold any logic : only looks

class AppTheme {
  AppTheme._(); // a private unnamed constructor

  static const double cornerRadius = 14; // text fields, buttons and list rows share one roundness (public : ligand_tile.dart uses it too)
  static const double _buttonHeight = 52;
  static const double _dialogCornerRadius = 24;

  static ThemeData get dark {
    // the base theme gives us Flutter's text styles (with the phone's own font), so below we only change their color and weight
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.navyDeep, // what a screen shows where no NavyBackground paints the gradient
    );
    final textTheme = base.textTheme;

    return base.copyWith(
      appBarTheme: AppBarThemeData(
        backgroundColor: Colors.transparent, // the screen's gradient (or the navy scaffold) shows through the bar
        foregroundColor: Colors.white, // title, back arrow and icons
        elevation: 0,
        scrolledUnderElevation: 0, // Material 3 tints the bar when a list scrolls under it : off, so the bar stays see-through
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.glassFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: _roundedBorder(AppColors.glassBorder),
        enabledBorder: _roundedBorder(AppColors.glassBorder),
        focusedBorder: _roundedBorder(AppColors.teal, width: 1.6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.navyDeep,
          elevation: 0,
          minimumSize: const Size(64, _buttonHeight),
          shape: _roundedShape,
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.glassBorder),
          minimumSize: const Size(64, _buttonHeight),
          shape: _roundedShape,
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.teal,
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      // the "OK" button of the error dialog : teal with navy text, from the color scheme's primary / onPrimary
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: _roundedShape,
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.navySurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_dialogCornerRadius),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.4),
        barrierColor: AppColors.navyDeep.withValues(alpha: 0.7), // the layer that darkens the screen behind a dialog : navy instead of black
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating, // a rounded card floating above the bottom edge, instead of a full-width bar
        backgroundColor: AppColors.navySurface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
          side: BorderSide(color: AppColors.teal.withValues(alpha: 0.5)),
        ),
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      // the atom pop-up of the 3D view : solid (not see-through) so its text stays readable over the molecule
      cardTheme: CardThemeData(
        color: AppColors.navySurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
      ),
    );
  }

  // Material 3 widgets pick their colors from these roles (a "primary" button, an "error" icon, text "on" a "surface"...)
  static const ColorScheme _colorScheme = ColorScheme.dark(
    primary: AppColors.teal,
    onPrimary: AppColors.navyDeep, // text and icons drawn on teal
    secondary: AppColors.teal,
    onSecondary: AppColors.navyDeep,
    error: AppColors.coral,
    onError: AppColors.navyDeep,
    surface: AppColors.navySurface,
    onSurface: Colors.white,
    onSurfaceVariant: AppColors.textMuted, // field labels, helper texts and icons
    outline: AppColors.glassBorder,
    surfaceTint: Colors.transparent, // Material 3 would otherwise lay a teal tint over raised surfaces : they keep their exact navy
  );

  static const RoundedRectangleBorder _roundedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
  );

  static OutlineInputBorder _roundedBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(cornerRadius)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
