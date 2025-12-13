/// Glass Box Widget
///
/// A glassmorphism container with blur effect and gradient overlay.
/// Used for cards and overlays with a premium look.

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class GlassBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double? borderRadius;
  final double blurAmount;

  const GlassBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius,
    this.blurAmount = 15,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final radius = borderRadius ?? theme.radiusXL;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            // Blur Effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
              child: Container(),
            ),
            // Gradient & Border
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
            // Content
            Center(child: child),
          ],
        ),
      ),
    );
  }
}
