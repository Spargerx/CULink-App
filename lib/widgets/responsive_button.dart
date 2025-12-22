// Responsive Button Widget
//
// A button with iOS-like press animation (scale down/up with spring).
// Supports haptic feedback and custom styling.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class ResponsiveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final bool enableHaptics;
  final double? width;
  final double? height;

  const ResponsiveButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.boxShadow,
    this.enableHaptics = true,
    this.width,
    this.height,
  });

  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: widget.padding ?? EdgeInsets.all(theme.spacingM),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? theme.primaryAccent,
                borderRadius:
                    widget.borderRadius ??
                    BorderRadius.circular(theme.radiusMedium),
                boxShadow: widget.boxShadow ?? theme.buttonShadow,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// A simple text button with responsive animation
class ResponsiveTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const ResponsiveTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return ResponsiveButton(
      onTap: onTap,
      backgroundColor: backgroundColor ?? theme.secondaryAccent,
      borderRadius: BorderRadius.circular(theme.radiusFull),
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacingL,
        vertical: theme.spacingS,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
      ),
    );
  }
}
