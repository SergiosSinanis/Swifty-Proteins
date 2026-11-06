import 'package:flutter/material.dart';

// The reusable "it worked" message that slides up at the bottom of the screen, with a teal check icon (used when an account is created)
// Its card look (floating, rounded, navy, teal outline) comes from snackBarTheme in app_theme.dart : this file only adds the icon next to the text
// It must stay a SnackBar, not a dialog : the ScaffoldMessenger keeps a SnackBar visible across navigation, so a screen can show it and close itself right away

class SuccessSnackBar {
  SuccessSnackBar._(); // a private unnamed constructor = we only call the static show()

  static void show(BuildContext context, {required String message}) {
    final checkColor = Theme.of(context).colorScheme.primary;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: checkColor),
            const SizedBox(width: 12),
            Expanded(child: Text(message)), // Expanded = a long message wraps instead of overflowing
          ],
        ),
      ),
    );
  }
}
