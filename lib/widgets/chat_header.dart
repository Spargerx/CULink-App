/// Chat Header Widget
///
/// Frosted glass sticky header with user info and activity status.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class ChatHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String? activityStatus;
  final String? activityIcon;
  final double scrollOffset;
  final VoidCallback? onBackTap;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onMagicTap;

  const ChatHeader({
    super.key,
    required this.name,
    required this.avatarUrl,
    this.activityStatus,
    this.activityIcon,
    this.scrollOffset = 0,
    this.onBackTap,
    this.onAvatarTap,
    this.onCallTap,
    this.onMagicTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final topPadding = MediaQuery.of(context).padding.top;

    // Increase opacity as user scrolls up
    final glassOpacity = (0.85 + (scrollOffset / 500).clamp(0, 0.15)).clamp(
      0.85,
      1.0,
    );

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: EdgeInsets.only(
            top: topPadding + theme.spacingS,
            left: theme.spacingM,
            right: theme.spacingM,
            bottom: theme.spacingM,
          ),
          decoration: BoxDecoration(
            color: theme.backgroundLight.withValues(alpha: glassOpacity),
            border: Border(
              bottom: BorderSide(
                color: theme.mutedPrimary.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Back button
              _HeaderIconButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onBackTap?.call();
                },
              ),
              SizedBox(width: theme.spacingS),
              // Avatar
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: theme.mutedPrimary,
                        child: Icon(Icons.person, color: theme.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: theme.spacingM),
              // Name and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: theme.displayFontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                    if (activityStatus != null) ...[
                      SizedBox(height: 2),
                      _ActivityPill(
                        status: activityStatus!,
                        icon: activityIcon,
                      ),
                    ],
                  ],
                ),
              ),
              // Action buttons
              _HeaderIconButton(
                icon: Icons.auto_awesome_outlined,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onMagicTap?.call();
                },
              ),
              SizedBox(width: theme.spacingXS),
              _HeaderIconButton(
                icon: Icons.call_outlined,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onCallTap?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _HeaderIconButton({required this.icon, this.onTap});

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.mutedPrimary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: theme.textPrimary, size: 20),
            ),
          );
        },
      ),
    );
  }
}

class _ActivityPill extends StatelessWidget {
  final String status;
  final String? icon;

  const _ActivityPill({required this.status, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingS, vertical: 2),
      decoration: BoxDecoration(
        color: theme.secondaryAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(theme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon!, style: const TextStyle(fontSize: 10)),
            SizedBox(width: 4),
          ],
          Text(
            status,
            style: theme.bodySmall.copyWith(
              color: theme.secondaryAccent,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
