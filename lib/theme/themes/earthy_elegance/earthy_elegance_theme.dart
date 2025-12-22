// Earthy Elegance Theme
//
// The main theme class that combines all theme components.
// To switch themes, create a new theme class implementing CULinkThemeData.

import 'package:flutter/material.dart';
import '../../theme_config.dart';
import 'colors.dart';
import 'typography.dart';
import 'dimensions.dart';
import 'animations.dart';

class EarthyEleganceTheme implements CULinkThemeData {
  const EarthyEleganceTheme();

  // === Colors ===
  @override
  Color get primaryAccent => EarthyColors.terracotta;

  @override
  Color get secondaryAccent => EarthyColors.sage;

  @override
  Color get backgroundLight => EarthyColors.backgroundLight;

  @override
  Color get backgroundDark => EarthyColors.backgroundDark;

  @override
  Color get textPrimary => EarthyColors.charcoal;

  @override
  Color get textSecondary => EarthyColors.charcoal.withValues(alpha: 0.6);

  @override
  Color get mutedPrimary => EarthyColors.sand;

  @override
  Color get mutedSecondary => EarthyColors.clay;

  @override
  Color get mutedTertiary => EarthyColors.moss;

  // === Gradients ===
  @override
  LinearGradient get primaryGradient => EarthyColors.primaryGradient;

  @override
  LinearGradient get backgroundGradient => EarthyColors.backgroundGradientLight;

  // === Typography ===
  @override
  String get displayFontFamily => EarthyTypography.displayFont;

  @override
  String get bodyFontFamily => EarthyTypography.bodyFont;

  @override
  TextStyle get heading1 => EarthyTypography.heading1;

  @override
  TextStyle get heading2 => EarthyTypography.heading2;

  @override
  TextStyle get heading3 => EarthyTypography.heading3;

  @override
  TextStyle get bodyLarge => EarthyTypography.bodyLarge;

  @override
  TextStyle get bodyMedium => EarthyTypography.bodyMedium;

  @override
  TextStyle get bodySmall => EarthyTypography.bodySmall;

  @override
  TextStyle get labelMedium => EarthyTypography.labelMedium;

  @override
  TextStyle get labelSmall => EarthyTypography.labelSmall;

  // === Dimensions ===
  @override
  double get radiusSmall => EarthyDimensions.radiusSmall;

  @override
  double get radiusMedium => EarthyDimensions.radiusMedium;

  @override
  double get radiusLarge => EarthyDimensions.radiusLarge;

  @override
  double get radiusXL => EarthyDimensions.radiusXL;

  @override
  double get radiusFull => EarthyDimensions.radiusFull;

  @override
  double get spacingXS => EarthyDimensions.spacingXS;

  @override
  double get spacingS => EarthyDimensions.spacingS;

  @override
  double get spacingM => EarthyDimensions.spacingM;

  @override
  double get spacingL => EarthyDimensions.spacingL;

  @override
  double get spacingXL => EarthyDimensions.spacingXL;

  @override
  double get spacingXXL => EarthyDimensions.spacingXXL;

  @override
  double get storyCircleSize => EarthyDimensions.storyCircleSize;

  @override
  double get avatarSmall => EarthyDimensions.avatarSmall;

  @override
  double get avatarMedium => EarthyDimensions.avatarMedium;

  @override
  double get avatarLarge => EarthyDimensions.avatarLarge;

  @override
  double get bottomNavHeight => EarthyDimensions.bottomNavHeight;

  @override
  double get postImageHeight => EarthyDimensions.postImageHeight;

  // === Animations ===
  @override
  Duration get durationFast => EarthyAnimations.durationFast;

  @override
  Duration get durationNormal => EarthyAnimations.durationNormal;

  @override
  Duration get durationSlow => EarthyAnimations.durationSlow;

  @override
  Curve get curveDefault => EarthyAnimations.curveDefault;

  @override
  Curve get curveSpring => EarthyAnimations.curveSpring;

  @override
  Curve get curveEaseOut => EarthyAnimations.curveEaseOut;

  @override
  double get buttonScalePressed => EarthyAnimations.buttonScalePressed;

  @override
  double get buttonScaleHover => EarthyAnimations.buttonScaleHover;

  // === Shadows ===
  @override
  List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: EarthyColors.terracotta.withValues(alpha: 0.25),
      blurRadius: 60,
      offset: const Offset(0, 30),
      spreadRadius: -15,
    ),
    BoxShadow(
      color: EarthyColors.sage.withValues(alpha: 0.2),
      blurRadius: 30,
      offset: const Offset(0, 15),
      spreadRadius: -10,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: EarthyColors.terracotta.withValues(alpha: 0.4),
      blurRadius: 15,
      offset: const Offset(0, 5),
      spreadRadius: 1,
    ),
  ];

  @override
  List<BoxShadow> get navBarShadow => [
    BoxShadow(
      color: EarthyColors.terracotta.withValues(alpha: 0.1),
      blurRadius: 30,
      offset: const Offset(0, 10),
      spreadRadius: 5,
    ),
  ];

  // === Borders ===
  @override
  Border get cardBorder =>
      Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1);

  @override
  Border get glassBorder =>
      Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1);
}
