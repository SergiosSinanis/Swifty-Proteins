import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/theme/app_colors.dart';

// The app icon shown above the login and register forms, so the first screen after the splash carries the same image
// Must not hold any logic : it only displays the icon

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  static const double _size = 96;
  static const double _cornerRadius = 22; // rounded like an app icon on the home screen

  @override
  Widget build(BuildContext context) {
    final roundedCorners = BorderRadius.circular(_cornerRadius);
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: roundedCorners,
          boxShadow: [BoxShadow(color: AppColors.teal.withValues(alpha: 0.25), blurRadius: 32)], // a soft teal glow around the icon
        ),
        // a foreground decoration is painted over the image (a normal one would be hidden under it) :
        // this thin light edge separates the icon's navy from the screen's navy
        foregroundDecoration: BoxDecoration(
          borderRadius: roundedCorners,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: ClipRRect(
          borderRadius: roundedCorners,
          child: Image.asset(
            AppConstants.appIconAssetPath,
            width: _size,
            height: _size,
            excludeFromSemantics: true, // decoration only : screen readers skip it
          ),
        ),
      ),
    );
  }
}
