/// Chat List Tile Widget
///
/// Individual message row with avatar, name, status, and timestamp.
/// Supports swipe actions and typing indicators.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class ChatListTile extends StatefulWidget {
  final ChatData chat;
  final VoidCallback? onTap;
  final VoidCallback? onArchive;
  final VoidCallback? onMute;

  const ChatListTile({
    super.key,
    required this.chat,
    this.onTap,
    this.onArchive,
    this.onMute,
  });

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  double _dragExtent = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
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
    final chat = widget.chat;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragExtent = (_dragExtent + details.delta.dx).clamp(-100.0, 0.0);
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragExtent < -50) {
          // Show actions
          setState(() => _dragExtent = -80);
        } else {
          setState(() => _dragExtent = 0);
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                // Swipe action buttons
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _SwipeAction(
                        icon: Icons.volume_off_outlined,
                        color: theme.mutedSecondary,
                        onTap: widget.onMute,
                      ),
                      _SwipeAction(
                        icon: Icons.archive_outlined,
                        color: theme.primaryAccent.withValues(alpha: 0.7),
                        onTap: widget.onArchive,
                      ),
                    ],
                  ),
                ),
                // Main content
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(_dragExtent, 0, 0),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacingL,
                    vertical: theme.spacingM,
                  ),
                  decoration: BoxDecoration(color: theme.backgroundLight),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            chat.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: theme.mutedPrimary,
                              child: Icon(
                                Icons.person,
                                color: theme.textSecondary,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: theme.spacingM),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and status row
                            Row(
                              children: [
                                Text(
                                  chat.name,
                                  style: theme.labelMedium.copyWith(
                                    fontWeight: chat.hasUnread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                                ),
                                if (chat.status != null) ...[
                                  SizedBox(width: theme.spacingS),
                                  Text(
                                    '• ${chat.status}',
                                    style: theme.bodySmall.copyWith(
                                      color: chat.status == 'Typing…'
                                          ? theme.secondaryAccent
                                          : theme.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 4),
                            // Message preview or typing indicator
                            if (chat.isTyping)
                              _TypingIndicator()
                            else
                              Text(
                                chat.lastMessage,
                                style: theme.bodySmall.copyWith(
                                  color: chat.hasUnread
                                      ? theme.textPrimary
                                      : theme.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: theme.spacingM),
                      // Timestamp and unread indicator
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            chat.timestamp,
                            style: theme.bodySmall.copyWith(
                              color: theme.textSecondary.withValues(alpha: 0.7),
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 6),
                          if (chat.hasUnread)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: theme.secondaryAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SwipeAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SwipeAction({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        width: 40,
        height: double.infinity,
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Row(
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final opacity = (value < 0.5 ? value * 2 : 2 - value * 2).clamp(
              0.3,
              1.0,
            );

            return Container(
              margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: theme.secondaryAccent.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

class ChatData {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String timestamp;
  final String? status;
  final bool hasUnread;
  final bool isTyping;

  const ChatData({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.timestamp,
    this.status,
    this.hasUnread = false,
    this.isTyping = false,
  });
}
