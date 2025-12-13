/// Vibe Match Card Widget
///
/// Bento grid card for discovering new connections.
/// Features full-bleed photography with gradient overlay.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class VibeMatchCard extends StatefulWidget {
  final VibeMatchData data;
  final bool isLarge;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const VibeMatchCard({
    super.key,
    required this.data,
    this.isLarge = false,
    this.onTap,
    this.onAdd,
  });

  @override
  State<VibeMatchCard> createState() => _VibeMatchCardState();
}

class _VibeMatchCardState extends State<VibeMatchCard>
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
      end: 0.97,
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
    final data = widget.data;

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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryAccent.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.radiusLarge),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    Image.network(
                      data.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: theme.mutedPrimary,
                        child: Icon(
                          Icons.person,
                          color: theme.textSecondary,
                          size: 48,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          stops: const [0.3, 0.6, 1.0],
                        ),
                      ),
                    ),
                    // Content overlay
                    Positioned(
                      left: theme.spacingM,
                      right: theme.spacingM,
                      bottom: theme.spacingM,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.name,
                            style:
                                (widget.isLarge
                                        ? theme.heading3
                                        : theme.labelMedium)
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: theme.spacingXS),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: theme.spacingS,
                              vertical: theme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                theme.radiusFull,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                theme.radiusFull,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Text(
                                  data.vibeTag,
                                  style: theme.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add button
                    Positioned(
                      top: theme.spacingS,
                      right: theme.spacingS,
                      child: _GlassAddButton(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          widget.onAdd?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GlassAddButton extends StatefulWidget {
  final VoidCallback? onTap;

  const _GlassAddButton({this.onTap});

  @override
  State<_GlassAddButton> createState() => _GlassAddButtonState();
}

class _GlassAddButtonState extends State<_GlassAddButton>
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(theme.radiusFull),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Bento grid for vibe match cards
class VibeMatchGrid extends StatelessWidget {
  final List<VibeMatchData> matches;
  final ValueChanged<VibeMatchData>? onCardTap;
  final ValueChanged<VibeMatchData>? onAddTap;

  const VibeMatchGrid({
    super.key,
    required this.matches,
    this.onCardTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    if (matches.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 280,
      child: Row(
        children: [
          // Large card (left)
          if (matches.isNotEmpty)
            Expanded(
              flex: 3,
              child: VibeMatchCard(
                data: matches[0],
                isLarge: true,
                onTap: () => onCardTap?.call(matches[0]),
                onAdd: () => onAddTap?.call(matches[0]),
              ),
            ),
          SizedBox(width: theme.spacingM),
          // Stacked cards (right)
          Expanded(
            flex: 2,
            child: Column(
              children: [
                if (matches.length > 1)
                  Expanded(
                    child: VibeMatchCard(
                      data: matches[1],
                      onTap: () => onCardTap?.call(matches[1]),
                      onAdd: () => onAddTap?.call(matches[1]),
                    ),
                  ),
                if (matches.length > 2) ...[
                  SizedBox(height: theme.spacingM),
                  Expanded(
                    child: VibeMatchCard(
                      data: matches[2],
                      onTap: () => onCardTap?.call(matches[2]),
                      onAdd: () => onAddTap?.call(matches[2]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VibeMatchData {
  final String id;
  final String name;
  final String imageUrl;
  final String vibeTag;

  const VibeMatchData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.vibeTag,
  });
}
