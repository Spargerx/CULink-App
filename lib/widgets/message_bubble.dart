/// Message Bubble Widget
///
/// Chat message bubbles with distinct styles for incoming/outgoing.
/// Features smart stacking, reactions, swipe-to-reveal timestamps.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';
import '../theme/theme_config.dart';

class MessageBubble extends StatefulWidget {
  final MessageData message;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final VoidCallback? onLongPress;
  final VoidCallback? onReactionTap;

  const MessageBubble({
    super.key,
    required this.message,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    this.onLongPress,
    this.onReactionTap,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  double _dragOffset = 0;
  bool _isDragging = false;

  // Max slide distance to reveal timestamp
  static const double _maxSlide = 60.0;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    setState(() => _isDragging = true);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final isOutgoing = widget.message.isOutgoing;

    // Outgoing: swipe left (negative delta) to reveal timestamp on right
    // Incoming: swipe right (positive delta) to reveal timestamp on left
    if (isOutgoing) {
      // Only allow left swipe (negative)
      _dragOffset = (_dragOffset + details.delta.dx).clamp(-_maxSlide, 0);
    } else {
      // Only allow right swipe (positive)
      _dragOffset = (_dragOffset + details.delta.dx).clamp(0, _maxSlide);
    }
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() => _isDragging = false);

    // Animate back to original position with spring
    _slideAnimation = Tween<double>(begin: _dragOffset, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _slideController.forward(from: 0).then((_) {
      setState(() => _dragOffset = 0);
    });

    // Light haptic if we revealed timestamp
    if (_dragOffset.abs() > 20) {
      HapticFeedback.selectionClick();
    }
  }

  double get _currentOffset {
    if (_isDragging) return _dragOffset;
    if (_slideController.isAnimating) return _slideAnimation.value;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final isOutgoing = widget.message.isOutgoing;

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        final offset = _currentOffset;
        final opacity = (offset.abs() / _maxSlide).clamp(0.0, 1.0);

        return Padding(
          padding: EdgeInsets.only(
            left: isOutgoing ? 60 : theme.spacingL,
            right: isOutgoing ? theme.spacingL : 60,
            top: widget.isFirstInGroup ? theme.spacingS : 2,
            bottom: widget.isLastInGroup ? theme.spacingS : 2,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Timestamp revealed behind the bubble
              Positioned.fill(
                child: Align(
                  alignment: isOutgoing
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: isOutgoing ? 8 : 0,
                      left: isOutgoing ? 0 : 8,
                    ),
                    child: Opacity(
                      opacity: opacity,
                      child: Text(
                        widget.message.time,
                        style: theme.bodySmall.copyWith(
                          color: theme.textSecondary.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Sliding message bubble
              Transform.translate(
                offset: Offset(offset, 0),
                child: Align(
                  alignment: isOutgoing
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: GestureDetector(
                    onHorizontalDragStart: _onHorizontalDragStart,
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    onLongPress: widget.onLongPress,
                    child: _buildBubbleContent(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBubbleContent(BuildContext context) {
    final theme = context.cuTheme;
    final isOutgoing = widget.message.isOutgoing;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Message bubble
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacingM,
            vertical: theme.spacingS + 4,
          ),
          decoration: BoxDecoration(
            gradient: isOutgoing ? _outgoingGradient : null,
            color: isOutgoing ? null : Colors.white,
            borderRadius: _getBorderRadius(theme, isOutgoing),
            boxShadow: isOutgoing
                ? null
                : [
                    BoxShadow(
                      color: theme.primaryAccent.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reply preview if exists
              if (widget.message.replyTo != null) _buildReplyPreview(context),
              // Message text
              Text(
                widget.message.text,
                style: theme.bodyMedium.copyWith(
                  color: isOutgoing ? Colors.white : theme.textPrimary,
                  height: 1.4,
                ),
              ),
              // Timestamp (only on last in group when showTime is true)
              if (widget.isLastInGroup && widget.message.showTime)
                Padding(
                  padding: EdgeInsets.only(top: theme.spacingXS),
                  child: Text(
                    widget.message.time,
                    style: theme.bodySmall.copyWith(
                      color: isOutgoing
                          ? Colors.white.withValues(alpha: 0.7)
                          : theme.textSecondary.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Reaction bubble
        if (widget.message.reaction != null)
          Positioned(
            top: -8,
            right: isOutgoing ? null : -4,
            left: isOutgoing ? -4 : null,
            child: GestureDetector(
              onTap: widget.onReactionTap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.message.reaction!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }

  LinearGradient get _outgoingGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFBA7D6C), // Terracotta
        Color(0xFFA66B5A), // Deeper clay
        Color(0xFF8F5C4C), // Rust tone
      ],
    );
  }

  BorderRadius _getBorderRadius(CULinkThemeData theme, bool isOutgoing) {
    const radius = 20.0;
    const smallRadius = 6.0;

    if (isOutgoing) {
      return BorderRadius.only(
        topLeft: const Radius.circular(radius),
        topRight: Radius.circular(widget.isFirstInGroup ? radius : smallRadius),
        bottomLeft: const Radius.circular(radius),
        bottomRight: Radius.circular(
          widget.isLastInGroup ? smallRadius : smallRadius,
        ),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(widget.isFirstInGroup ? radius : smallRadius),
        topRight: const Radius.circular(radius),
        bottomLeft: Radius.circular(
          widget.isLastInGroup ? smallRadius : smallRadius,
        ),
        bottomRight: const Radius.circular(radius),
      );
    }
  }

  Widget _buildReplyPreview(BuildContext context) {
    final theme = context.cuTheme;
    final isOutgoing = widget.message.isOutgoing;

    return Container(
      margin: EdgeInsets.only(bottom: theme.spacingS),
      padding: EdgeInsets.only(left: theme.spacingS),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: isOutgoing
                ? Colors.white.withValues(alpha: 0.5)
                : theme.secondaryAccent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        widget.message.replyTo!,
        style: theme.bodySmall.copyWith(
          color: isOutgoing
              ? Colors.white.withValues(alpha: 0.7)
              : theme.textSecondary,
          fontStyle: FontStyle.italic,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Date separator widget
class DateSeparator extends StatelessWidget {
  final String date;

  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacingL),
      child: Center(
        child: Text(
          date,
          style: TextStyle(
            fontFamily: theme.displayFontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: theme.textSecondary.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// Data model for messages
class MessageData {
  final String id;
  final String text;
  final String time;
  final bool isOutgoing;
  final String? reaction;
  final String? replyTo;
  final bool showTime;
  final DateTime? timestamp;

  const MessageData({
    required this.id,
    required this.text,
    required this.time,
    required this.isOutgoing,
    this.reaction,
    this.replyTo,
    this.showTime = false,
    this.timestamp,
  });
}
