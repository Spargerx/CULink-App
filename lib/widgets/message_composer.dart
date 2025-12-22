// Message Composer Widget
//
// Floating input field with send button that moves as a single unit.
// Keyboard-aware with smooth animations.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class MessageComposer extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend;
  final VoidCallback? onStickerTap;
  final ValueChanged<String>? onChanged;
  final String? prefilledText;

  const MessageComposer({
    super.key,
    this.controller,
    this.onSend,
    this.onStickerTap,
    this.onChanged,
    this.prefilledText,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScale;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.prefilledText != null) {
      _controller.text = widget.prefilledText!;
      _hasText = widget.prefilledText!.isNotEmpty;
    }
    _controller.addListener(_onTextChanged);

    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _sendButtonScale = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.easeOutBack),
    );
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onChanged?.call(_controller.text);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _sendButtonController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (!_hasText) return;
    HapticFeedback.mediumImpact();
    _sendButtonController.forward().then((_) {
      _sendButtonController.reverse();
    });
    widget.onSend?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        left: theme.spacingL,
        right: theme.spacingL,
        bottom: bottomPadding > 0 ? theme.spacingM : safeAreaBottom + 20,
      ),
      child: Row(
        children: [
          // Input capsule
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacingS,
                vertical: theme.spacingXS,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(theme.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Sticker/Mood button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.onStickerTap?.call();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryAccent.withValues(alpha: 0.8),
                            theme.secondaryAccent.withValues(alpha: 0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: theme.spacingS),
                  // Text field
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: theme.bodyMedium,
                      maxLines: 4,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Message…',
                        hintStyle: theme.bodyMedium.copyWith(
                          color: theme.textSecondary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: theme.spacingS,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: theme.spacingS),
          // Send button
          GestureDetector(
            onTapDown: (_) => _sendButtonController.forward(),
            onTapUp: (_) {
              _sendButtonController.reverse();
              _handleSend();
            },
            onTapCancel: () => _sendButtonController.reverse(),
            child: AnimatedBuilder(
              animation: _sendButtonScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sendButtonScale.value,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _hasText
                          ? theme.secondaryAccent
                          : theme.mutedSecondary,
                      shape: BoxShape.circle,
                      boxShadow: _hasText
                          ? [
                              BoxShadow(
                                color: theme.secondaryAccent.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Wave chip for empty state
class WaveChip extends StatefulWidget {
  final VoidCallback? onTap;

  const WaveChip({super.key, this.onTap});

  @override
  State<WaveChip> createState() => _WaveChipState();
}

class _WaveChipState extends State<WaveChip>
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
      end: 0.92,
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
        HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacingM,
                vertical: theme.spacingS,
              ),
              decoration: BoxDecoration(
                color: theme.secondaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(theme.radiusFull),
                border: Border.all(
                  color: theme.secondaryAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('👋', style: const TextStyle(fontSize: 16)),
                  SizedBox(width: theme.spacingS),
                  Text(
                    'Wave',
                    style: theme.labelMedium.copyWith(
                      color: theme.secondaryAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
