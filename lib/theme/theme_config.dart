/// CULink Theme Configuration
///
/// This file defines the core theme interface that all themes must implement.
/// To switch themes, change the import in theme_provider.dart to point to a different theme.

import 'package:flutter/material.dart';

/// Abstract class defining all configurable theme properties
abstract class CULinkThemeData {
  // === Colors ===
  Color get primaryAccent;
  Color get secondaryAccent;
  Color get backgroundLight;
  Color get backgroundDark;
  Color get textPrimary;
  Color get textSecondary;
  Color get mutedPrimary;
  Color get mutedSecondary;
  Color get mutedTertiary;

  // === Gradients ===
  LinearGradient get primaryGradient;
  LinearGradient get backgroundGradient;

  // === Typography ===
  String get displayFontFamily;
  String get bodyFontFamily;
  TextStyle get heading1;
  TextStyle get heading2;
  TextStyle get heading3;
  TextStyle get bodyLarge;
  TextStyle get bodyMedium;
  TextStyle get bodySmall;
  TextStyle get labelMedium;
  TextStyle get labelSmall;

  // === Dimensions ===
  double get radiusSmall;
  double get radiusMedium;
  double get radiusLarge;
  double get radiusXL;
  double get radiusFull;

  double get spacingXS;
  double get spacingS;
  double get spacingM;
  double get spacingL;
  double get spacingXL;
  double get spacingXXL;

  double get storyCircleSize;
  double get avatarSmall;
  double get avatarMedium;
  double get avatarLarge;
  double get bottomNavHeight;
  double get postImageHeight;

  // === Animations ===
  Duration get durationFast;
  Duration get durationNormal;
  Duration get durationSlow;
  Curve get curveDefault;
  Curve get curveSpring;
  Curve get curveEaseOut;
  double get buttonScalePressed;
  double get buttonScaleHover;

  // === Shadows ===
  List<BoxShadow> get cardShadow;
  List<BoxShadow> get buttonShadow;
  List<BoxShadow> get navBarShadow;

  // === Borders ===
  Border get cardBorder;
  Border get glassBorder;
}
