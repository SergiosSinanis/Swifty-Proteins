import 'package:flutter/material.dart';

// The reusable error alert dialog box, that can be called with a title and message, used for every required error scenario (no connection, 404, parsing failure, timeout, biometric failure)
// Its card, text styles and button colors come from dialogTheme and filledButtonTheme in app_theme.dart : this file only arranges them (a badge on top, centered texts, a full-width button)

class ErrorDialog {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const _ErrorBadge(), // with an icon on top, Material 3 also centers the title
        title: Text(title),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          SizedBox( // we have a window title with the error message and a button "OK", as wide as the card
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}

// the error icon inside a softly tinted circle, at the top of the dialog
class _ErrorBadge extends StatelessWidget {
  const _ErrorBadge();

  static const double _badgeSize = 56;
  static const double _iconSize = 30;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    // Center keeps the circle round : the dialog stretches its icon slot to the full card width
    return Center(
      child: Container(
        width: _badgeSize,
        height: _badgeSize,
        decoration: BoxDecoration(
          color: errorColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.error_outline_rounded, color: errorColor, size: _iconSize),
      ),
    );
  }
}
