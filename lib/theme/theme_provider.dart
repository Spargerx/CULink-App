// CULink Theme Provider
//
// Provides theme access throughout the app using InheritedWidget pattern.
// To switch themes, change the import below to point to a different theme.

import 'package:flutter/material.dart';
import 'theme_config.dart';

// === CHANGE THIS IMPORT TO SWITCH THEMES ===
import 'themes/earthy_elegance/earthy_elegance_theme.dart';

/// The current active theme
const CULinkThemeData currentTheme = EarthyEleganceTheme();

/// Theme provider widget that makes theme accessible anywhere in the widget tree
class CULinkThemeProvider extends InheritedWidget {
  final CULinkThemeData theme;

  const CULinkThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  /// Access theme from anywhere in the widget tree
  static CULinkThemeData of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<CULinkThemeProvider>();
    return provider?.theme ?? currentTheme;
  }

  /// Access theme without listening to changes (for performance in build methods)
  static CULinkThemeData read(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<CULinkThemeProvider>();
    return provider?.theme ?? currentTheme;
  }

  @override
  bool updateShouldNotify(CULinkThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

/// Extension for easy theme access
extension CULinkThemeExtension on BuildContext {
  CULinkThemeData get cuTheme => CULinkThemeProvider.of(this);
}
