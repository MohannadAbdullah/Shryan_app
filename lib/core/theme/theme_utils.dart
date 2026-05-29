import 'package:flutter/material.dart';

/// Cheat Sheet for accessing Theme colors without hardcoding.
/// Use these getters within your build methods.
class ThemeUtils {
  
  /// Primary color (e.g. Deep Red for buttons, active icons, important badges)
  static Color primaryColor(BuildContext context) => Theme.of(context).primaryColor;
  
  /// Background color for Scaffold (e.g. White in Light mode, Dark Grey in Dark mode)
  static Color scaffoldBackgroundColor(BuildContext context) => Theme.of(context).scaffoldBackgroundColor;
  
  /// Surface color for Cards, Dialogs, and Containers
  static Color surfaceColor(BuildContext context) => Theme.of(context).colorScheme.surface;
  
  /// Card background color (similar to surface, explicitly for cards)
  static Color cardColor(BuildContext context) => Theme.of(context).cardColor;

  /// Default text color for body paragraphs
  static Color? bodyTextColor(BuildContext context) => Theme.of(context).textTheme.bodyLarge?.color;
  
  /// Default text color for titles and headings
  static Color? titleTextColor(BuildContext context) => Theme.of(context).textTheme.titleLarge?.color;

  /// Default icon color
  static Color? iconColor(BuildContext context) => Theme.of(context).iconTheme.color;
  
  /// Faded / secondary text color (useful for subtitles or hints)
  static Color? subtitleTextColor(BuildContext context) => Theme.of(context).textTheme.bodySmall?.color;

  /// Color for dividers and subtle borders
  static Color dividerColor(BuildContext context) => Theme.of(context).dividerColor;
}
