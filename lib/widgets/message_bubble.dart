/// Message Bubble Widget
///
/// Chat message bubbles with distinct styles for incoming/outgoing.
/// Features smart stacking, reactions, and timestamps.

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../theme/theme_config.dart';

class MessageBubble extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final isOutgoing = message.isOutgoing;

    return Padding(
      padding: EdgeInsets.only(
        left: isOutgoing ? 60 : theme.spacingL,
        right: isOutgoing ? theme.spacingL : 60,
        top: isFirstInGroup ? theme.spacingS : 2,
        bottom: isLastInGroup ? theme.spacingS : 2,
      ),
      child: Align(
        alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Stack(
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
                    if (message.replyTo != null) _buildReplyPreview(context),
                    // Message text
                    Text(
                      message.text,
                      style: theme.bodyMedium.copyWith(
                        color: isOutgoing ? Colors.white : theme.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    // Timestamp (only on last in group)
                    if (isLastInGroup && message.showTime)
                      Padding(
                        padding: EdgeInsets.only(top: theme.spacingXS),
                        child: Text(
                          message.time,
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
              if (message.reaction != null)
                Positioned(
                  top: -8,
                  right: isOutgoing ? null : -4,
                  left: isOutgoing ? -4 : null,
                  child: GestureDetector(
                    onTap: onReactionTap,
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
                        message.reaction!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
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
        topRight: Radius.circular(isFirstInGroup ? radius : smallRadius),
        bottomLeft: const Radius.circular(radius),
        bottomRight: Radius.circular(isLastInGroup ? smallRadius : smallRadius),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(isFirstInGroup ? radius : smallRadius),
        topRight: const Radius.circular(radius),
        bottomLeft: Radius.circular(isLastInGroup ? smallRadius : smallRadius),
        bottomRight: const Radius.circular(radius),
      );
    }
  }

  Widget _buildReplyPreview(BuildContext context) {
    final theme = context.cuTheme;
    final isOutgoing = message.isOutgoing;

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
        message.replyTo!,
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
