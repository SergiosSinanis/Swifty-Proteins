import 'package:flutter/material.dart';

// The app's colors, sampled from assets/images/app_icon.png so every screen matches the icon
// They are defined once, here : app_theme.dart turns them into the theme, and a widget reads them directly only for what the theme has no slot for (the gradient, the see-through layers)
// Must not hold any logic : only color values
// How to read Color(0xAARRGGBB) : the first 2 hex digits are the opacity (FF = solid, 00 = invisible), then come red, green and blue

class AppColors {
  AppColors._(); // a private unnamed constructor = nothing outside this file can create an AppColors object

  static const Color navyDeep = Color(0xFF08182E); // the icon's top-left corner : the top of every screen
  static const Color navyTeal = Color(0xFF0E3E4F); // the icon's bottom-right corner : the bottom of every screen
  static const Color navySurface = Color(0xFF12324D); // dialogs, messages and cards : a lighter navy so they stand out from the background
  static const Color teal = Color(0xFF22C7B4); // the icon's central atom : buttons, focused fields, accents
  static const Color coral = Color(0xFFFF6B6B); // errors : the icon has no warm color, and an error must not look like a success

  static const Color textMuted = Color(0xB3FFFFFF); // see-through white : labels, helper texts, secondary texts
  static const Color glassFill = Color(0x14FFFFFF); // faint white layer of the text fields and list rows : the gradient stays visible through it
  static const Color glassBorder = Color(0x29FFFFFF); // the thin outline around those see-through layers

  // Top to bottom, while the icon goes corner to corner : the protein view's app bar is solid navyDeep,
  // and only a gradient whose whole top edge is navyDeep meets that bar without a visible line
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navyDeep, navyTeal],
  );
}
