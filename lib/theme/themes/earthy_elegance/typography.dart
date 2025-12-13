/// Earthy Elegance Theme - Typography
///
/// Uses Playfair Display for elegant headings and Inter for clean body text.
/// Optimized for readability and visual hierarchy.

import 'package:flutter/material.dart';
import 'colors.dart';

class EarthyTypography {
  static const String displayFont = 'Playfair Display';
  static const String bodyFont = 'Inter';

  // Heading styles
  static TextStyle get heading1 => const TextStyle(
    fontFamily: displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: EarthyColors.charcoal,
  );

  static TextStyle get heading2 => const TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: EarthyColors.charcoal,
  );

  static TextStyle get heading3 => const TextStyle(
    fontFamily: displayFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: EarthyColors.charcoal,
  );

  // Body styles
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: EarthyColors.charcoal,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: EarthyColors.charcoal,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: EarthyColors.charcoal,
  );

  // Label styles
  static TextStyle get labelMedium => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: EarthyColors.charcoal,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: EarthyColors.charcoal,
  );
}
