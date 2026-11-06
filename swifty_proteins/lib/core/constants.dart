
// Useful values used across the project 

class AppConstants {
  AppConstants._(); // a private unnamed constructor = nothing outside this file can call it

  static const String rcsbBaseUrl = 'https://files.rcsb.org/ligands/view'; // static = belongs to the class itself = not an instance
  static const Duration networkTimeout = Duration(seconds: 10); // for timeouts
  static const Duration splashDuration = Duration(seconds: 2); // how long the native splash stays on screen at launch (see main.dart)
  static const String ligandsAssetPath = 'assets/data/ligands.txt';
  static const String appIconAssetPath = 'assets/images/app_icon.png'; // shown above the login and register forms
}
