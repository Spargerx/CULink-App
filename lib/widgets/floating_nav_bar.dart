// Floating Navigation Bar Widget
//
// iOS-style floating bottom navigation with glassmorphism effect.
// Features animated active state and notification badges.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const FloatingNavBar({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: theme.spacingXL,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: screenWidth * 0.85,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacingL,
            vertical: theme.spacingM,
          ),
          decoration: BoxDecoration(
            color: theme.backgroundLight.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(theme.radiusFull),
            border: Border.all(
              color: theme.mutedPrimary.withValues(alpha: 0.6),
            ),
            boxShadow: theme.navBarShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.radiusFull),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                    icon: Icons.home,
                    isActive: currentIndex == 0,
                    onTap: () => _handleTap(0),
                  ),
                  _NavItem(
                    icon: Icons.group,
                    isActive: currentIndex == 1,
                    onTap: () => _handleTap(1),
                  ),
                  _NavItem(
                    icon: Icons.chat_bubble,
                    isActive: currentIndex == 2,
                    showBadge: true,
                    onTap: () => _handleTap(2),
                  ),
                  _NavItem(
                    icon: Icons.settings,
                    isActive: currentIndex == 3,
                    onTap: () => _handleTap(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    HapticFeedback.lightImpact();
    onTap?.call(index);
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final bool showBadge;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    this.isActive = false,
    this.showBadge = false,
    this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
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
      end: 0.9,
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: theme.durationNormal,
                  curve: Curves.easeOutCubic,
                  width: theme.avatarLarge,
                  height: theme.avatarLarge,
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? theme.primaryAccent
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: theme.primaryAccent.withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    displayIcon,
                    color: widget.isActive ? Colors.white : theme.textSecondary,
                    size: 24,
                  ),
                ),
                // Notification badge
                if (widget.showBadge)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: theme.primaryAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.backgroundLight,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData get displayIcon {
    if (widget.isActive) {
      return widget.icon;
    }
    switch (widget.icon) {
      case Icons.home:
        return Icons.home_outlined;
      case Icons.group:
        return Icons.group_outlined;
      case Icons.chat_bubble:
        return Icons.chat_bubble_outline;
      case Icons.settings:
        return Icons.settings_outlined;
      default:
        return widget.icon;
    }
  }
}
