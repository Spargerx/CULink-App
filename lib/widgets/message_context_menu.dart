/// Message Context Menu Widget
///
/// Floating glassmorphic contextual menu for message actions.
/// Appears on long-press, never uses bottom sheet.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class MessageContextMenu extends StatefulWidget {
  final Offset position;
  final bool isOwnMessage;
  final VoidCallback? onReply;
  final VoidCallback? onReact;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback onDismiss;

  const MessageContextMenu({
    super.key,
    required this.position,
    this.isOwnMessage = false,
    this.onReply,
    this.onReact,
    this.onCopy,
    this.onDelete,
    required this.onDismiss,
  });

  @override
  State<MessageContextMenu> createState() => _MessageContextMenuState();
}

class _MessageContextMenuState extends State<MessageContextMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final screenSize = MediaQuery.of(context).size;

    // Calculate position to keep menu on screen
    double left = widget.position.dx - 80;
    double top = widget.position.dy - 60;

    // Adjust if too close to edges
    if (left < 20) left = 20;
    if (left + 160 > screenSize.width - 20) left = screenSize.width - 180;
    if (top < 100) top = widget.position.dy + 20;

    return GestureDetector(
      onTap: _dismiss,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.mutedPrimary.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _MenuButton(
                              icon: Icons.reply_rounded,
                              label: 'Reply',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.onReply?.call();
                                _dismiss();
                              },
                            ),
                            _MenuDivider(),
                            _MenuButton(
                              icon: Icons.emoji_emotions_outlined,
                              label: 'React',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.onReact?.call();
                                _dismiss();
                              },
                            ),
                            _MenuDivider(),
                            _MenuButton(
                              icon: Icons.copy_rounded,
                              label: 'Copy',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.onCopy?.call();
                                _dismiss();
                              },
                            ),
                            if (widget.isOwnMessage) ...[
                              _MenuDivider(),
                              _MenuButton(
                                icon: Icons.delete_outline_rounded,
                                label: 'Delete',
                                isDestructive: true,
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  widget.onDelete?.call();
                                  _dismiss();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final color = widget.isDestructive
        ? const Color(0xFFE57373)
        : theme.textPrimary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacingL,
          vertical: theme.spacingM,
        ),
        decoration: BoxDecoration(
          color: _isPressed
              ? theme.mutedPrimary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: color, size: 20),
            SizedBox(width: theme.spacingM),
            Text(
              widget.label,
              style: theme.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: theme.spacingL),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    return Container(
      height: 0.5,
      color: theme.mutedPrimary.withValues(alpha: 0.3),
    );
  }
}

/// Reaction picker popup
class ReactionPicker extends StatelessWidget {
  final Offset position;
  final ValueChanged<String>? onReactionSelected;
  final VoidCallback onDismiss;

  const ReactionPicker({
    super.key,
    required this.position,
    this.onReactionSelected,
    required this.onDismiss,
  });

  static const List<String> reactions = ['❤️', '👍', '😂', '😮', '😢', '🔥'];

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    // Picker dimensions - slightly larger estimate to be safe
    const pickerWidth = 300.0;
    const pickerHeight = 56.0;
    const margin = 16.0;

    // Available width considering safe areas
    final availableWidth = screenSize.width - (margin * 2);

    // Calculate horizontal position - prioritize keeping it fully on screen
    double left;
    if (pickerWidth >= availableWidth) {
      // Screen too narrow, center the picker
      left = (screenSize.width - pickerWidth) / 2;
    } else {
      // Try to center on tap position
      left = position.dx - (pickerWidth / 2);
      // Clamp to stay within screen bounds
      left = left.clamp(margin, screenSize.width - pickerWidth - margin);
    }

    // Calculate vertical position - above the tap point by default
    double top = position.dy - pickerHeight - 20;

    // If too close to top, show below
    if (top < padding.top + 80) {
      top = position.dy + 20;
    }

    // Clamp vertical position to stay on screen
    top = top.clamp(
      padding.top + margin,
      screenSize.height - pickerHeight - padding.bottom - margin,
    );

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(theme.radiusFull),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacingM,
                        vertical: theme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(theme.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: reactions.map((emoji) {
                          return _ReactionButton(
                            emoji: emoji,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              onReactionSelected?.call(emoji);
                              onDismiss();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReactionButton extends StatefulWidget {
  final String emoji;
  final VoidCallback? onTap;

  const _ReactionButton({required this.emoji, this.onTap});

  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton>
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
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacingS),
              child: Text(widget.emoji, style: const TextStyle(fontSize: 28)),
            ),
          );
        },
      ),
    );
  }
}
