// Network List Widget
//
// Clean vertical list showing connected friends.
// Features status indicators and chat action.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class NetworkList extends StatelessWidget {
  final List<NetworkMemberData> members;
  final ValueChanged<NetworkMemberData>? onMemberTap;
  final ValueChanged<NetworkMemberData>? onChatTap;

  const NetworkList({
    super.key,
    required this.members,
    this.onMemberTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: members.length,
      separatorBuilder: (_, __) => SizedBox(height: theme.spacingS),
      itemBuilder: (context, index) {
        return NetworkMemberTile(
          member: members[index],
          onTap: () => onMemberTap?.call(members[index]),
          onChatTap: () => onChatTap?.call(members[index]),
        );
      },
    );
  }
}

class NetworkMemberTile extends StatefulWidget {
  final NetworkMemberData member;
  final VoidCallback? onTap;
  final VoidCallback? onChatTap;

  const NetworkMemberTile({
    super.key,
    required this.member,
    this.onTap,
    this.onChatTap,
  });

  @override
  State<NetworkMemberTile> createState() => _NetworkMemberTileState();
}

class _NetworkMemberTileState extends State<NetworkMemberTile>
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
    final member = widget.member;

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
              padding: EdgeInsets.all(theme.spacingM),
              decoration: BoxDecoration(
                color: theme.backgroundLight,
                borderRadius: BorderRadius.circular(theme.radiusMedium),
                border: Border.all(
                  color: theme.mutedPrimary.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  // Avatar with status
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.mutedSecondary.withValues(alpha: 0.5),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            member.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: theme.mutedPrimary,
                              child: Icon(
                                Icons.person,
                                color: theme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Online indicator
                      if (member.isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: _PulsingDot(color: theme.secondaryAccent),
                        ),
                    ],
                  ),
                  SizedBox(width: theme.spacingM),
                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: theme.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (member.status != null) ...[
                          SizedBox(height: 2),
                          Text(
                            member.status!,
                            style: theme.bodySmall.copyWith(
                              color: theme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Chat button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onChatTap?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.all(theme.spacingS),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: theme.textSecondary.withValues(alpha: 0.5),
                        size: 22,
                      ),
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

class _PulsingDot extends StatefulWidget {
  final Color color;

  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(color: theme.backgroundLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NetworkMemberData {
  final String id;
  final String name;
  final String avatarUrl;
  final String? status;
  final bool isOnline;

  const NetworkMemberData({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.status,
    this.isOnline = false,
  });
}
