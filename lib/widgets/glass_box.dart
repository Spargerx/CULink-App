import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const GlassBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            // Blur Effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(),
            ),
            // Gradient & Border
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
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
