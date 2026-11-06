import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

// The reusable background that paints the app icon's navy gradient behind its child
// Two ways to use it :
// - around a whole Scaffold (given backgroundColor: Colors.transparent) : the gradient runs behind the app bar too, and keeps its full height when the keyboard opens
// - around a part of a screen, like the 3D area of the protein view
// Must not hold any logic : it only paints
// Trap : a tap ripple (InkWell, ListTile) is drawn by the nearest Material ABOVE it in the tree, underneath that Material's children.
// This box is not a Material : put a ripple widget directly inside it and the gradient covers its ripple, so keep a Scaffold, Card or Material in between

class NavyBackground extends StatelessWidget {
  final Widget child;

  const NavyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: child,
    );
  }
}
