/// Earthy Elegance Theme - Colors
///
/// A warm, sophisticated color palette inspired by earth tones.
/// Features terracotta and sage as primary accents with soft neutrals.

import 'package:flutter/material.dart';

class EarthyColors {
  // Primary accents
  static const Color terracotta = Color(0xFFBA7D6C);
  static const Color sage = Color(0xFF7A9F8E);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFFDFBF7);
  static const Color backgroundDark = Color(0xFF1D1D1D);

  // Text
  static const Color charcoal = Color(0xFF2A2A2A);

  // Muted tones
  static const Color sand = Color(0xFFE8E2D7);
  static const Color clay = Color(0xFFD1C6BB);
  static const Color moss = Color(0xFFA4BCA9);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [terracotta, sage],
  );

  static LinearGradient get backgroundGradientLight => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      terracotta.withValues(alpha: 0.08),
      Colors.transparent,
      sage.withValues(alpha: 0.08),
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  static LinearGradient get backgroundGradientDark => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      terracotta.withValues(alpha: 0.05),
      Colors.transparent,
      sage.withValues(alpha: 0.05),
    ],
    stops: const [0.0, 0.5, 1.0],
  );
}
